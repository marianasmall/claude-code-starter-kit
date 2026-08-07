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
- **Key Decisions** (choices made — include the reasoning and alternatives, not just outcomes)
- **Next Steps** (pending items or follow-ups)
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

**Next Steps:**
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

## Step 3.5: Generate Handoff Prompt

Write a copy-paste-ready handoff message to `<project>/handoff.md` — the project folder where the work lives. **REPLACES contents** every session — only the latest matters. (Historical handoffs live in your session summaries; this file is just the copy-paste shortcut.)

**Detect "primary project":**
- If cwd is in a project repo (has `CLAUDE.md`, `handoff.md`, or `~/Projects/<name>/` pattern) → write to `<project>/handoff.md`
- If session touched MULTIPLE projects → ask the user which is primary; default to most-recently-modified
- If no project context (system-level only) → skip; `active-context.md` already serves as continuation state

**Template:**

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

**Last session log:** [path or URL — depends on where Step 2 saved it]

**Next action when you pick up:** [the one thing to do first]
```

**The user's ritual:** at session close after this command runs, open `<project>/handoff.md`, copy contents below the `---` line, paste into a new Claude Code thread to continue.

**On-demand version:** the `/kit:handoff` command runs ONLY this step (no session summary, no commits) — useful for mid-session context switches.

## Step 4: Update CLAUDE.md (only if substantial)

Review what happened this session. If there are new learnings, corrections, patterns, or behavioral changes that should persist, propose updates to CLAUDE.md.

Don't run a full rewrite — for small updates, just make the edit directly. For large changes, propose the change and ask before applying.

## Step 5: Commit any tracked changes

If the user works in version-controlled directories and changed files this session:
1. Show what's uncommitted (`git status` in relevant directories)
2. Offer to commit + push with a descriptive message
3. Skip if user declines

## Step 6: Report

Present the session summary and a status table:

```
SESSION END REPORT
━━━━━━━━━━━━━━━━━━━
Step 0 (Transcript recovery):  ✅/⏭️ skipped/❌ failed
Step 1 (Summary):              ✅
Step 2 (Persist):              ✅
Step 3 (Active context):       ✅
Step 3.5 (Handoff prompt):     ✅  → <project>/handoff.md
Step 4 (CLAUDE.md):            ✅/⏭️
Step 5 (Commits):              ✅/⏭️
━━━━━━━━━━━━━━━━━━━

**Tell the user:** "Handoff prompt saved to `<project>/handoff.md` — open it, copy below the `---` line, paste into a new Claude Code thread."
```

Confirm with the user that everything looks right.

---

## Headroom Note

If context is below 15% remaining when this is invoked, **skip the heaviest steps** (transcript recovery, full summary) and just write a brief active-context.md update + a one-paragraph session summary. The fallback should always succeed even at low context.
