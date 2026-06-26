# Writing Workflow

Use this reference when drafting or revising paper content from local project materials.

## Evidence First

Before drafting, read enough local evidence to support the section:

- README and project overview.
- Existing paper sections or drafts.
- Config files and key implementation files.
- Experiment logs, tables, figures, notebooks, or artifacts.
- User notes and supplied claims.

Write down the source of major claims mentally or in a short working note. Do not promote code details into paper contributions unless the user or existing draft frames them that way.

## Markdown Draft First

Draft in Markdown before converting to LaTeX. Use:

- `##`/`###` headings for structure.
- Pandoc citations: `[@Key]`.
- LaTeX math for equations.
- Relative figure references.
- Clear TODO markers only for genuinely missing user inputs.

Keep the draft aligned with the target template but do not overfit to LaTeX syntax at this stage.

## Scientific Claims

Do not invent:

- Quantitative results.
- Ablations.
- Baseline names.
- Dataset/task details.
- Theoretical guarantees.
- Citation keys or literature claims.

If local evidence is incomplete, ask the user for logs, tables, figure files, notes, or citations.

## Conversion Review

After converting Markdown to LaTeX:

- Check headings match the requested section level.
- Check citations compile with the template's citation package.
- Check labels are unique and meaningful.
- Check all figure paths exist in the template work copy.
- Check equations and symbols match surrounding sections.

If the template uses custom environments, adapt the converted fragment manually.

## Reporting Back

When done, report:

- Markdown draft path.
- LaTeX fragment path.
- Template work copy path.
- PDF path if compilation succeeded.
- Missing inputs or compile warnings if not.
