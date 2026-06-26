param(
    [Parameter(Mandatory = $true)][string]$TemplateWorkdir,
    [string]$MainTex = ""
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path -LiteralPath $TemplateWorkdir -PathType Container)) {
    Write-Error "[error] template workdir not found: $TemplateWorkdir"
    exit 1
}

Push-Location $TemplateWorkdir
try {
    if (-not $MainTex) {
        $candidate = Get-ChildItem -Recurse -Depth 3 -Filter *.tex -File -ErrorAction SilentlyContinue |
            Where-Object {
                (Get-Content -LiteralPath $_.FullName -Raw -ErrorAction SilentlyContinue) -match "\\documentclass"
            } |
            Select-Object -First 1
        if ($candidate) {
            $MainTex = Resolve-Path -Relative $candidate.FullName
        }
    }

    if (-not $MainTex -or -not (Test-Path -LiteralPath $MainTex -PathType Leaf)) {
        Write-Error "[error] could not find a main .tex file with \documentclass. Ask the user for the complete template or pass MainTex explicitly."
        exit 1
    }

    $base = [System.IO.Path]::ChangeExtension($MainTex, $null)
    $log = "$base.log"
    Write-Host "== compiling $MainTex in $TemplateWorkdir =="

    $runOk = $false

    if ((Test-Path -LiteralPath "Makefile") -and (Get-Command make -ErrorAction SilentlyContinue)) {
        Write-Host "[try] make"
        & make
        if ($LASTEXITCODE -eq 0) { $runOk = $true }
    }

    if (-not $runOk -and (Get-Command latexmk -ErrorAction SilentlyContinue)) {
        Write-Host "[try] latexmk -pdf"
        & latexmk -interaction=nonstopmode -halt-on-error -pdf $MainTex
        if ($LASTEXITCODE -eq 0) { $runOk = $true }
    }

    if (-not $runOk -and (Get-Command tectonic -ErrorAction SilentlyContinue)) {
        Write-Host "[try] tectonic"
        & tectonic $MainTex
        if ($LASTEXITCODE -eq 0) { $runOk = $true }
    }

    if (-not $runOk -and (Get-Command pdflatex -ErrorAction SilentlyContinue)) {
        Write-Host "[try] pdflatex/bibtex/pdflatex/pdflatex"
        & pdflatex -interaction=nonstopmode -halt-on-error $MainTex
        if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
        if ((Test-Path -LiteralPath "$base.aux") -and (Get-Command bibtex -ErrorAction SilentlyContinue)) {
            & bibtex $base
        }
        & pdflatex -interaction=nonstopmode -halt-on-error $MainTex
        if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
        & pdflatex -interaction=nonstopmode -halt-on-error $MainTex
        if ($LASTEXITCODE -eq 0) { $runOk = $true }
    }

    if (-not $runOk) {
        Write-Error "[error] no compile route succeeded"
        exit 1
    }

    $pdf = "$base.pdf"
    if (Test-Path -LiteralPath $pdf -PathType Leaf) {
        Write-Host "[ok] PDF: $(Join-Path (Get-Location) $pdf)"
    } else {
        $foundPdf = Get-ChildItem -Recurse -Depth 2 -Filter *.pdf -File -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($foundPdf) {
            Write-Host "[ok] PDF: $($foundPdf.FullName)"
        } else {
            Write-Host "[warn] compile command succeeded but no PDF was found"
        }
    }

    Write-Host ""
    Write-Host "== issue scan =="
    if (Test-Path -LiteralPath $log -PathType Leaf) {
        Select-String -Path $log -Pattern "undefined references|undefined citation|citation .* undefined|LaTeX Error|Package .* Error|Missing character|File .* not found|Overfull \\hbox" -CaseSensitive:$false
    } else {
        Write-Host "[warn] log file not found: $log"
    }
}
finally {
    Pop-Location
}
