# PESAD :brain:

[![CI](https://github.com/dmeoli/PESAD/actions/workflows/ci.yml/badge.svg)](https://github.com/dmeoli/PESAD/actions/workflows/ci.yml)
[![Telegram](https://img.shields.io/badge/Telegram-%40PESADBot-26A5E4?logo=telegram&logoColor=white)](https://t.me/PESADBot)
[![Technical report](https://img.shields.io/badge/report-PDF-b31b1b?logo=adobeacrobatreader&logoColor=white)](doc/PESAD.pdf)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

PESAD (Prolog Expert System for Anxiety, Obsessive-Compulsive and Trauma-Related Disorders) is a rule-based expert system for diagnosing, under uncertainty, the disorders of the DSM-5-TR Anxiety, Obsessive-Compulsive and Related, and Trauma- and Stressor-Related chapters.

This code was developed during the Artificial Intelligence Fundamentals course @ [Department of Computer Science](https://www.di.unipi.it/en/) @ [University of Pisa](https://www.unipi.it/index.php/english).

The [American Psychiatric Association](https://www.psychiatry.org/) knowledge base is built from the diagnostic criteria of the [DSM-5-TR Diagnostic and Statistical Manual of Mental Disorders](https://www.psychiatry.org/psychiatrists/practice/dsm/about-dsm).

## Prerequisites

To run the expert system you have to download [SWI-Prolog](https://www.swi-prolog.org/Download.html) for your operating system.

## Running the expert system

To run the expert system you just type into the terminal:

```
$ swipl prolog/start.pl
```

At start-up the system asks you to choose the interface language (English or
Italian) and the uncertainty method (certainty factors / minimum t-norm, the
default, or fuzzy / product t-norm). Only the questions, diagnoses and
explanations the user reads are shown in the selected language, while the
commands are always in English: `investigation`, `control`, `facts`, `help`,
`clean`, `quit`.

## Testing

The validation suite runs original clinical vignettes, written from the
DSM-5-TR criteria, through the whole inference under the three uncertainty
methods. For every diagnostic goal it checks a typical case, a subthreshold
case, an exclusion case and a differential case, plus comorbidity, specifier
and age-rule cases, and prints a goal by case-type table:

```
$ swipl prolog/clinical_tests.pl
```

The criteria sheets in [`doc/`](doc/) give, for every disorder, the paraphrased
criteria, the ICD-10-CM and ICD-11 codes and the clause that implements each
criterion.

## Telegram bot

The expert system is also available as a Telegram bot that drives the very same
engine over the SWI-Prolog Machine Query Interface. See
[`telegram_bot/`](telegram_bot/README.md) for how it works, how to run it, and
[`telegram_bot/DEPLOY.md`](telegram_bot/DEPLOY.md) for deployment.

## Web API

The same engine also serves a stateless web API (FastAPI) for the expert-system
section of [dmeoli.github.io](https://dmeoli.github.io). Each request carries the
language and all the answers given so far; the server starts a fresh Prolog
session, replays them and returns the next question or the result:

```
$ curl -X POST https://pesad-372868569544.europe-west1.run.app/step \
       -H 'Content-Type: application/json' -d '{"lang": "en", "answers": ["adult", "no"]}'
{"kind": "question", "id": "distress_at_separation_from_attachment_figures.certainty",
 "text": "Enter the certainty degree", "help": "(from 0.0 to 1.0)", "why": null,
 "options": [{"value": "0.0", "label": "0.0"}, ...], "multi": false, "step": 2}
```

The answers are the `value`s of the options; an answer that is not an option of
its question gives a 400. The result (`"kind": "result"`) lists the disorders
supported by the answers with their certainty degree and proof tree. Nothing is
stored and the answers are never logged. Run it locally with `make api` and test
it with `make test-api`; `make deploy-api` builds it with Cloud Build and
deploys it to Cloud Run.

## Project structure

```
prolog/         Prolog sources (inference engine, knowledge base, bot bridge)
pesad_engine/   Engine layer shared by the bot and the web API (Python, swiplserver)
telegram_bot/   Telegram front-end (Python, python-telegram-bot)
web_api/        Web API (Python, FastAPI) and its Cloud Run image
doc/            Documentation
Dockerfile, docker-compose.yml   Containerised deployment
```

The Prolog system under `prolog/` is organized by responsibility:

| File | Responsibility |
| --- | --- |
| `start.pl` | Terminal bootstrap: directives and module loading, runs `main/0` |
| `shell.pl` | User shell: REPL loop, language selection, command dispatch, result presentation, `decode`/`explain` localization |
| `ask.pl` | Knowledge acquisition: the criterion / multiple / selective question protocols |
| `uncertainty.pl` | Certainty calculus (switchable min / product t-norm), certainty-based ordering, inference-level indexes |
| `explanation.pl` | Proof-tree printing (how a conclusion was reached) |
| `memory.pl` | Working-memory management (facts and proof trees) |
| `utils.pl` | General-purpose helpers |
| `disorders.pl` | Knowledge base: codable DSM-5-TR disorders (diagnostic goals) and entry points |
| `criteria.pl` | Knowledge base: sub-disorders, types/specifiers, symptomatic manifestations/features, questions |
| `interface_en.pl`, `interface_it.pl` | English / Italian localization (`label/3`, `explanation/3`) |
| `clinical_tests.pl` | Regression test suite over clinical vignettes |
| `bot_io.pl` | I/O abstraction (`ui_read/2`): terminal vs bot mode, structured description of each question |
| `bot_boot.pl`, `bot_session.pl` | Bot bootstrap (per-session thread-local state) and MQI session API |

## License

This software is released under the MIT License. See the [LICENSE](LICENSE) file for details. 