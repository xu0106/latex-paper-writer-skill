#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 2 ] || [ "$#" -gt 3 ]; then
  echo "Usage: $0 INPUT.md OUTPUT.tex [BIBFILE]" >&2
  exit 2
fi

INPUT="$1"
OUTPUT="$2"
BIB="${3:-}"

if [ ! -f "$INPUT" ]; then
  echo "[error] input markdown not found: $INPUT" >&2
  exit 1
fi

mkdir -p "$(dirname "$OUTPUT")"

args=(--from markdown+tex_math_dollars+raw_tex --to latex --standalone=false)
if [ -n "$BIB" ]; then
  if [ ! -f "$BIB" ]; then
    echo "[error] bibliography file not found: $BIB" >&2
    exit 1
  fi
  args+=(--bibliography "$BIB")
fi

pandoc "$INPUT" "${args[@]}" -o "$OUTPUT"

echo "[ok] wrote $OUTPUT"
if grep -n '@[A-Za-z0-9_:-]\+' "$OUTPUT" >/dev/null 2>&1; then
  echo "[warn] raw Pandoc citation markers may remain in $OUTPUT"
fi
