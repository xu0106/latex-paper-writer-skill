# Template Analysis

Use this reference when inspecting a supplied LaTeX conference or journal template.

## Template Inputs

Prefer a complete directory or zip export. A complete template usually includes:

- Main entrypoint: `main.tex`, `paper.tex`, `template.tex`, or similar.
- Class/style files: `.cls`, `.sty`.
- Bibliography style or BibLaTeX config: `.bst`, `\bibliographystyle{}`, `\addbibresource{}`.
- Bibliography database: `.bib`, if provided.
- Figure/table folders.
- Example sections or sample body text.
- Build instructions in `README`, `Makefile`, `.latexmkrc`, or Overleaf comments.

Before compiling or claiming template conformance, confirm the target LaTeX format is present. If no target conference/journal template was supplied, ask the user to upload or point to the complete template directory or zip.

Do not create a generic `article`/`report` wrapper to stand in for the target format. A minimal synthetic template is acceptable only for an explicit script smoke test; label that output as a non-venue test.

If the user provides only one `.tex` file and it references unavailable class/style/bib files, stop and ask for the complete template zip.

## Entrypoint Detection

Find likely main files by searching for:

- `\documentclass`
- `\begin{document}`
- `\maketitle`
- `\bibliography{...}`
- `\printbibliography`

If multiple candidates exist, prefer the one with both `\documentclass` and `\begin{document}` and the most section includes. If still ambiguous, ask the user.

## Section Integration

Inspect whether the template uses:

- Inline `\section{...}` blocks in the main file.
- `\input{sections/name}`.
- `\include{sections/name}`.
- Custom macros such as `\papersection{}`.

Match the existing pattern. Do not invent a new directory layout unless the template has none.

## Bibliography Detection

Identify whether the template uses BibTeX, BibLaTeX, or natbib:

- BibTeX/natbib: `\bibliographystyle{...}` and `\bibliography{...}`.
- BibLaTeX: `\usepackage{biblatex}`, `\addbibresource{...}`, and `\printbibliography`.
- Citation commands: `\citep`, `\citet`, `\cite`, `\parencite`, `\textcite`.

The generated section should use citation commands that match the template. Pandoc output may need a small post-conversion pass to align `\cite{}` with `\citep{}` or BibLaTeX commands.

## Compile Engine

Prefer explicit instructions from the template. Otherwise try:

1. `latexmk -pdf main.tex`
2. `latexmk -xelatex main.tex`
3. `tectonic main.tex`
4. `pdflatex main.tex`, then `bibtex`, then `pdflatex` twice

If class/style files are missing, do not attempt to replace them from memory. Ask for the complete template.

## Figures And Tables

Use template conventions for:

- `figure` vs `figure*`
- `table` vs `table*`
- `\includegraphics` width patterns
- caption and label order
- algorithm environments

Only reference figure files that exist or that Codex created during the task. If a needed figure is missing, request it or create a clearly labeled placeholder only with user approval.
