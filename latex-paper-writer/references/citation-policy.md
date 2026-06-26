# Citation Policy

Use this reference whenever citations or bibliography entries are needed.

## Priority Order

1. Query Zotero MCP first when available.
2. Search existing project/template `.bib` files.
3. Ask the user for DOI, BibTeX, PDF, title, or Zotero collection.
4. Use web search only when explicitly allowed or when current/accurate bibliographic metadata is required.

## Zotero First

Use Zotero MCP to find papers by title, author, DOI, keywords, or citation key. Prefer stable Better BibTeX keys when available. If Zotero is local-only, it may be read-only; do not assume you can write new items back to the library.

If a task needs citation discovery, reference completion, DOI/PDF lookup, or bibliography growth and Zotero MCP is missing, do not proceed as if citations are available. Tell the user:

- Zotero desktop should be installed and opened.
- Zotero local API should be enabled: Settings -> Advanced -> "Allow other applications on this computer to communicate with Zotero".
- Zotero MCP should be registered with Codex.
- If they cannot use Zotero, they must provide BibTeX, DOI, PDF, or exact title/author metadata.

For Windows users who already have Codex CLI and `uv`, a typical local-only registration is:

```powershell
codex mcp add zotero --env ZOTERO_LOCAL=true -- uvx --upgrade zotero-mcp
```

If `uv` is missing, ask the user before installing it. If Codex runs inside a restricted extension sandbox, tell the user to run the MCP registration in normal PowerShell.

If Zotero cannot find a paper, ask for one of:

- DOI
- BibTeX entry
- PDF
- Zotero collection/export
- Exact title/authors

## BibTeX Handling

When adding a citation to a project `.bib`:

- Preserve existing key style when possible.
- Do not duplicate entries with different keys.
- Include enough fields to compile and identify the work: author, title, year, venue or type, DOI/URL when available.
- Tell the user if the entry was only added locally and not written back to Zotero.

## No Fabrication

Never create plausible-looking citation keys for papers that were not found. Temporary TODO citation markers are allowed only when clearly labeled and reported back as blocking items.

## Network And Downloads

Downloading PDFs, querying external databases, or installing citation tools may require network permission. Ask for permission before doing so when the environment requires approval.
