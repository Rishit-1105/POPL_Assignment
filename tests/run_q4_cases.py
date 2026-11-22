#!/usr/bin/env python3
"""Append one Q4 test call at a time to a temporary copy of the source."""

import argparse
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path


ROOT = Path(__file__).resolve().parent.parent
CHECK_HELPER = '''
(define (q4-check actual expected)
  (if (equal? actual expected)
      (begin (display "PASS") (newline))
      (begin
        (display "FAIL: expected ") (write expected)
        (display ", got ") (write actual) (newline)
        (exit 1))))
'''


def read_cases(path):
    cases = []
    label = None
    for number, line in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
        form = line.strip()
        if not form:
            continue
        if form.startswith(";"):
            label = form.lstrip(";").strip() or None
            continue
        if not form.startswith("(q4-check "):
            raise ValueError(f"{path}:{number}: expected one q4-check call per line")
        cases.append((label or f"line {number}", form))
        label = None
    if not cases:
        raise ValueError(f"{path}: no test calls found")
    return cases


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("source", nargs="?", type=Path,
                        default=ROOT / "code" / "75_q4.rkt",
                        help="Q4 source file (default: code/75_q4.rkt)")
    parser.add_argument("--cases", type=Path,
                        default=ROOT / "tests" / "q4_cases.rkt")
    parser.add_argument("--racket", default="racket",
                        help="Racket executable or its full path")
    args = parser.parse_args()

    if not args.source.is_file() or not args.cases.is_file():
        parser.error("source and cases files must both exist")
    racket = shutil.which(args.racket)
    if racket is None:
        parser.error(f"Racket executable not found: {args.racket}")
    try:
        cases = read_cases(args.cases)
    except ValueError as exc:
        parser.error(str(exc))

    passed = 0
    with tempfile.TemporaryDirectory(prefix="q4-cases-") as temp_dir:
        for index, (label, form) in enumerate(cases, 1):
            combined = Path(temp_dir) / f"case_{index}_{args.source.name}"
            shutil.copyfile(args.source, combined)
            with combined.open("a", encoding="utf-8") as output:
                output.write("\n" + CHECK_HELPER + "\n" + form + "\n")
            try:
                result = subprocess.run(
                    [racket, str(combined)], cwd=ROOT, stdin=subprocess.DEVNULL,
                    capture_output=True, text=True, timeout=30, check=False,
                )
            except subprocess.TimeoutExpired:
                print(f"ERROR {label}: timed out after 30 seconds")
                continue

            if result.returncode == 0 and result.stdout == "PASS\n":
                passed += 1
                print(f"PASS  {label}")
            else:
                status = "FAIL" if result.stdout.startswith("FAIL:") else "ERROR"
                print(f"{status}  {label}")
                if result.stdout.strip():
                    print(result.stdout.rstrip())
                if result.stderr.strip():
                    print(result.stderr.rstrip())

    print(f"{passed}/{len(cases)} passed")
    return 0 if passed == len(cases) else 1


if __name__ == "__main__":
    sys.exit(main())
