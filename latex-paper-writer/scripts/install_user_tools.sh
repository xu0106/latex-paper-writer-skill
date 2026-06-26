#!/usr/bin/env bash
set -euo pipefail

echo "== latex-paper-writer user tool install =="

has_tex_route=0
if command -v tectonic >/dev/null 2>&1 || command -v pdflatex >/dev/null 2>&1 || command -v xelatex >/dev/null 2>&1; then
  has_tex_route=1
fi

if command -v pandoc >/dev/null 2>&1 && [ "$has_tex_route" -eq 1 ]; then
  echo "[ok] pandoc and a LaTeX compile route are already installed"
  pandoc --version | head -n 1
  if command -v tectonic >/dev/null 2>&1; then
    tectonic --version
  fi
  exit 0
fi

if command -v conda >/dev/null 2>&1; then
  packages=()
  if ! command -v pandoc >/dev/null 2>&1; then
    packages+=(pandoc)
  fi
  if [ "$has_tex_route" -eq 0 ]; then
    packages+=(tectonic)
  fi
  echo "Installing ${packages[*]} with conda-forge..."
  conda install -y -c conda-forge "${packages[@]}"
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
