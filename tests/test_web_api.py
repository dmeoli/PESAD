#!/usr/bin/env python3
"""Tests for the PESAD web API.

Drives complete consultations through POST /step, the way the site does:
every request carries all the answers given so far, and the next answer is
chosen from the question returned. Each language is run on a vignette that
leads to a disorder (a specific phobia, animal type) and on one that leads to
none, plus the request checks (bad answers, limits, CORS). Exits non-zero on
any mismatch so it can gate CI.
"""

import os
import sys

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "web_api"))

from fastapi.testclient import TestClient  # noqa: E402

from app import MAX_ANSWERS, METHODS, app  # noqa: E402

# Neutral answers to the multiple-choice questions (as in clinical_tests.pl).
CHOICES = {
    "patient": "adult",
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


def consult(client, lang, case, backend="cf"):
    """Run a whole consultation and return the result."""
    answers = []
    while True:
        r = client.post("/step", json={"lang": lang, "answers": answers,
                                       "backend": backend})
        assert r.status_code == 200, (r.status_code, r.text)
        screen = r.json()
        assert screen["step"] == len(answers)
        if screen["kind"] == "result":
            return screen, answers
        assert screen["kind"] == "question" and screen["text"] and screen["options"]
        assert not screen["multi"]
        assert ("disclaimer" in screen) == (len(answers) == 0)
        answers.append(choose(screen, case))
        assert len(answers) < MAX_ANSWERS


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

        first = client.post("/step", json={"lang": "it", "answers": []}).json()
        assert first["id"] == "patient" and first["disclaimer"]
        assert {o["label"] for o in first["options"]} >= {">= 18 anni"}

        for body in ({"lang": "en", "answers": ["maybe"]},      # not an option
                     {"lang": "en", "answers": ["adult", "why"]},
                     {"lang": "fr", "answers": []},
                     {"lang": "en", "answers": [], "backend": "bayes"},
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
