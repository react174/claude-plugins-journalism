# CLAUDE.md — Journalism Tools Plugin

## Project Overview

This repository is a **Claude Code plugin marketplace** providing journalism-focused tools. It publishes a single plugin (`journalism-tools`) containing four skills for investigative data work: Python execution, data preprocessing, data analysis, and document extraction.

The primary audience is investigative journalists using Claude Code who need transparent, defensible, human-supervised data workflows.

---

## Repository Structure

```
claude-plugins-journalism/
├── .claude-plugin/
│   └── marketplace.json          # Marketplace metadata (owner, plugin listing)
├── plugins/
│   └── journalism-tools/
│       ├── .claude-plugin/
│       │   └── plugin.json       # Plugin metadata (name, version, keywords, license)
│       └── skills/
│           ├── python-runner/
│           │   ├── SKILL.md      # Skill prompt (frontmatter + instructions)
│           │   └── references/
│           │       └── install-uv.md
│           ├── structured-data-preprocessing-journalism/
│           │   ├── SKILL.md
│           │   └── references/
│           │       └── report-template.md
│           ├── structured-data-analysis-journalism/
│           │   └── SKILL.md
│           └── difficult-document-extraction/
│               ├── SKILL.md
│               ├── references/
│               │   ├── automated-extraction.md
│               │   └── schema-patterns.md
│               └── scripts/
│                   ├── convert_to_images.py
│                   └── generate_review_interface.py
├── README.md
└── .gitignore
```

### Key Files

| File | Purpose |
|------|---------|
| `.claude-plugin/marketplace.json` | Declares the marketplace and which plugins it contains; referenced when a user runs `/plugin marketplace add nhagar/claude-plugins-journalism` |
| `plugins/journalism-tools/.claude-plugin/plugin.json` | Plugin-level metadata: name, version, author, keywords, license |
| `plugins/journalism-tools/skills/*/SKILL.md` | Each skill's invocation prompt — YAML frontmatter defines `name` and `description`, the body defines the workflow |
| `skills/*/references/*.md` | Reference documents that SKILL.md files link to for additional context |
| `skills/difficult-document-extraction/scripts/` | Python utility scripts invoked during skill execution |

---

## Plugin Installation (User-facing)

```shell
/plugin marketplace add nhagar/claude-plugins-journalism
/plugin install journalism-tools@journalism-tools
```

## Local Development

Test without publishing by pointing Claude Code at the local plugin directory:

```bash
claude --plugin-dir ./plugins/journalism-tools
```

---

## The Four Skills

### 1. `python-runner` — `/journalism-tools:python-runner`

Runs Python scripts using [uv](https://github.com/astral-sh/uv) for automatic, isolated dependency management.

**Key convention:** Prefer inline script dependencies using the `# /// script` PEP 723 metadata block, making scripts self-contained:

```python
# /// script
# requires-python = ">=3.10"
# dependencies = ["pandas", "requests"]
# ///
```

Run with `uv run script.py` — no virtualenv setup needed.

---

### 2. `journalistic-data-preprocessing` — `/journalism-tools:journalistic-data-preprocessing`

Five-phase workflow: Load → Audit → Report → Transform → Validate.

**Core rules:**
- Every loaded row gets four provenance columns: `_source_file`, `_source_sheet`, `_source_row`, `_load_timestamp`
- No silent transformations — every change is documented and requires journalist approval before execution
- Output: `cleaned_[name].csv`, `transformation_log.csv`, `data_audit_report.md`, `entity_mapping_[col].csv`

---

### 3. `structured-data-analysis-journalism` — `/journalism-tools:structured-data-analysis-journalism`

Three-stage workflow: Proposal → Execution → Findings Report.

**Core rules:**
- Generate `analysis_proposal.md` and stop for journalist approval before running any analysis
- Prefer pandas or DuckDB (DuckDB for large data); include step-by-step comments
- Every aggregate finding must link back to underlying records
- Avoid black-box ML, causal language, and methods that can't be explained in plain language
- Output: `analysis_proposal.md`, `analysis_findings.md`, `finding_N_records.csv`, `summary_statistics.csv`

**Analysis types to use:** counting/aggregation, filtering, cross-referencing, outlier identification, time patterns, network mapping.

**Analysis types to avoid:** neural networks, causal claims, methods that can't be explained to an editor.

---

### 4. `document-extractor` — `/journalism-tools:document-extractor`

Six-step workflow for messy/scanned documents: Convert → Transcribe → Stitch → Schema (with approval) → Extract → Generate Review Interface.

**Core rules:**
- Use `scripts/convert_to_images.py` to produce `pages/page_NNN.png` images
- Transcribe every page (or use automated workflow for >50 pages — see `references/automated-extraction.md`)
- Mark redactions as `[REDACTED]`, illegible text as `[ILLEGIBLE]`, handwriting as `[HANDWRITTEN: ...]`
- **Stop at Step 4** and get journalist approval of the schema before any extraction
- Extract JSON yourself (not with a script) for <50 pages; include `extraction_metadata` header
- Run `scripts/generate_review_interface.py` to produce a zero-install HTML review file

**Schema design:** flat over nested, snake_case field names, always include `source_page` + `source_document`, use `null` (never empty strings) for missing data, preserve original text alongside normalized values.

---

## Skill File Format

Each `SKILL.md` follows this structure:

```markdown
---
name: skill-name
description: One-paragraph description used by Claude to decide when to trigger this skill.
---

# Skill Title

[Workflow instructions for Claude to follow]
```

- The `name` field in frontmatter is the skill's invocation name
- The `description` should be specific enough for Claude to auto-trigger it on relevant user requests
- Reference documents (`references/`) are linked from the skill body using relative paths

---

## Development Conventions

### Adding a New Skill

1. Create `plugins/journalism-tools/skills/<skill-name>/SKILL.md`
2. Write YAML frontmatter with `name` and `description`
3. Document the complete workflow in the body
4. Add any reference documents to `skills/<skill-name>/references/`
5. Add any utility scripts to `skills/<skill-name>/scripts/`
6. The skill is automatically available after reinstalling the plugin locally

### Modifying Skills

- All workflow logic lives in `SKILL.md` — this is what Claude reads and follows
- Reference files provide supplementary detail; keep them focused and cross-link from SKILL.md
- Scripts in `scripts/` are Python utilities; use `uv run --with <dep>` invocations in skill instructions so users don't need manual setup

### Journalism-Specific Principles to Preserve

These principles are central to all skills and must be maintained in any modifications:

1. **Provenance**: Every data record traces to its source (file, sheet, row, page, document)
2. **Human-in-the-loop**: Skills stop and wait for journalist approval before consequential actions (transformations, extractions, analyses)
3. **No silent changes**: All transformations are documented before execution
4. **Defensibility over sophistication**: Simple analyses that hold up to scrutiny over complex methods that can't be explained
5. **Transparent ambiguity**: Unclear, redacted, or illegible values are explicitly marked, never silently dropped or guessed

### Plugin Metadata

- Plugin version is in `plugins/journalism-tools/.claude-plugin/plugin.json`
- Marketplace metadata is in `.claude-plugin/marketplace.json`
- The marketplace `source` field (`"./plugins/journalism-tools"`) is a relative path from the repo root

---

## Scripts Reference

### `convert_to_images.py`

Converts PDF, TIFF, or single images to sequentially numbered page images.

```bash
uv run --with pdf2image --with pillow \
  scripts/convert_to_images.py input.pdf \
  --output-dir ./pages \
  --dpi 300 \
  --format png
```

Arguments: `input` (required), `--output-dir` (default `./pages`), `--dpi` (default 200), `--format` (png or jpg, default png).

### `generate_review_interface.py`

Generates a self-contained HTML file for journalist review of extracted data alongside source page images.

```bash
uv run scripts/generate_review_interface.py \
  ./pages output/extracted.json \
  --output output/review_document.html \
  --document-name "FOIA Response 2024-001"
```

---

## License

MIT
