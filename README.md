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

## 依赖

模板分析不一定需要完整 LaTeX 环境，但章节转换和编译验证建议安装：

- `pandoc`
- `tectonic`
- 可选：`latexmk`、`pdflatex`、`xelatex`、`bibtex`
- 可选：Codex Zotero MCP，用于查询参考文献

可以用自带脚本检查环境：

```bash
~/.codex/skills/latex-paper-writer/scripts/check_env.sh /path/to/template-or-project
```

如果缺少 `pandoc` 或 `tectonic`，并且系统里有 conda，可以运行：

```bash
~/.codex/skills/latex-paper-writer/scripts/install_user_tools.sh
```

这个脚本不会静默执行 `sudo`。

## 仓库结构

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

## 安全边界

这个 skill 会要求 Codex：

- 不直接修改原始模板。
- 在模板副本中写入和编译。
- 在需要联网下载、sudo 或写入用户环境时先询问用户。
- 使用 Zotero 或真实 BibTeX 元数据，不编造 citation key。
- 缺少实验结果时询问用户，不编造数字。
- 如果参考文献只写入了本地 `.bib`，但没有写回 Zotero，会明确告知用户。

## License

当前仓库还没有添加 `LICENSE` 文件。如果希望别人可以明确地复用、修改或分发，
建议添加 MIT 或 Apache-2.0 License。
