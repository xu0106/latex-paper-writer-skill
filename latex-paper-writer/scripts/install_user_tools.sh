#!/usr/bin/env bash
set -euo pipefail

echo "== latex-paper-writer user tool install =="

if command -v pandoc >/dev/null 2>&1 && command -v tectonic >/dev/null 2>&1; then
  echo "[ok] pandoc and tectonic are already installed"
  pandoc --version | head -n 1
  tectonic --version
  exit 0
fi

if command -v conda >/dev/null 2>&1; then
  echo "Installing pandoc and tectonic with conda-forge..."
  conda install -y -c conda-forge pandoc tectonic
  exit 0
fi

cat <<'MSG'
[blocked] conda was not found, so this script will not install system packages automatically.

Ask the user which install route they prefer:
  1. Install conda/micromamba, then run:
     conda install -y -c conda-forge pandoc tectonic
  2. Use system packages, for example:
     sudo apt-get install pandoc texlive-xetex texlive-latex-extra texlive-fonts-recommended latexmk
  3. Provide an existing TeX/Pandoc environment path.

Do not run sudo or download installers without explicit user approval.
MSG
exit 2
