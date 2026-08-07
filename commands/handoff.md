---
name: handoff
description: Generate a copy-paste-ready handoff prompt to <project>/handoff.md without running the full session-end workflow. Use when context-switching mid-session.
---

# /handoff — Generate per-project handoff prompt only

On-demand version of the handoff step from `/kit:session-end`. Skips the session summary, active-context update, commits, and other session-end work. Just refreshes the project's handoff prompt.

## When to use

- You hit a meaningful checkpoint and want a clean pickup point captured
- You want to spin up a new thread but aren't ready to fully end the session
- You finished a logical chunk of work and want to lock in the continuation prompt

## When NOT to use

- End of a real session — use `/kit:session-end` (which includes handoff generation + summary + commits)
- You haven't done substantive work yet — handoff would be the same as last time
- You're not in a project directory — system-level work doesn't need a handoff

## Workflow

### Step 1: Detect project

Check the current working directory:
- If in a project repo (`CLAUDE.md`, `handoff.md`, or `~/Projects/<name>/`) → write to `<project>/handoff.md`
- Multi-project session → ask which is primary; default to most-recently-modified
- No project → tell the user: "No project context detected. System-level work uses `active-context.md` for continuation. Run `/kit:session-end` if you want to log the session."

### Step 2: Generate handoff content

```markdown
# Handoff — YYYY-MM-DD HH:MM

> Copy-paste prompt for a new Claude Code thread. Paste everything below the line.

---

Continuing [topic / project] from prior session.

**Status:** [latest deliverable + state]

**Read first:**
1. `~/.claude/active-context.md` — cross-session rolling state
2. [project-specific file paths most relevant to pickup]
3. [secondary file if needed]

**Last session log:** [path or URL if known, else "not yet logged — run /kit:session-end to log"]

**Next action when you pick up:** [the one thing to do first]
```

### Step 3: Write the file

Target: `<project>/handoff.md` — REPLACES contents (not appends). Co-located with the work.

### Step 4: Confirm

"Handoff prompt saved to `<project>/handoff.md` — open it, copy below the `---` line, paste into a new Claude Code thread."

## Why per-project

Handoff is tied to work; work lives in projects. Putting handoff in the project folder means it's findable, scoped correctly, and replaced cleanly each session. No global handoff file needed — `active-context.md` already serves the cross-session "where am I" function for Claude.

## Difference from /kit:session-end

| Aspect | `/kit:handoff` | `/kit:session-end` |
|---|---|---|
| Generates handoff prompt | ✅ | ✅ (Step 3.5) |
| Logs session summary | ❌ | ✅ |
| Updates active-context.md | ❌ | ✅ |
| Commits/pushes | ❌ | ✅ |
| Time required | ~30 sec | ~3 min |

Use `/kit:handoff` for fast context-switches, `/kit:session-end` for actually closing the session.
