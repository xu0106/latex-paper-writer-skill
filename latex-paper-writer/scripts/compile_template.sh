#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
  echo "Usage: $0 TEMPLATE_WORKDIR [MAIN_TEX]" >&2
  exit 2
fi

WORKDIR="$1"
MAIN="${2:-}"

if [ ! -d "$WORKDIR" ]; then
  echo "[error] template workdir not found: $WORKDIR" >&2
  exit 1
fi

cd "$WORKDIR"

if [ -z "$MAIN" ]; then
  MAIN="$(find . -maxdepth 3 -type f -name '*.tex' -exec grep -l '\\documentclass' {} \; | head -n 1 | sed 's#^\./##')"
fi

if [ -z "$MAIN" ] || [ ! -f "$MAIN" ]; then
  echo "[error] could not find a main .tex file with \\documentclass" >&2
  echo "Ask the user for the complete template or pass MAIN_TEX explicitly." >&2
  exit 1
fi

BASE="${MAIN%.tex}"
LOG="${BASE}.log"
echo "== compiling $MAIN in $WORKDIR =="

run_ok=0
if [ -f Makefile ] && command -v make >/dev/null 2>&1; then
  echo "[try] make"
  if make; then run_ok=1; fi
fi

if [ "$run_ok" -eq 0 ] && command -v latexmk >/dev/null 2>&1; then
  echo "[try] latexmk -pdf"
  if latexmk -interaction=nonstopmode -halt-on-error -pdf "$MAIN"; then run_ok=1; fi
fi

if [ "$run_ok" -eq 0 ] && command -v tectonic >/dev/null 2>&1; then
  echo "[try] tectonic"
  if tectonic "$MAIN"; then run_ok=1; fi
fi

if [ "$run_ok" -eq 0 ] && command -v pdflatex >/dev/null 2>&1; then
  echo "[try] pdflatex/bibtex/pdflatex/pdflatex"
  pdflatex -interaction=nonstopmode -halt-on-error "$MAIN"
  if [ -f "${BASE}.aux" ] && command -v bibtex >/dev/null 2>&1; then
    bibtex "$BASE" || true
  fi
  pdflatex -interaction=nonstopmode -halt-on-error "$MAIN"
  pdflatex -interaction=nonstopmode -halt-on-error "$MAIN"
  run_ok=1
fi

if [ "$run_ok" -eq 0 ]; then
  echo "[error] no compile route succeeded" >&2
  exit 1
fi

PDF="${BASE}.pdf"
if [ -f "$PDF" ]; then
  echo "[ok] PDF: $WORKDIR/$PDF"
else
  found_pdf="$(find . -maxdepth 2 -type f -name '*.pdf' | head -n 1 | sed 's#^\./##')"
  if [ -n "$found_pdf" ]; then
    echo "[ok] PDF: $WORKDIR/$found_pdf"
  else
    echo "[warn] compile command succeeded but no PDF was found"
  fi
fi

echo
echo "== issue scan =="
if [ -f "$LOG" ]; then
  grep -Ei "undefined references|undefined citation|citation .* undefined|LaTeX Error|Package .* Error|Missing character|File .* not found|Overfull \\\\hbox" "$LOG" || true
else
  echo "[warn] log file not found: $LOG"
fi
