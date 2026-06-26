#!/usr/bin/env bash
set -u

ROOT="${1:-.}"
status=0

echo "== latex-paper-writer environment check =="
echo "Root: $ROOT"
echo

check_cmd() {
  local name="$1"
  if command -v "$name" >/dev/null 2>&1; then
    printf "[ok] %-10s %s\n" "$name" "$(command -v "$name")"
  else
    printf "[missing] %-10s\n" "$name"
    status=1
  fi
}

check_optional_cmd() {
  local name="$1"
  if command -v "$name" >/dev/null 2>&1; then
    printf "[ok] %-10s %s\n" "$name" "$(command -v "$name")"
  else
    printf "[optional-missing] %-10s\n" "$name"
  fi
}

check_cmd pandoc
check_cmd tectonic
check_optional_cmd latexmk
check_optional_cmd pdflatex
check_optional_cmd xelatex
check_optional_cmd bibtex
check_optional_cmd unzip
check_optional_cmd rsync
echo

if command -v codex >/dev/null 2>&1; then
  if codex mcp list 2>/dev/null | grep -qi '^zotero[[:space:]]'; then
    echo "[ok] zotero MCP is configured"
  else
    echo "[warn] zotero MCP was not found in codex mcp list"
  fi
else
  echo "[warn] codex CLI not found on PATH"
fi
echo

if [ -d "$ROOT" ]; then
  echo "Likely LaTeX entrypoints:"
  find "$ROOT" -maxdepth 3 -type f -name '*.tex' -print 2>/dev/null | while read -r f; do
    if grep -q '\\documentclass' "$f" 2>/dev/null; then
      echo "  [main?] $f"
    fi
  done

  echo
  echo "Bibliography files:"
  find "$ROOT" -maxdepth 3 -type f -name '*.bib' -print 2>/dev/null | sed 's/^/  /'

  echo
  echo "Class/style files:"
  find "$ROOT" -maxdepth 3 -type f \( -name '*.cls' -o -name '*.sty' -o -name '*.bst' \) -print 2>/dev/null | sed 's/^/  /'
else
  echo "[warn] root is not a directory: $ROOT"
  status=1
fi

echo
if [ "$status" -ne 0 ]; then
  echo "Recommended user-level install when conda is available:"
  echo "  conda install -y -c conda-forge pandoc tectonic"
fi

exit "$status"
