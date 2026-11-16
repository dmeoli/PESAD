#!/usr/bin/env python3
"""
Mutation test of the knowledge base against the validation suite.

Each mutant is a copy of prolog/ with one error injected in criteria.pl or
disorders.pl: the threshold M of an "at least M of N" criterion raised by 1,
lowered by 1 (when M >= 2), or a premise required false required true. The
suite (prolog/clinical_tests.pl) runs on each mutant under the method cf, and
the mutant is killed when a case fails. Prints the survivors and a summary.

Usage: python3 tools/mutate.py [-j WORKERS]

Author: Donato Meoli
"""

import argparse
import os
import re
import shutil
import subprocess
import sys
import tempfile
from collections import Counter
from concurrent.futures import ThreadPoolExecutor

PROLOG = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "prolog")
METHODS = "methods([cf,fuzzy,fuzzy_membership,lukasiewicz,hamacher,einstein])."


def mutants():
    """(file, start, end, replacement, kind) for every mutation."""
    out = []
    for name in ("criteria.pl", "disorders.pl"):
        text = open(os.path.join(PROLOG, name)).read()
        for m in re.finditer(r"symptom\(\[[^\]]*\],(\d+),", text):
            k = int(m.group(1))
            if k >= 2:
                out.append((name, m.start(1), m.end(1), str(k - 1), "threshold lowered"))
            out.append((name, m.start(1), m.end(1), str(k + 1), "threshold raised"))
        for m in re.finditer(r",false\)", text):
            out.append((name, m.start(), m.end(), ",true)", "false made true"))
    return out


def run(workdir, index, mutant):
    """Run the suite on one mutant; True if it is killed."""
    name, start, end, replacement, kind = mutant
    copy = os.path.join(workdir, f"m{index}")
    shutil.copytree(PROLOG, copy)
    path = os.path.join(copy, name)
    text = open(path).read()
    open(path, "w").write(text[:start] + replacement + text[end:])
    suite = os.path.join(copy, "clinical_tests.pl")
    source = open(suite).read()
    assert METHODS in source
    open(suite, "w").write(source.replace(METHODS, "methods([cf])."))
    try:
        killed = subprocess.run(["swipl", suite], cwd=copy, capture_output=True,
                                timeout=600).returncode != 0
    except subprocess.TimeoutExpired:
        killed = True
    shutil.rmtree(copy, ignore_errors=True)
    line = text[:start].count("\n") + 1
    return kind, f"{name}:{line} {kind} ({text[start:end]} -> {replacement})", killed


def main():
    parser = argparse.ArgumentParser(description=__doc__.split("\n\n")[1])
    parser.add_argument("-j", type=int, default=max(1, (os.cpu_count() or 2) // 2),
                        help="parallel workers (default: half the CPUs)")
    args = parser.parse_args()
    ms = mutants()
    with tempfile.TemporaryDirectory() as workdir, ThreadPoolExecutor(args.j) as pool:
        results = list(pool.map(lambda x: run(workdir, *x), enumerate(ms)))
    total, killed = Counter(), Counter()
    for kind, where, dead in results:
        total[kind] += 1
        killed[kind] += dead
        if not dead:
            print("survived:", where)
    for kind in total:
        print(f"{kind}: {killed[kind]}/{total[kind]} killed")
    print(f"total: {sum(killed.values())}/{sum(total.values())} killed")
    sys.exit(0 if killed == total else 1)


if __name__ == "__main__":
    main()
