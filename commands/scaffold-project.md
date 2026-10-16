---
name: scaffold-project
description: Drop the standard project package (README, AGENTS.md, one-line CLAUDE.md, PLANNING, decisions, handoff, and a gitignored _private/ folder) into the current directory.
argument-hint: "[project name]"
---

# /scaffold-project — Set up the project package

Create the standard project files in the current working directory. The templates and the reasoning behind each file are in `docs/never-lose-a-project.md` (section "Appendix: blank templates"). Use those as the source of truth.

## Workflow

### 1. Determine project name

If `$ARGUMENTS` is provided, use it as the project name.

Otherwise, infer from the current directory's basename. Confirm with: "Scaffolding project files for `<name>`. Continue? (y/n)"

If the user says no, ask: "What's the project name?"

If the folder name doesn't follow the naming convention in `docs/never-lose-a-project.md` ("Part 4: naming"), mention it once and suggest a prefixed name. Don't rename anything yourself.

### 2. Check for existing files

Read the current directory. For each of these files, check if it already exists:
- `README.md`
- `AGENTS.md`
- `CLAUDE.md`
- `PLANNING.md`
- `decisions.md`
- `handoff.md`
- `.gitignore`

If any exist, ask: "Found existing `<file>`. Skip / Overwrite / Append-section?"
- **Skip** — leave it untouched, don't create
- **Overwrite** — replace with template (always do a backup first via the backup-before-edit hook)
- **Append-section** — keep existing content, add a marker + the template content below

**Existing `CLAUDE.md` with real content:** don't overwrite it with the one-liner. Offer to move its content into `AGENTS.md` and replace `CLAUDE.md` with the `@AGENTS.md` loader.

**Existing `CONTEXT-SUMMARY.md`** (older five-file layout): leave it. Offer to fold it into the first `handoff.md` top block, per "What changed from the five-file layout" in the doc.

### 3. Write the files

For each non-skipped file, write the template, substituting `[project-name]` / `[Project Name]` with the chosen name and today's date for date placeholders.

For `.gitignore`: if it exists, append only the lines from the template that are missing (`_private/`, `CLAUDE.local.md`, `.env`, `.env.*`, `!.env.example`, `_backups/`, `.DS_Store`). Never remove lines.

If the folder is already a git repo and anything under `_private/` is already tracked, the new ignore line won't stop it being pushed. Tell the user and offer `git rm -r --cached _private/` (stops tracking; files stay on disk; history still contains them).

Don't create `BULLETIN.md` unless the user says two or more AI tools will work this project. Don't create the `_private/` folder itself; it's created the first time something needs to go in it.

### 4. Confirm

Report what was created:

```
Scaffolded <project-name>:
  ✓ README.md
  ✓ AGENTS.md
  ✓ CLAUDE.md (@AGENTS.md loader + compact instructions)
  ✓ PLANNING.md
  ✓ decisions.md
  ✓ handoff.md
  ✓ .gitignore (_private/, secrets files, and _backups/ excluded)

Next steps:
  1. Fill in the brackets in README.md, AGENTS.md, and PLANNING.md
  2. Log your first real decision as D-1 in decisions.md
  3. At session end, run /kit:session-end to add the first handoff top block
```

## Why this exists

Most people don't set up project structure — they just start working. By the third multi-day gap, they've lost the thread. These files are the lowest-friction way to make every project resumeable from cold, by you or by any AI tool.

Running this once at project start costs 30 seconds. Skipping it costs 10 minutes of "where was I?" every time you return.
