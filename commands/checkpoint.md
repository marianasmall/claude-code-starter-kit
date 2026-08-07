---
name: checkpoint
description: Save explicit mid-session state snapshot to ~/.claude/checkpoints/. Useful for branching exploration.
argument-hint: "[label]"
---

# /checkpoint — Save State Snapshot

Save a mid-session state snapshot to `~/.claude/checkpoints/` for later return.

## When to use

- About to try a risky/exploratory direction and want to remember the current point
- Branching: "let me try approach A, but bookmark approach B"
- About to compact context and want to preserve the current state explicitly
- Ending a working session early but might resume later same-day

## What to do

### 1. Determine label
- If `$ARGUMENTS` is provided, use it as the label
- Otherwise, ask: "What's this checkpoint for? (one-line)"

### 2. Build the snapshot

Create a checkpoint file at `~/.claude/checkpoints/YYYY-MM-DD_HHMM_<slug>.md` containing:

```markdown
# Checkpoint: <label>

**Created:** YYYY-MM-DD HH:MM
**Session:** <session_id from active env or "unknown">
**Working directory:** <pwd>

## Current task
<one-paragraph description of what we're doing right now>

## What's been done so far
- <bullet list of significant accomplishments this session>

## What's next
- <bullet list of immediate next steps>

## Open questions / decisions pending
- <any unresolved items>

## Files in flight
- <list of files modified but possibly not committed>

## How to resume
1. Open Claude Code
2. cd into <working directory>
3. Tell Claude: "Resume from checkpoint <slug>"
4. (Claude will read this file and continue)
```

### 3. Confirm

Tell the user:
```
Checkpoint saved: ~/.claude/checkpoints/YYYY-MM-DD_HHMM_<slug>.md
To resume later: tell Claude "resume from checkpoint <slug>"
```

## Resume flow

If the user says "resume from checkpoint <slug>" or "resume <slug>":
1. Find the file in `~/.claude/checkpoints/` matching the slug (most recent if multiple)
2. Read it
3. Brief the user: "Found checkpoint from <date>. Loading: <one-line task description>. Ready to continue?"
4. Wait for confirmation before doing anything destructive

## Cleanup

Suggest: checkpoints older than 30 days can be archived or deleted. The `/kit:maintain` command's cleanup section can handle this if added to the cleanup list.

## Why this exists

Sometimes you want to bookmark "I was here" without ending the session. Different from `/kit:session-end` (full close-out) and from active-context.md (single most-recent state). Checkpoints accumulate; you can have many. Useful for exploration where you might genuinely want to come back to a previous fork point.
