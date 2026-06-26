# latex-paper-writer Codex Skill

`latex-paper-writer` is a Codex skill for template-driven academic paper writing.
It helps Codex turn a supplied LaTeX conference/journal template and local project
materials into paper sections that can be drafted in Markdown, converted to LaTeX,
inserted into a template work copy, and compile-checked.

The skill is intentionally conservative: it should not invent missing templates,
citations, papers, PDFs, or experimental results. When required material is
missing, it tells the user exactly what to provide.

## What It Does

- Inspects a supplied LaTeX template directory or Overleaf-style zip.
- Detects the template entrypoint, section include pattern, bibliography setup,
  custom macros, and likely compile engine.
- Reads local project evidence such as code, configs, logs, figures, README files,
  and existing drafts.
- Uses Zotero first for citation discovery when a Zotero MCP server is available.
- Drafts sections in Markdown before converting them to LaTeX fragments.
- Compiles a copied template work directory without mutating the original template.
- Reports missing `.cls`, `.sty`, `.bst`, `.bib`, figures, citation keys, fonts,
  and other compile blockers.

## Installation

Install from this repository with Codex's skill installer:

```bash
python3 ~/.codex/skills/.system/skill-installer/scripts/install-skill-from-github.py \
  --repo xu0106/latex-paper-writer-skill \
  --path latex-paper-writer
```

Or install manually:

```bash
mkdir -p ~/.codex/skills
git clone git@github.com:xu0106/latex-paper-writer-skill.git /tmp/latex-paper-writer-skill
cp -a /tmp/latex-paper-writer-skill/latex-paper-writer ~/.codex/skills/
```

Restart Codex or start a new Codex session after installation so the skill is
discoverable.

## Example Prompts

```text
Use $latex-paper-writer with this Overleaf zip and my local repo to write the Method section.
```

```text
Use $latex-paper-writer to inspect this LaTeX template and tell me which files are missing.
```

```text
Use $latex-paper-writer to convert this Markdown draft into the uploaded conference template and compile-check it.
```

```text
Use $latex-paper-writer to generate the Experiments section from my local logs, figures, and Zotero references.
```

## Expected Inputs

For best results, provide:

- A complete LaTeX template directory or Overleaf zip.
- A local project directory containing code, results, figures, or notes.
- The target section name, such as Related Work, Method, Experiments, or Conclusion.
- Any required papers, PDFs, DOI lists, BibTeX files, or Zotero collection names.

If the template is incomplete, the skill should ask for the missing files rather
than guessing the venue format.

## Dependencies

The skill can inspect templates without a full LaTeX installation, but conversion
and compile checks work best with:

- `pandoc`
- `tectonic`
- optional: `latexmk`, `pdflatex`, `xelatex`, `bibtex`
- optional: Codex Zotero MCP server for citation lookup

The bundled environment checker reports what is available:

```bash
~/.codex/skills/latex-paper-writer/scripts/check_env.sh /path/to/template-or-project
```

If `pandoc` or `tectonic` is missing and `conda` is available, the helper script
can install user-level tools:

```bash
~/.codex/skills/latex-paper-writer/scripts/install_user_tools.sh
```

It does not silently run `sudo`.

## Repository Structure

```text
latex-paper-writer/
├── SKILL.md
├── agents/
│   └── openai.yaml
├── references/
│   ├── citation-policy.md
│   ├── template-analysis.md
│   └── writing-workflow.md
└── scripts/
    ├── check_env.sh
    ├── compile_template.sh
    ├── convert_md_to_tex.sh
    └── install_user_tools.sh
```

## Safety Boundaries

The skill instructs Codex to:

- Avoid editing the original template directly.
- Work in a copied build directory.
- Ask before network downloads, sudo, or user-environment writes.
- Use Zotero or real BibTeX metadata instead of invented citation keys.
- Ask for missing experimental results instead of making up numbers.
- Report local-only bibliography additions that were not written back to Zotero.

## License

No license has been added yet. Add a `LICENSE` file before publishing this as an
open-source project if you want others to reuse it under explicit terms.
