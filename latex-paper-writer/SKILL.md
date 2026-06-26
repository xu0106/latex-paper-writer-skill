---
name: latex-paper-writer
description: Use when a user wants Codex to write, revise, convert, or compile academic paper sections from a supplied LaTeX conference or journal template plus local project materials. Supports template directories or zip exports, Zotero-first citation discovery, Markdown draft to LaTeX section conversion, and compile validation without guessing missing templates, citations, or experimental results.
---

# LaTeX Paper Writer

## Core Contract

Use this skill for template-driven paper writing. The user supplies, or points to, a LaTeX template directory or zip and a local project directory. Your job is to inspect the template and project, draft content in Markdown, convert it to a LaTeX section fragment matching the template, insert it into a template work copy, and compile-validate the result.

Never invent missing templates, citation keys, papers, PDFs, or experimental results. If a required artifact is missing, ask the user for it and say exactly what is needed.

## Required First Pass

Before writing content, locate or ask for:

- Template input: complete LaTeX directory or zip, preferably from Overleaf export.
- Project input: local code/results/docs directory.
- Target section: e.g. Related Work, Method, Experiments.
- Output paths: Markdown draft, `.tex` fragment, and build/work directory.

Then inspect:

- Template entrypoint, bibliography setup, section inclusion style, compile engine, and custom macros. See `references/template-analysis.md`.
- Project evidence: README, docs, code/configs, figures, tables, logs, existing drafts. See `references/writing-workflow.md`.
- Citation sources: Zotero first, then existing `.bib`, then user-provided DOI/BibTeX/PDF. See `references/citation-policy.md`.

## Workflow

1. **Environment check**
   - On Linux, macOS, Git Bash, or WSL2, run `scripts/check_env.sh <project-or-template-root>`.
   - On native Windows PowerShell, run `scripts/check_env.ps1 -Root <project-or-template-root>`.
   - If `pandoc` or TeX tooling is missing, use the matching `install_user_tools` script only after permission for network/user-environment writes is available.
   - If the task needs citations or literature search and Zotero MCP is missing, stop before drafting and tell the user to install Zotero plus register the Zotero MCP. Do not silently fall back to invented or placeholder citations.

2. **Template work copy**
   - Do not mutate the original template. Copy or unpack it into a work directory such as `paper_build_workdir/`.
   - If the template is incomplete, stop and request the missing files (`main.tex`, `.cls`, `.sty`, `.bst`, bibliography file, figures, etc.).

3. **Draft**
   - Write a Markdown draft first for review and traceability.
   - Use Pandoc citation syntax `[@key]`.
   - Use only claims supported by project files, user-provided notes, or cited literature.

4. **Convert**
   - Convert Markdown to a LaTeX fragment with `scripts/convert_md_to_tex.sh` or `scripts/convert_md_to_tex.ps1`.
   - Keep citations as LaTeX cite commands; do not render them into author-year prose.
   - Adapt headings, figures, tables, algorithms, and theorem environments to the template after conversion.

5. **Integrate and compile**
   - Insert or include the generated `.tex` in the template work copy using the template's existing section pattern.
   - Compile with `scripts/compile_template.sh` or `scripts/compile_template.ps1`.
   - Report the PDF path, unresolved citations/references, missing files, font issues, and next required user action.

## When To Ask The User

Ask instead of guessing when:

- The LaTeX template is not complete or the class/style files are missing.
- The venue requires a specific template but no template was uploaded.
- Zotero, Zotero local API, or Zotero MCP is missing for a citation/literature task.
- Zotero cannot find a requested paper or citation key.
- A paper PDF, DOI, BibTeX entry, or Zotero collection is needed.
- Network, sudo, non-sandbox, or user-environment writes are required.
- Experimental results are absent or ambiguous.

## Useful Scripts

- Bash/WSL/Linux/macOS:
  - `scripts/check_env.sh ROOT`: inspect tools, Zotero MCP, and likely template files.
  - `scripts/install_user_tools.sh`: install `pandoc tectonic` with conda-forge when conda exists.
  - `scripts/convert_md_to_tex.sh INPUT.md OUTPUT.tex [BIBFILE]`: convert Markdown to a LaTeX fragment.
  - `scripts/compile_template.sh TEMPLATE_WORKDIR [MAIN_TEX]`: compile a template copy and summarize likely issues.
- Native Windows PowerShell:
  - `scripts/check_env.ps1 -Root ROOT`
  - `scripts/install_user_tools.ps1`
  - `scripts/convert_md_to_tex.ps1 -InputMarkdown INPUT.md -OutputTex OUTPUT.tex [-BibFile BIBFILE]`
  - `scripts/compile_template.ps1 -TemplateWorkdir TEMPLATE_WORKDIR [-MainTex MAIN_TEX]`

## Example Prompts

- "Use `$latex-paper-writer` with this Overleaf zip and my repo to write the Method section."
- "Use `$latex-paper-writer` to convert this Markdown draft into the uploaded L4DC template."
- "Use `$latex-paper-writer` to inspect this template and tell me which files are missing."
- "Use `$latex-paper-writer` to generate the Experiments section from local logs and Zotero references."
