$ErrorActionPreference = "Stop"

Write-Host "== latex-paper-writer user tool install =="

$hasPandoc = Get-Command pandoc -ErrorAction SilentlyContinue
$hasTectonic = Get-Command tectonic -ErrorAction SilentlyContinue
$hasPdfLaTeX = Get-Command pdflatex -ErrorAction SilentlyContinue
$hasXeLaTeX = Get-Command xelatex -ErrorAction SilentlyContinue
$hasTexRoute = $hasTectonic -or $hasPdfLaTeX -or $hasXeLaTeX

if ($hasPandoc -and $hasTexRoute) {
    Write-Host "[ok] pandoc and a LaTeX compile route are already installed"
    & pandoc --version | Select-Object -First 1
    if ($hasTectonic) {
        & tectonic --version
    }
    exit 0
}

if (Get-Command conda -ErrorAction SilentlyContinue) {
    $packages = @()
    if (-not $hasPandoc) {
        $packages += "pandoc"
    }
    if (-not $hasTexRoute) {
        $packages += "tectonic"
    }
    Write-Host "Installing $($packages -join ', ') with conda-forge..."
    & conda install -y -c conda-forge @packages
    exit $LASTEXITCODE
}

Write-Host @"
[blocked] conda was not found, so this script will not install tools automatically.

Ask the user which Windows install route they prefer:
  1. Install Miniconda or Mambaforge, then run:
     conda install -y -c conda-forge pandoc tectonic
  2. Install Pandoc from https://pandoc.org/installing.html
     and install MiKTeX or TeX Live for LaTeX compilation.
  3. Use WSL2 and run the Bash scripts instead.
  4. Provide an existing TeX/Pandoc environment path.

Do not download installers, modify PATH, or run elevated installers without explicit user approval.
"@
exit 2
