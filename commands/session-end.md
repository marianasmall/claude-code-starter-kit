---
name: session-end
description: Wrap up a Claude Code session with logging, summary, and active context update
---

# Session End

Wrap up this Claude Code session with proper logging and handoff.

**RESILIENCE RULE:** Each step below is independent. If any step fails, log the failure, skip it, and continue with the next step. Never let one failure block the rest. At the end, report which steps succeeded and which need manual follow-up.

## Step 0: Recover Compacted Context
Before writing anything, check if compaction occurred during this session (look for compaction markers in conversation or check `~/.claude/compaction-log.md`). If compaction happened, or if the session was long (over 1 hour), read the session transcript to recover detail lost during compression.

If no compaction occurred and the session was short, skip — live context is sufficient.

## Step 1: Write the Summary

Create a concise session summary. Be rigorous — don't skip fields:

- **What we worked on** (list the main tasks/topics)
- **What changed** (files created, modified, or deleted)
- **Key Decisions** (choices made — include the reasoning and alternatives, not just outcomes; cite the project's D-number if one was logged)
- **Open Loops** (anything owed, by whom, by when — including what's waiting on the user)
- **Next Steps** (pending items or follow-ups)
- **Where State Lives** (project folder, branch, and the files that hold the current truth)
- **Questions & Concerns** (unresolved questions, blockers, things needing review)
- **Insights & Recommendations** (patterns noticed, suggested next steps, cross-project connections)

## Step 2: Persist the Summary

Write the summary to `~/.claude/session-summaries.md` as a new entry at the top:

```markdown
## YYYY-MM-DD HH:MM — <Session Title>

**Worked on:**
- ...

**Changed:**
- ...

**Key Decisions:**
- ...

**Open Loops:**
- ...

**Next Steps:**
- ...

**Where State Lives:**
- ...

**Questions & Concerns:**
- ...

**Insights & Recommendations:**
- ...

**Transcript:** <path from session-log.md>

---
```

**Optional Notion logging:** If the user has connected Notion via MCP and configured a Session Summaries database in `~/.claude/settings.json` (key: `notionSessionDb`), also create an entry there. Skip if not configured — the markdown file is the primary source of truth.

## Step 3: Update Active Context

Write `~/.claude/active-context.md` with:
- What was the last thing worked on
- Where to pick up next session
- Any open decisions or blockers

This is the warm-start file that gets injected at the beginning of the next session by `user-prompt-context.sh`. Keep it short (under 30 lines) — only what's needed to resume.

## Step 3.5: Add a Handoff Top Block

Add a new block to the **top** of `<project>/handoff.md` — the project folder where the work lives. Newest first: the previous top block moves down under an `## Earlier sessions` heading, shortened to a one-line recap. Keep the last ~5 recaps and prune older ones (full history lives in git and your session summaries). Only the top block carries a paste-ready prompt. Format and a worked example: `docs/never-lose-a-project.md`, "handoff.md: where you left off".

**If the existing file uses the older replace-every-session format** (a single `# Handoff — date` block with a `---` paste line), convert it: its contents become the first `Earlier sessions` recap.

**Detect "primary project":**
- If cwd is in a project repo (has `CLAUDE.md`, `handoff.md`, or `~/Projects/<name>/` pattern) → write to `<project>/handoff.md`
- If session touched MULTIPLE projects → ask the user which is primary; default to most-recently-modified
- If no project context (system-level only) → skip; `active-context.md` already serves as continuation state

**Template:**

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
Last session log: [path or URL — depends on where Step 2 saved it]
First action: [the one thing to do first].

---

## Earlier sessions

> **YYYY-MM-DD HH:MM.** [one-line recap of the previous top block]
```

**The user's ritual:** in a new Claude Code thread opened in the project folder, say "pick up the handoff" — or copy everything under `--- PASTE BELOW ---` in the top block and paste it.

**On-demand version:** the `/kit:handoff` command runs ONLY this step (no session summary, no commits) — useful for mid-session context switches.

## Step 3.6: Decisions check

If decisions were made this session in a project that has a `decisions.md`, confirm each one has a numbered row (`D-N`) with its reason and the option rejected. Add any that are missing now. Skip if the project has no `decisions.md`.

## Step 4: Update CLAUDE.md (only if substantial)

Review what happened this session. If there are new learnings, corrections, patterns, or behavioral changes that should persist, propose updates to CLAUDE.md.

Don't run a full rewrite — for small updates, just make the edit directly. For large changes, propose the change and ask before applying.

## Step 5: Commit any tracked changes

If the user works in version-controlled directories and changed files this session:
1. Show what's uncommitted (`git status` in relevant directories)
2. Offer to commit + push with a descriptive message
3. Skip if user declines

## Step 5.5: Calendar sweep (only if a calendar is connected)

Look back over the session's Open Loops for anything only the user can do (a login-gated edit, a send, an approval, a decision) that doesn't have a calendar event yet. If a calendar tool is connected, propose events for them following `docs/calendar-handoff-primer.md`: every location in the description, a paste block for resume-work items, no invitations to anyone. Check existing events first so nothing lands twice. If no calendar tool is connected, list those items in the report instead and say they aren't scheduled.

## Step 6: Report

Present the session summary and a status table:

```
SESSION END REPORT
━━━━━━━━━━━━━━━━━━━
Step 0 (Transcript recovery):  ✅/⏭️ skipped/❌ failed
Step 1 (Summary):              ✅
Step 2 (Persist):              ✅
Step 3 (Active context):       ✅
Step 3.5 (Handoff top block):  ✅  → <project>/handoff.md
Step 3.6 (Decisions check):    ✅/⏭️
Step 4 (CLAUDE.md):            ✅/⏭️
Step 5 (Commits):              ✅/⏭️
Step 5.5 (Calendar sweep):     ✅/⏭️ no calendar connected
━━━━━━━━━━━━━━━━━━━

**Tell the user:** "Handoff saved to the top of `<project>/handoff.md`. In a new thread, say 'pick up the handoff' or paste the block under `--- PASTE BELOW ---`."
```

**If the user wants to keep going in this same session instead** and context is getting low, state is now saved, so offer a paste-ready compact line naming what must survive, e.g. `/compact Keep: [active task + branch], [open decisions], [what's waiting on the user], [rules granted this session]. Drop: [tool output already saved to files].` Never suggest compacting before Steps 3.5 and 5 have run.

Confirm with the user that everything looks right.

---

## Headroom Note

If context is below 15% remaining when this is invoked, **skip the heaviest steps** (transcript recovery, full summary) and just write a brief active-context.md update + a one-paragraph session summary. The fallback should always succeed even at low context.
