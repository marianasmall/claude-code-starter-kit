---
name: scaffold-project
description: Drop the recommended project file templates (README, PLANNING, CONTEXT-SUMMARY, project-local CLAUDE.md) into the current directory.
argument-hint: "[project name]"
---

# /scaffold-project — Set up project file conventions

Create the recommended project structure files in the current working directory.

## Workflow

### 1. Determine project name

If `$ARGUMENTS` is provided, use it as the project name.

Otherwise, infer from the current directory's basename. Confirm with: "Scaffolding project files for `<name>`. Continue? (y/n)"

If the user says no, ask: "What's the project name?"

### 2. Check for existing files

Read the current directory. For each of these files, check if it already exists:
- `README.md`
- `PLANNING.md`
- `CONTEXT-SUMMARY.md`
- `CLAUDE.md`
- `handoff.md` (auto-updated by `/session-end` Step 3.5 — copy-paste pickup prompt for next thread)

If any exist, ask: "Found existing `<file>`. Skip / Overwrite / Append-section?"
- **Skip** — leave it untouched, don't create
- **Overwrite** — replace with template (always do a backup first via the backup-before-edit hook)
- **Append-section** — keep existing content, add a marker + the template content below

### 3. Write the files

For each non-skipped file, write the template (substituting `[Project Name]` with the chosen name and today's date for any date placeholders).

Templates are documented in `docs/project-conventions.md`. Use those as the source of truth.

### 4. Skip CLAUDE.md by default

Don't create a project-local `CLAUDE.md` automatically. Most projects don't need one.

Instead, mention at the end: *"Skipped project-local CLAUDE.md — only create one if you find yourself repeatedly correcting Claude on project-specific quirks. To create one later, copy the template from `docs/project-conventions.md`."*

### 5. Confirm

Report what was created:

```
Scaffolded <project-name>:
  ✓ README.md
  ✓ PLANNING.md
  ✓ CONTEXT-SUMMARY.md
  (skipped CLAUDE.md — add later if needed)

Next steps:
  1. Open README.md and write a one-paragraph description
  2. Open PLANNING.md and start the working notes section
  3. Update CONTEXT-SUMMARY.md at the end of each session
```

## Why this exists

Most people don't set up project structure — they just start coding. By the third multi-day gap, they've lost the thread. These files are the lowest-friction way to make every project resumeable from cold.

Running this once at project start costs 30 seconds. Skipping it costs 10 minutes of "where was I?" every time you return.
