param(
    [Parameter(Mandatory = $true)][string]$InputMarkdown,
    [Parameter(Mandatory = $true)][string]$OutputTex,
    [string]$BibFile = ""
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path -LiteralPath $InputMarkdown -PathType Leaf)) {
    Write-Error "[error] input markdown not found: $InputMarkdown"
    exit 1
}

$outDir = Split-Path -Parent $OutputTex
if ($outDir -and -not (Test-Path -LiteralPath $outDir)) {
    New-Item -ItemType Directory -Force -Path $outDir | Out-Null
}

$pandocArgs = @(
    $InputMarkdown,
    "--from", "markdown+tex_math_dollars+raw_tex",
    "--to", "latex",
    "--standalone=false",
    "-o", $OutputTex
)

if ($BibFile) {
    if (-not (Test-Path -LiteralPath $BibFile -PathType Leaf)) {
        Write-Error "[error] bibliography file not found: $BibFile"
        exit 1
    }
    $pandocArgs += @("--bibliography", $BibFile)
}

& pandoc @pandocArgs
if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}

Write-Host "[ok] wrote $OutputTex"
$tex = Get-Content -LiteralPath $OutputTex -Raw -ErrorAction SilentlyContinue
if ($tex -match "@[A-Za-z0-9_:-]+") {
    Write-Host "[warn] raw Pandoc citation markers may remain in $OutputTex"
}
