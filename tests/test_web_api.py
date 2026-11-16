#!/usr/bin/env python3
"""Tests for the PESAD web API.

Drives complete consultations through POST /step, the way the site does:
every request carries all the answers given so far, and the next answer is
chosen from the question returned. Each language is run on a vignette that
leads to a disorder (a specific phobia, animal type) and on one that leads to
none, then on each chapter alone (the area question, or "chapters"), plus the
request checks (bad answers, limits, CORS). POST /evaluate is
run on test results (DIVA-5, ASRS, IQ and achievement scores) under every
backend. Exits non-zero on any mismatch so it can gate CI.
"""

import os
import sys

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "web_api"))

from fastapi.testclient import TestClient  # noqa: E402

from app import MAX_ANSWERS, METHODS, app  # noqa: E402

# Neutral answers to the multiple-choice questions (as in clinical_tests.pl).
CHOICES = {
    "patient": "adult",
    "area": "all",
    "attack_type": "cued_attack",
    "panic_attacks_frequency": "one_or_fewer",
    "symptoms_duration": "less_than_three_days",
    "symptoms_onset": "no_onset",
    "bereavement_time": "less_than_six_months",
    "anxiety_type": "other_anxiety_type",
    "phobic_reaction_type": "endurance_without_problems",
    "adjustment_subtype": "unspecified_adjustment",
    "insight_level": "insight_good_or_fair",
    "substance_onset": "onset_during_intoxication",
    "ocrd_presentation": "with_ocd_like_symptoms",
    "adhd_severity": "severity_mild",
    "learning_disorder_severity": "severity_mild",
    "idd_severity": "severity_mild",
    "asd_social_communication_support": "requiring_support",
    "asd_restricted_behaviour_support": "requiring_support",
    "duration_months": "0",          # graded values of fuzzy_membership
    "panic_attacks_count": "1",
}

# A 22-year-old with a marked fear of spiders, avoided for over a year.
PHOBIA = {
    "yes": {"marked_fear_of_specific_object_or_situation",
            "fear_almost_always_provoked",
            "fear_out_of_proportion_to_actual_danger", "fear_of_animals",
            "occupational_distress", "social_distress"},
    "choices": {"phobic_reaction_type": "avoidance",
                "symptoms_duration": "six_months_or_more",
                "duration_months": "12"},
}
NOTHING = {"yes": set(), "choices": {}}


def choose(question, case):
    """The answer of `case` to `question`."""
    qid = question["id"]
    if qid.endswith(".certainty"):
        return "1.0"
    values = [o["value"] for o in question["options"]]
    if values == ["yes", "no"]:
        return "yes" if qid in case["yes"] else "no"
    answer = case["choices"].get(qid, CHOICES[qid])
    assert answer in values, f"{answer!r} not an option of {qid}"
    return answer


def consult(client, lang, case, backend="cf", chapters=None):
    """Run a whole consultation and return the result."""
    answers = []
    while True:
        body = {"lang": lang, "answers": answers, "backend": backend}
        if chapters:
            body["chapters"] = chapters
        r = client.post("/step", json=body)
        assert r.status_code == 200, (r.status_code, r.text)
        screen = r.json()
        assert screen["step"] == len(answers)
        if screen["kind"] == "result":
            return screen, answers
        assert screen["kind"] == "question" and screen["text"] and screen["options"]
        assert not (chapters and screen["id"] == "area")
        assert not screen["multi"]
        assert ("disclaimer" in screen) == (len(answers) == 0)
        answers.append(choose(screen, case))
        assert len(answers) < MAX_ANSWERS


# An adult with a DIVA-5 of 7 inattention and 3 hyperactivity symptoms,
# childhood symptoms confirmed by a parent, in 3 settings, impairing at work.
DIVA = [{"finding": "diva5_inattention_count", "value": 7},
        {"finding": "diva5_hyperactivity_count", "value": 3},
        {"finding": "diva5_childhood_inattention_count", "value": 6},
        {"finding": "informant_confirms_childhood_symptoms", "value": True},
        {"finding": "settings_with_symptoms", "value": 3},
        {"finding": "symptom_duration_months", "value": 240},
        {"item": "occupational_distress", "value": True},
        {"item": "adhd_symptoms_better_explained_by_other_disorder", "value": False}]
INATTENTIVE = "attention_deficit_hyperactivity_disorder_predominantly_inattentive_presentation"
COMBINED = "attention_deficit_hyperactivity_disorder_combined_presentation"


def goal(reply, goal_id):
    return next(g for g in reply["goals"] if g["id"] == goal_id)


def check_evaluate(client):
    """POST /evaluate on test results, and its request checks."""
    catalogue = client.get("/findings").json()
    assert {f["id"] for f in catalogue["findings"]} >= {"diva5_inattention_count", "iq_full_scale"}
    assert "careless_mistakes" in catalogue["items"]

    for backend in METHODS:
        r = client.post("/evaluate", json={"lang": "en", "backend": backend, "age": 30, "facts": DIVA})
        assert r.status_code == 200, (r.status_code, r.text)
        reply = r.json()
        assert reply["age_band"] == "adult" and reply["disclaimer"]
        g = goal(reply, INATTENTIVE)
        assert g["status"] == "present" and g["certainty"] >= 0.5, (backend, g["status"])
        assert g["icd10cm"] == "F90.0" and g["icd11"] == "6A05.0" and g["tree"] and g["explanation"]
        assert {c["status"] for c in g["criteria"]} == {"met"}, backend
        assert any(d["family"] == "autism_spectrum_disorder" for d in g["differentials"])
        assert goal(reply, COMBINED)["status"] == "absent", backend
        print(f"test_web_api: /evaluate {backend} OK")

    # a screening scale alone leaves the diagnosis open and lists what is missing
    reply = client.post("/evaluate", json={"lang": "it", "age": 25, "facts": [
        {"finding": "asrs_inattention_count", "value": 8},
        {"finding": "asrs_hyperactivity_count", "value": 7}]}).json()
    g = goal(reply, COMBINED)
    assert g["status"] == "undetermined" and g["certainty"] < 0.5 <= g["upper"]
    assert "several_symptoms_before_age_twelve" in {m["id"] for m in g["missing"]}
    assert g["name"].startswith("Disturbo da Deficit")

    # IQ and achievement scores, restricted to the goals asked for
    reply = client.post("/evaluate", json={"age": 10, "goals": [
        "specific_learning_disorder_with_impairment_in_reading", "intellectual_developmental_disorder_mild"],
        "facts": [{"finding": "iq_full_scale", "value": 104},
                  {"finding": "reading_standard_score", "value": 72},
                  {"finding": "intervention_months", "value": 9},
                  {"finding": "school_report_learning_difficulties", "value": True},
                  {"finding": "symptom_duration_months", "value": 14},
                  {"item": "inaccurate_or_slow_word_reading", "value": True},
                  {"item": "other_functional_distress", "value": True, "certainty": 0.9},
                  {"item": "learning_difficulties_better_accounted_for_by_other_factors", "value": False}]}).json()
    assert [g["id"] for g in reply["goals"]] == [
        "specific_learning_disorder_with_impairment_in_reading", "intellectual_developmental_disorder_mild"]
    assert goal(reply, "specific_learning_disorder_with_impairment_in_reading")["status"] == "present"
    assert goal(reply, "intellectual_developmental_disorder_mild")["status"] == "absent"

    for body, index in (({"age": 30, "facts": [{"finding": "wisc_vi", "value": 1}]}, 0),
                        ({"age": 30, "facts": [{"finding": "diva5_inattention_count", "value": 12}]}, 0),
                        ({"age": 30, "facts": [{"item": "careless_mistakes", "value": True},
                                               {"item": "careless_mistakes", "choice": "x", "value": True}]}, 1),
                        ({"facts": []}, None),
                        ({"age": 30, "goals": ["no_such_goal"]}, None)):
        r = client.post("/evaluate", json=body)
        assert r.status_code == 400 and r.json()["index"] == index, (body, r.status_code, r.text)
    for body in ({"age": 30, "chapters": ["neuro"]}, {"age": 300},
                 {"age": 30, "facts": [{"item": "a", "value": True, "extra": 1}]}):
        assert client.post("/evaluate", json=body).status_code == 400, body


def main():
    with TestClient(app) as client:
        assert client.get("/").json() == {"ok": True}

        for lang in ("en", "it"):
            result, answers = consult(client, lang, PHOBIA)
            assert result["items"], "no disorder found"
            top = result["items"][0]
            assert top["id"] == "specific_phobia_animal_type", top["id"]
            assert top["score"].endswith("%") and top["detail"]
            assert result["disclaimer"] and result["title"] and result["text"]

            # past the result there is nothing left to answer
            r = client.post("/step", json={"lang": lang, "answers": answers + ["no"]})
            assert r.status_code == 400, r.status_code

            result, _ = consult(client, lang, NOTHING)
            assert result["items"] == [], result["items"]
            assert result["text"] and result["disclaimer"]
            print(f"test_web_api: {lang} consultations OK ({len(answers)} answers)")

        for backend in METHODS:
            result, _ = consult(client, "en", PHOBIA, backend)
            assert result["items"][0]["id"] == "specific_phobia_animal_type", backend
            print(f"test_web_api: {backend} consultation OK")

        # the area question restricts the investigation to some chapters
        second = client.post("/step", json={"lang": "en", "answers": ["adult"]}).json()
        assert second["id"] == "area" and not second["multi"]
        assert [o["value"] for o in second["options"]] == [
            "neurodevelopmental", "anxiety", "obsessive_compulsive", "trauma", "all"]
        full = len(consult(client, "en", NOTHING)[1])
        for chapter in ("neurodevelopmental", "anxiety", "obsessive_compulsive", "trauma"):
            result, answers = consult(client, "en", PHOBIA, chapters=[chapter])
            found = [i["id"] for i in result["items"]][:1]
            assert found == (["specific_phobia_animal_type"] if chapter == "anxiety" else []), chapter
            _, asked = consult(client, "en", {**NOTHING, "choices": {"area": chapter}})
            assert len(asked) - 1 < full // 2, chapter
            print(f"test_web_api: {chapter} consultation OK ({len(answers)} answers, "
                  f"{len(asked)} with no symptom, {full} for all the areas)")
        result, answers = consult(client, "en", PHOBIA, chapters=["anxiety", "trauma"])
        assert result["items"][0]["id"] == "specific_phobia_animal_type"

        check_evaluate(client)

        first = client.post("/step", json={"lang": "it", "answers": []}).json()
        assert first["id"] == "patient" and first["disclaimer"]
        assert {o["label"] for o in first["options"]} >= {">= 18 anni"}

        for body in ({"lang": "en", "answers": ["maybe"]},      # not an option
                     {"lang": "en", "answers": ["adult", "why"]},
                     {"lang": "fr", "answers": []},
                     {"lang": "en", "answers": [], "backend": "bayes"},
                     {"lang": "en", "answers": [], "chapters": ["neuro"]},
                     {"lang": "en", "answers": [], "chapters": []},
                     {"lang": "en", "answers": "adult"},
                     {"lang": "en", "answers": ["no"] * (MAX_ANSWERS + 1)}):
            r = client.post("/step", json=body)
            assert r.status_code == 400, (body, r.status_code)

        r = client.post("/step", content=b" " * (70 * 1024),
                        headers={"Content-Type": "application/json"})
        assert r.status_code == 413, r.status_code

        r = client.options("/step", headers={
            "Origin": "https://dmeoli.github.io",
            "Access-Control-Request-Method": "POST"})
        assert r.headers.get("access-control-allow-origin") == "https://dmeoli.github.io"
    print("test_web_api: OK")


if __name__ == "__main__":
    main()
