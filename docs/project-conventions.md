# Project Conventions

How to structure project repos so Claude Code can pick them up cold and resume your work fast.

## The four files

A well-set-up project repo has up to four files at its root. Each serves a different purpose:

| File | Audience | Pace | When to start one |
|---|---|---|---|
| `README.md` | Humans | Slow-changing | Day one. What is this thing? |
| `PLANNING.md` | You + future you | Accumulates | Once the project is past sketch-stage (day 2+) |
| `CONTEXT-SUMMARY.md` | Claude (auto-injected) | Overwritten each session | After your first multi-day gap |
| `CLAUDE.md` (project-local) | Claude | Slow-changing | When this project has quirks the global CLAUDE.md doesn't capture |

You don't need all four right away. Start with README.md, add PLANNING.md when the project gets serious, add CONTEXT-SUMMARY.md when you start losing the thread between sessions, add a project-local CLAUDE.md only if there's something genuinely project-specific Claude needs to know.

## Why this works

The starter kit's `user-prompt-context.sh` hook scans the current directory (and walks up to find `.git`) every time you submit a prompt. When it finds these files, it injects them into Claude's context **before** processing your prompt. So Claude already knows:
- What the project is (from README.md)
- What state it's in (from CONTEXT-SUMMARY.md, falling back to PLANNING.md)
- Any project-specific instructions (from CLAUDE.md)

You don't paste context. The hook does it for you.

## Templates

Copy-paste any of these into your project root and edit. Or run `/scaffold-project` to drop them all in at once.

### README.md

Standard public-facing README. Aimed at humans (not Claude). What is this, how to use it.

```markdown
# [Project Name]

[One-paragraph description of what this is and why it exists.]

## Getting started

[Install/setup instructions. Be specific.]

## How it works

[Architecture overview. Diagrams if helpful.]

## Status

[Active / paused / archived. Last meaningful update.]
```

### PLANNING.md

Your **working notebook** for this project. Accumulates over time. The same file you write to and read from across many sessions.

```markdown
# [Project Name] — Planning

## What this is
[1-2 paragraphs: what is this project, what problem it solves, who it's for.]

## Current state
[Bulleted list of what's working, what's in progress, what's blocked.]

## Active todos
- [ ] Concrete next step
- [ ] Another concrete next step

## Decisions made
- **YYYY-MM-DD** — [What was decided]. [Why.] [What was rejected and why.]

## Open questions
- [Things still being worked out, with no clear answer yet]

## Pickup notes
[What you'd need to know to resume this project after a long break. Treat your future self as a stranger.]
```

### CONTEXT-SUMMARY.md

The **dashboard**. Overwritten every session (or at least every few). Optimized for fast pickup — small enough to scan in 30 seconds, current enough to actually reflect reality.

```markdown
# [Project Name] — Context Summary

**Status:** [Active / Paused / Done — and one sentence of nuance]
**Last touched:** YYYY-MM-DD
**Next action:** [The single concrete next thing]

## What's going on right now
[2-3 sentences max. The current "you are here" position.]

## Files in flight
- `path/to/file.ext` — [what's being changed, and why]

## Notes for Claude
[Anything Claude Code should know about this project's quirks. Optional.]
```

This is the file the hook prefers when both PLANNING.md and CONTEXT-SUMMARY.md exist. Keep it short.

### CLAUDE.md (project-local)

A **project-scoped override** for `~/.claude/CLAUDE.md`. Used only when this project has rules or conventions that don't apply to your other work.

```markdown
# CLAUDE.md — [Project Name]

> Project-specific instructions. Overrides apply only when working in this directory.

## What this project is

[One paragraph. Different from README — this is for Claude, not humans.]

## Conventions specific to this project

- [Naming patterns]
- [Testing approach]
- [Architectural rules unique to this project]

## Don't do

- [Project-specific anti-patterns]

## When stuck

- [Where to look for context, who to ask, what files matter]
```

You probably don't need a project-local CLAUDE.md for most projects. Add it only when you find yourself repeatedly correcting Claude on the same project-specific quirk.

## Workflow

A typical project lifecycle with these files:

### Day 1 — Sketch phase
- Create `README.md`. One paragraph. That's it.

### Day 2-7 — Active build
- Add `PLANNING.md`. Update it at end of each working session — current state, decisions made, what's next.
- Run `/session-end` from the kit to nudge yourself.

### After first multi-day gap
- Add `CONTEXT-SUMMARY.md`. Update it at the start of each new session — fresh dashboard.
- The hook will start auto-injecting it.

### When project has quirks
- Add project-local `CLAUDE.md` for project-specific rules.

### When project ships or pauses
- Update README.md status section.
- Update CONTEXT-SUMMARY.md to reflect "Done" or "Paused: see PLANNING.md for resume notes."
- Don't delete PLANNING.md — you'll thank yourself later.

## When NOT to use these

- **Throwaway scratch directories** — One-off explorations don't need this overhead.
- **Public open-source repos with traditional READMEs** — Stick with the standard README structure; PLANNING and CONTEXT-SUMMARY are too internal-feeling for public-facing projects.
- **Repos managed by a team that has its own conventions** — Don't impose this on a team without buy-in.

## Worked example

See `examples/sample-project/` for a fully-filled-in version of all four files for an imaginary blog-post pipeline project. It demonstrates what these files actually look like when used in real working conditions — not the empty templates above, but the real texture of mid-project notes.
