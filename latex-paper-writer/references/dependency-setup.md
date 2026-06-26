# Dependency Setup

Use this reference on fresh or unverified machines before writing or compiling paper sections.

## Two-Phase Policy

1. First ask the user to install OS-level tools manually with the commands below.
2. After the user says installation is complete, run the matching `check_env` script.
3. If tools are still missing, report exactly what is missing.
4. Attempt installation only after explicit permission for network access, user-environment writes, `sudo`, or elevated installers.

Do not silently install GUI applications, modify PATH, or assume Zotero is available.

## Required Tools

- Markdown conversion: `pandoc`
- PDF compilation: either `tectonic` or a TeX distribution with `pdflatex`/`xelatex` and `bibtex`
- Citation lookup: Zotero desktop, Zotero local API, `uvx`, and registered Zotero MCP

For citation or literature tasks, missing Zotero desktop, Zotero local API, or Zotero MCP is a blocker unless the user provides BibTeX, DOI, PDF, or exact title/author metadata.

## Windows PowerShell

Ask the user to run these in normal PowerShell:

```powershell
winget install --id JohnMacFarlane.Pandoc -e
winget install --id MiKTeX.MiKTeX -e
```

If they prefer Tectonic and already use conda:

```powershell
conda install -y -c conda-forge tectonic
```

Ask them to install Zotero from:

```text
https://www.zotero.org/download/
```

Ask them to install `uv`:

```powershell
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

Then ask them to restart PowerShell, VS Code, and Codex, open Zotero, and enable:

```text
Settings -> Advanced -> Allow other applications on this computer to communicate with Zotero
```

Register Zotero MCP:

```powershell
codex mcp add zotero --env ZOTERO_LOCAL=true -- uvx --upgrade zotero-mcp
```

After confirmation, check:

```powershell
~\.codex\skills\latex-paper-writer\scripts\check_env.ps1 -Root C:\path\to\template-or-project
```

## Ubuntu / WSL2

Ask the user to run:

```bash
sudo apt update
sudo apt install -y pandoc texlive-xetex texlive-latex-extra texlive-fonts-recommended latexmk git unzip curl
```

If they prefer Tectonic and already use conda:

```bash
conda install -y -c conda-forge tectonic
```

Ask them to install Zotero from:

```text
https://www.zotero.org/download/
```

Ask them to install `uv`:

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

Then ask them to restart the shell, open Zotero, enable the local API, and register Zotero MCP:

```bash
codex mcp add zotero --env ZOTERO_LOCAL=true -- uvx --upgrade zotero-mcp
```

After confirmation, check:

```bash
~/.codex/skills/latex-paper-writer/scripts/check_env.sh /path/to/template-or-project
```
