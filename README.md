# PESAD

PESAD (Prolog Expert System for Anxiety, Obsessive-Compulsive and Trauma-Related Disorders) is a rule-based expert system for diagnosing, under uncertainty, the disorders of the DSM-5-TR Anxiety, Obsessive-Compulsive and Related, and Trauma- and Stressor-Related chapters.

This code was developed during the Artificial Intelligence Fundamentals course @ [Department of Computer Science](https://www.di.unipi.it/en/) @ [University of Pisa](https://www.unipi.it/index.php/english).

The [American Psychiatric Association](https://www.psychiatry.org/) knowledge base is built from the diagnostic criteria of the [DSM-5-TR Diagnostic and Statistical Manual of Mental Disorders](https://www.psychiatry.org/psychiatrists/practice/dsm/about-dsm).

## Prerequisites

To run the expert system you have to download [SWI-Prolog](https://www.swi-prolog.org/Download.html) for your operating system.

## Running the expert system

To run the expert system you just type into the terminal:

```
$ swipl start.pl
```

At start-up the system asks you to choose the interface language (English or
Italian) and the uncertainty method (certainty factors / minimum t-norm, the
default, or fuzzy / product t-norm). Only the questions, diagnoses and
explanations the user reads are shown in the selected language, while the
commands are always in English: `investigation`, `control`, `facts`, `help`,
`clean`, `quit`.

## Testing

A small regression suite of clinical vignettes (one per disorder family) runs
the whole inference under both uncertainty methods and checks the top-ranked
diagnosis:

```
$ swipl clinical_tests.pl
```

## Project structure

The system is organized by responsibility:

| File | Responsibility |
| --- | --- |
| `start.pl` | Bootstrap: directives and module loading |
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

## License [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

This software is released under the MIT License. See the [LICENSE](LICENSE) file for details. 