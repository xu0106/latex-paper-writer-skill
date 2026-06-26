param(
    [string]$Root = "."
)

$ErrorActionPreference = "Continue"
$status = 0

Write-Host "== latex-paper-writer environment check =="
Write-Host "Root: $Root"
Write-Host ""

function Test-Command {
    param(
        [string]$Name,
        [switch]$Optional
    )

    $cmd = Get-Command $Name -ErrorAction SilentlyContinue
    if ($cmd) {
        Write-Host ("[ok] {0,-10} {1}" -f $Name, $cmd.Source)
    } elseif ($Optional) {
        Write-Host ("[optional-missing] {0,-10}" -f $Name)
    } else {
        Write-Host ("[missing] {0,-10}" -f $Name)
        $script:status = 1
    }
}

Test-Command pandoc
Test-Command tectonic
Test-Command latexmk -Optional
Test-Command pdflatex -Optional
Test-Command xelatex -Optional
Test-Command bibtex -Optional
Test-Command 7z -Optional
Test-Command tar -Optional
Write-Host ""

if (Get-Command codex -ErrorAction SilentlyContinue) {
    $mcpList = & codex mcp list 2>$null
    if ($LASTEXITCODE -eq 0 -and ($mcpList -match "(?im)^zotero\s")) {
        Write-Host "[ok] zotero MCP is configured"
    } else {
        Write-Host "[warn] zotero MCP was not found in codex mcp list"
        Write-Host "       Citation lookup will be limited until Zotero MCP is registered."
        Write-Host "       Typical local-only setup:"
        Write-Host "       codex mcp add zotero --env ZOTERO_LOCAL=true -- uvx --upgrade zotero-mcp"
    }
} else {
    Write-Host "[warn] codex CLI not found on PATH"
    Write-Host "       Cannot check or register Zotero MCP from this shell."
}
Write-Host ""

if (Get-Command zotero -ErrorAction SilentlyContinue) {
    Write-Host "[ok] zotero command found"
} else {
    $zoteroCandidates = @(
        "$env:LOCALAPPDATA\Programs\Zotero\zotero.exe",
        "$env:ProgramFiles\Zotero\zotero.exe",
        "${env:ProgramFiles(x86)}\Zotero\zotero.exe"
    ) | Where-Object { $_ -and (Test-Path -LiteralPath $_ -PathType Leaf) }

    if ($zoteroCandidates.Count -gt 0) {
        Write-Host ("[ok] zotero desktop found at {0}" -f $zoteroCandidates[0])
    } else {
        Write-Host "[warn] Zotero desktop was not found in common Windows locations"
        Write-Host "       Install Zotero and enable its local API for Zotero-first citation workflows."
    }
}
Write-Host ""

if (Test-Path -LiteralPath $Root -PathType Container) {
    Write-Host "Likely LaTeX entrypoints:"
    Get-ChildItem -LiteralPath $Root -Recurse -Depth 3 -Filter *.tex -ErrorAction SilentlyContinue |
        ForEach-Object {
            $content = Get-Content -LiteralPath $_.FullName -Raw -ErrorAction SilentlyContinue
            if ($content -match "\\documentclass") {
                Write-Host ("  [main?] {0}" -f $_.FullName)
            }
        }

    Write-Host ""
    Write-Host "Bibliography files:"
    Get-ChildItem -LiteralPath $Root -Recurse -Depth 3 -Filter *.bib -ErrorAction SilentlyContinue |
        ForEach-Object { Write-Host ("  {0}" -f $_.FullName) }

    Write-Host ""
    Write-Host "Class/style files:"
    Get-ChildItem -LiteralPath $Root -Recurse -Depth 3 -File -ErrorAction SilentlyContinue |
        Where-Object { $_.Extension -in ".cls", ".sty", ".bst" } |
        ForEach-Object { Write-Host ("  {0}" -f $_.FullName) }
} else {
    Write-Host "[warn] root is not a directory: $Root"
    $status = 1
}

Write-Host ""
if ($status -ne 0) {
    Write-Host "Recommended user-level install when conda is available:"
    Write-Host "  conda install -y -c conda-forge pandoc tectonic"
    Write-Host "For native Windows TeX, install MiKTeX or TeX Live and add it to PATH."
}

exit $status
