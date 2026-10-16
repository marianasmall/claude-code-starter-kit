---
name: handoff
description: Add a new top block to <project>/handoff.md without running the full session-end workflow. Use when context-switching mid-session or right before compacting.
---

# /handoff — Add a handoff top block only

On-demand version of the handoff step from `/kit:session-end`. Skips the session summary, active-context update, commits, and other session-end work. Just adds a fresh top block to the project's handoff file.

## When to use

- You hit a meaningful checkpoint and want a clean pickup point captured
- You want to spin up a new thread but aren't ready to fully end the session
- **Right before you compact a long session** — save state first, then compact (see Step 4)

## When NOT to use

- End of a real session — use `/kit:session-end` (which includes the handoff + summary + commits)
- You haven't done substantive work yet — the block would repeat the last one
- You're not in a project directory — system-level work doesn't need a handoff

## Workflow

### Step 1: Detect project

Check the current working directory:
- If in a project repo (`AGENTS.md`, `CLAUDE.md`, `handoff.md`, or `~/Projects/<name>/`) → write to `<project>/handoff.md`
- Multi-project session → ask which is primary; default to most-recently-modified
- No project → tell the user: "No project context detected. System-level work uses `active-context.md` for continuation. Run `/kit:session-end` if you want to log the session."

### Step 2: Write the top block

Add a new block to the **top** of `<project>/handoff.md` (newest first). The previous top block moves down under `## Earlier sessions` as a one-line recap; keep the last ~5 recaps. If the file uses the older replace-every-session format, its contents become the first recap.

```markdown
# Handoff: [project-name]

> **▶ YYYY-MM-DD HH:MM. READ THIS FIRST.**
> - **Done:** [what finished, with branch and commit]
> - **Mid-flight:** [what's half done]
> - **Waiting on you:** [what only the user can do, and when it's on the calendar]
> - **Next:** [the single first action]
> - **Don't touch:** [anything off-limits]

--- PASTE BELOW ---

Continuing [project] in [folder], branch [branch].
Read first: AGENTS.md, this handoff, [other project files most relevant to pickup], `~/.claude/active-context.md`.
State: [one or two sentences].
Last session log: [path or URL if known, else "not yet logged — run /kit:session-end to log"]
First action: [the one thing to do first].

---

## Earlier sessions

> **YYYY-MM-DD HH:MM.** [one-line recap of the previous top block]
```

Full format and a worked example: `docs/never-lose-a-project.md`, "handoff.md: where you left off".

### Step 3: Confirm

"Handoff saved to the top of `<project>/handoff.md`. In a new thread, say 'pick up the handoff' or paste the block under `--- PASTE BELOW ---`."

### Step 4: If the user is about to compact

State is now saved, so offer a paste-ready compact line naming what must survive: `/compact Keep: [active task + branch], [open decisions], [what's waiting on the user], [rules granted this session]. Drop: [tool output already saved to files].`

## Why per-project

Handoff is tied to work; work lives in projects. Putting handoff in the project folder means it's findable and scoped correctly. Newest-first means a session that ends badly doesn't wipe the trail. No global handoff file needed — `active-context.md` already serves the cross-session "where am I" function for Claude.

## Difference from /kit:session-end

| Aspect | `/kit:handoff` | `/kit:session-end` |
|---|---|---|
| Adds handoff top block | ✅ | ✅ (Step 3.5) |
| Logs session summary | ❌ | ✅ |
| Updates active-context.md | ❌ | ✅ |
| Decisions check + calendar sweep | ❌ | ✅ |
| Commits/pushes | ❌ | ✅ |
| Time required | ~30 sec | ~3 min |

Use `/kit:handoff` for fast context-switches and pre-compact saves, `/kit:session-end` for actually closing the session.
