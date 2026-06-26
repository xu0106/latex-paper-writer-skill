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
check_optional_cmd latexmk
check_optional_cmd tectonic
check_optional_cmd pdflatex
check_optional_cmd xelatex
check_optional_cmd bibtex
check_optional_cmd unzip
check_optional_cmd rsync

if command -v tectonic >/dev/null 2>&1; then
  printf "[ok] %-10s %s\n" "tex-route" "tectonic"
elif command -v pdflatex >/dev/null 2>&1 || command -v xelatex >/dev/null 2>&1; then
  printf "[ok] %-10s %s\n" "tex-route" "TeX distribution"
else
  printf "[missing] %-10s %s\n" "tex-route" "install tectonic or a TeX distribution"
  status=1
fi
echo

if command -v codex >/dev/null 2>&1; then
  if codex mcp list 2>/dev/null | grep -qi '^zotero[[:space:]]'; then
    echo "[ok] zotero MCP is configured"
  else
    echo "[warn] zotero MCP was not found in codex mcp list"
    echo "       Citation lookup will be limited until Zotero MCP is registered."
    echo "       Typical local-only setup:"
    echo "       codex mcp add zotero --env ZOTERO_LOCAL=true -- uvx --upgrade zotero-mcp"
  fi
else
  echo "[warn] codex CLI not found on PATH"
  echo "       Cannot check or register Zotero MCP from this shell."
fi

if command -v curl >/dev/null 2>&1; then
  if curl -fsS --max-time 2 http://127.0.0.1:23119/api >/dev/null 2>&1; then
    echo "[ok] zotero local API responds"
  else
    echo "[warn] Zotero local API did not respond at http://127.0.0.1:23119/api"
    echo "       Open Zotero and enable: Settings -> Advanced -> Allow other applications on this computer to communicate with Zotero."
  fi
else
  echo "[warn] curl not found; cannot check Zotero local API"
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
  echo "Recommended install routes:"
  echo "  Ubuntu/WSL2: sudo apt install -y pandoc texlive-xetex texlive-latex-extra texlive-fonts-recommended latexmk"
  echo "  conda install -y -c conda-forge pandoc tectonic"
fi

exit "$status"
