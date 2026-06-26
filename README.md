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

For real compile validation, a target LaTeX format is mandatory. If no
conference/journal template is supplied, the skill should ask for the complete
template directory or zip instead of creating a generic `article` PDF and calling
it venue-formatted. A synthetic minimal template is only appropriate for an
explicit script smoke test.

## Dependency Setup Before Using The Skill

The recommended first-run workflow is intentionally two-phase:

1. The user installs the OS-level tools below.
2. The user tells Codex that installation is finished.
3. Codex runs the bundled environment checker.
4. If anything is still missing, Codex reports the exact missing tools and may
   attempt installation only after explicit permission for network access,
   user-environment writes, `sudo`, or elevated installers.

Do not expect Codex to silently install the whole workflow on a fresh machine.
GUI applications such as Zotero and TeX distributions often need normal user
setup, PATH refreshes, or first-run configuration.

Required for Markdown-to-LaTeX conversion:

- `pandoc`

Required for PDF compilation, choose at least one route:

- `tectonic`
- or a TeX distribution such as MiKTeX or TeX Live with `pdflatex`, `xelatex`,
  `bibtex`, and preferably `latexmk`

Required for Zotero-first citation workflows:

- Zotero desktop
- Zotero local API enabled
- `uv`/`uvx`
- Codex Zotero MCP server registered

If a task needs citations, literature lookup, or bibliography completion and
Zotero/Zotero MCP is missing, the skill should stop and ask for Zotero setup,
BibTeX, DOI, PDF, or exact title/author metadata instead of inventing citations.

### Windows PowerShell

Native Windows users should run these from a normal PowerShell window, not from
a restricted sandbox shell:

```powershell
winget install --id JohnMacFarlane.Pandoc -e
winget install --id MiKTeX.MiKTeX -e
```

If you prefer Tectonic and already use conda:

```powershell
conda install -y -c conda-forge tectonic
```

Install Zotero from the official download page:

```text
https://www.zotero.org/download/
```

Or search for the current Windows package ID:

```powershell
winget search Zotero
```

Install `uv` so `uvx` can run `zotero-mcp`:

```powershell
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

Then restart PowerShell, VS Code, and Codex so PATH changes are visible. Open
Zotero once and enable:

```text
Settings -> Advanced -> Allow other applications on this computer to communicate with Zotero
```

Register Zotero MCP from normal PowerShell:

```powershell
codex mcp add zotero --env ZOTERO_LOCAL=true -- uvx --upgrade zotero-mcp
```

After installation, ask Codex to check the environment, or run:

```powershell
~\.codex\skills\latex-paper-writer\scripts\check_env.ps1 -Root C:\path\to\template-or-project
```

If PowerShell blocks script execution for the current session:

```powershell
powershell -ExecutionPolicy Bypass -File ~\.codex\skills\latex-paper-writer\scripts\check_env.ps1 -Root C:\path\to\template-or-project
```

MiKTeX may require a first-run setup or package update before `pdflatex` and
`bibtex` work. Open MiKTeX Console once, check for updates, and allow on-the-fly
package installation when compiling templates.

### Ubuntu / WSL2

Install the common command-line dependencies:

```bash
sudo apt update
sudo apt install -y pandoc texlive-xetex texlive-latex-extra texlive-fonts-recommended latexmk git unzip curl
```

If you prefer Tectonic and use conda:

```bash
conda install -y -c conda-forge tectonic
```

Install Zotero from the official download page:

```text
https://www.zotero.org/download/
```

Install `uv` so `uvx` can run `zotero-mcp`:

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

Restart the shell after installing `uv`, then open Zotero and enable:

```text
Settings -> Advanced -> Allow other applications on this computer to communicate with Zotero
```

Register Zotero MCP:

```bash
codex mcp add zotero --env ZOTERO_LOCAL=true -- uvx --upgrade zotero-mcp
```

After installation, ask Codex to check the environment, or run:

```bash
~/.codex/skills/latex-paper-writer/scripts/check_env.sh /path/to/template-or-project
```

If `pandoc` or `tectonic` is still missing and `conda` is available, Codex may
run the helper script after permission:

```bash
~/.codex/skills/latex-paper-writer/scripts/install_user_tools.sh
```

On native Windows PowerShell, the equivalent helper is:

```powershell
~\.codex\skills\latex-paper-writer\scripts\install_user_tools.ps1
```

These scripts do not silently run `sudo`, download GUI installers, or modify
PATH without user approval.

## Repository Structure

```text
latex-paper-writer/
├── SKILL.md
├── agents/
│   └── openai.yaml
├── references/
│   ├── citation-policy.md
│   ├── dependency-setup.md
│   ├── template-analysis.md
│   └── writing-workflow.md
└── scripts/
    ├── check_env.sh
    ├── check_env.ps1
    ├── compile_template.sh
    ├── compile_template.ps1
    ├── convert_md_to_tex.sh
    ├── convert_md_to_tex.ps1
    ├── install_user_tools.sh
    └── install_user_tools.ps1
```

## Safety Boundaries

The skill instructs Codex to:

- Avoid editing the original template directly.
- Work in a copied build directory.
- Ask for the target LaTeX template/format before real compile validation.
- Never use a generic `article` wrapper as a substitute for the requested venue
  template.
- Ask before network downloads, sudo, or user-environment writes.
- Use Zotero or real BibTeX metadata instead of invented citation keys.
- Ask for missing experimental results instead of making up numbers.
- Report local-only bibliography additions that were not written back to Zotero.

## License

This project is released under the MIT License. See `LICENSE`.

---

# latex-paper-writer Codex Skill 中文说明

`latex-paper-writer` 是一个面向 Codex 的论文写作 skill，用于“模板驱动”的学术论文写作场景。
它可以让 Codex 根据用户提供的 LaTeX 会议/期刊模板，以及本地项目中的代码、实验结果、
图表、已有草稿和 Zotero 文献库，生成论文章节内容。

它的默认流程是：先写 Markdown 草稿，再转换成符合模板的 LaTeX section 片段，
最后放入模板副本中进行编译验证。

这个 skill 的原则是保守可靠：不编造模板、不编造 citation key、不编造论文、不编造 PDF、
不编造实验结果。如果缺少必要材料，它会明确告诉用户需要补充什么。

## 功能

- 分析用户提供的 LaTeX 模板目录或 Overleaf 导出的 zip。
- 自动识别模板入口文件、章节组织方式、参考文献配置、自定义宏和可能的编译方式。
- 读取本地项目材料，例如代码、配置文件、实验日志、图表、README 和已有草稿。
- 优先使用 Zotero MCP 查询和管理参考文献。
- 先生成 Markdown 草稿，再转换为 LaTeX 章节片段。
- 在模板副本中编译验证，避免直接污染原始模板。
- 报告缺失的 `.cls`、`.sty`、`.bst`、`.bib`、图表、引用、字体和其他编译问题。

## 安装

使用 Codex 的 skill installer 安装：

```bash
python3 ~/.codex/skills/.system/skill-installer/scripts/install-skill-from-github.py \
  --repo xu0106/latex-paper-writer-skill \
  --path latex-paper-writer
```

也可以手动安装：

```bash
mkdir -p ~/.codex/skills
git clone git@github.com:xu0106/latex-paper-writer-skill.git /tmp/latex-paper-writer-skill
cp -a /tmp/latex-paper-writer-skill/latex-paper-writer ~/.codex/skills/
```

安装后，重新打开 Codex 会话，让 Codex 重新加载 skill。

## 使用示例

```text
请使用 $latex-paper-writer，根据我上传的 Overleaf 模板和本地项目目录，编写 Method 章节。
```

```text
请使用 $latex-paper-writer，检查这个 LaTeX 模板缺少哪些文件。
```

```text
请使用 $latex-paper-writer，把这段 Markdown 草稿转换成符合会议模板的 LaTeX 章节，并编译验证。
```

```text
请使用 $latex-paper-writer，根据我的本地实验日志、图表和 Zotero 文献库生成 Experiments 章节。
```

## 推荐输入

为了让 Codex 更稳定地完成写作任务，建议提供：

- 完整 LaTeX 模板目录，或 Overleaf 导出的 zip。
- 本地项目目录，包括代码、实验结果、图表或说明文档。
- 目标章节名称，例如 Related Work、Method、Experiments 或 Conclusion。
- 需要引用的论文、PDF、DOI 列表、BibTeX 文件或 Zotero collection 名称。

如果模板不完整，skill 会要求用户补充缺失文件，而不是自行猜测会议或期刊格式。

如果要进行真实的编译验证，必须提供目标 LaTeX 格式/模板。没有会议或期刊模板时，
skill 应要求用户上传完整模板目录或 zip，而不是创建一个通用 `article` PDF 并声称它符合
目标格式。最小 synthetic 模板只能用于明确的脚本 smoke test。

## 使用前依赖安装

推荐的首次使用流程分成两步：

1. 用户先根据下面的 Windows 或 Ubuntu 指令自行安装系统依赖。
2. 用户告诉 Codex 已经安装完成。
3. Codex 再运行自带环境检查脚本。
4. 如果仍然缺少依赖，Codex 会报告具体缺什么，并且只有在获得明确许可后，才尝试联网、
   写入用户环境、使用 `sudo` 或运行管理员安装器。

不要期待 Codex 在一台全新的电脑上静默装完整套工作流。Zotero、MiKTeX、TeX Live
这类 GUI 或系统级工具通常需要用户自己完成安装、刷新 PATH 或做首次启动配置。

Markdown 转 LaTeX 必需：

- `pandoc`

PDF 编译至少选择一种路线：

- `tectonic`
- 或 MiKTeX / TeX Live，包含 `pdflatex`、`xelatex`、`bibtex`，最好还有 `latexmk`

Zotero 优先引用工作流必需：

- Zotero 桌面端
- Zotero 本地 API 已启用
- `uv` / `uvx`
- Codex 中已注册 Zotero MCP

如果任务需要引用、文献检索或补全 bibliography，而 Zotero 或 Zotero MCP 缺失，
skill 应暂停并要求用户配置 Zotero，或提供 BibTeX、DOI、PDF、准确标题和作者信息，
不能编造引用。

### Windows PowerShell

Windows 原生用户建议在普通 PowerShell 里运行，而不是在受限 sandbox shell 里运行：

```powershell
winget install --id JohnMacFarlane.Pandoc -e
winget install --id MiKTeX.MiKTeX -e
```

如果你更想使用 Tectonic，并且已经有 conda：

```powershell
conda install -y -c conda-forge tectonic
```

从 Zotero 官方页面安装 Zotero：

```text
https://www.zotero.org/download/
```

也可以先搜索当前 winget 包名：

```powershell
winget search Zotero
```

安装 `uv`，这样 `uvx` 才能运行 `zotero-mcp`：

```powershell
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

安装后重启 PowerShell、VS Code 和 Codex，让 PATH 更新生效。然后打开 Zotero，启用：

```text
Settings -> Advanced -> Allow other applications on this computer to communicate with Zotero
```

在普通 PowerShell 中注册 Zotero MCP：

```powershell
codex mcp add zotero --env ZOTERO_LOCAL=true -- uvx --upgrade zotero-mcp
```

安装完成后，可以让 Codex 检查环境，或手动运行：

```powershell
~\.codex\skills\latex-paper-writer\scripts\check_env.ps1 -Root C:\path\to\template-or-project
```

如果 PowerShell 阻止脚本执行，可以只对当前命令绕过执行策略：

```powershell
powershell -ExecutionPolicy Bypass -File ~\.codex\skills\latex-paper-writer\scripts\check_env.ps1 -Root C:\path\to\template-or-project
```

MiKTeX 可能需要首次启动配置或更新后，`pdflatex` 和 `bibtex` 才能正常工作。建议打开一次
MiKTeX Console，检查更新，并允许编译时自动安装缺失包。

### Ubuntu / WSL2

安装常用命令行依赖：

```bash
sudo apt update
sudo apt install -y pandoc texlive-xetex texlive-latex-extra texlive-fonts-recommended latexmk git unzip curl
```

如果你更想使用 Tectonic，并且已经有 conda：

```bash
conda install -y -c conda-forge tectonic
```

从 Zotero 官方页面安装 Zotero：

```text
https://www.zotero.org/download/
```

安装 `uv`，这样 `uvx` 才能运行 `zotero-mcp`：

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

安装 `uv` 后重启 shell，然后打开 Zotero 并启用：

```text
Settings -> Advanced -> Allow other applications on this computer to communicate with Zotero
```

注册 Zotero MCP：

```bash
codex mcp add zotero --env ZOTERO_LOCAL=true -- uvx --upgrade zotero-mcp
```

安装完成后，可以让 Codex 检查环境，或手动运行：

```bash
~/.codex/skills/latex-paper-writer/scripts/check_env.sh /path/to/template-or-project
```

如果仍然缺少 `pandoc` 或 `tectonic`，并且系统里有 conda，Codex 可以在获得许可后运行：

```bash
~/.codex/skills/latex-paper-writer/scripts/install_user_tools.sh
```

Windows 原生 PowerShell 的对应脚本是：

```powershell
~\.codex\skills\latex-paper-writer\scripts\install_user_tools.ps1
```

这些脚本不会静默执行 `sudo`、下载 GUI 安装器或修改 PATH。

## 仓库结构

```text
latex-paper-writer/
├── SKILL.md
├── agents/
│   └── openai.yaml
├── references/
│   ├── citation-policy.md
│   ├── dependency-setup.md
│   ├── template-analysis.md
│   └── writing-workflow.md
└── scripts/
    ├── check_env.sh
    ├── check_env.ps1
    ├── compile_template.sh
    ├── compile_template.ps1
    ├── convert_md_to_tex.sh
    ├── convert_md_to_tex.ps1
    ├── install_user_tools.sh
    └── install_user_tools.ps1
```

## 安全边界

这个 skill 会要求 Codex：

- 不直接修改原始模板。
- 在模板副本中写入和编译。
- 在真实编译验证前，先要求用户提供目标 LaTeX 模板/格式。
- 不能用通用 `article` wrapper 代替用户要求的会议/期刊模板。
- 在需要联网下载、sudo 或写入用户环境时先询问用户。
- 使用 Zotero 或真实 BibTeX 元数据，不编造 citation key。
- 缺少实验结果时询问用户，不编造数字。
- 如果参考文献只写入了本地 `.bib`，但没有写回 Zotero，会明确告知用户。

## License

本项目使用 MIT License，详见 `LICENSE`。
