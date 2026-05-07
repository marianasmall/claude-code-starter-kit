---
name: note
description: Quick timestamped note to today's daily-notes file. ADHD-friendly inbox capture.
argument-hint: "<note text>"
---

# /note — Quick Capture

Append `$ARGUMENTS` to today's daily notes file with a timestamp.

## What this does

1. Compute today's date as `YYYY-MM-DD`
2. Target file: `~/.claude/notes/YYYY-MM-DD.md`
3. Create `~/.claude/notes/` if it doesn't exist
4. Create the daily file with a `# YYYY-MM-DD Notes` header if it doesn't exist
5. Append the note with current time:

```markdown
- HH:MM — $ARGUMENTS
```

6. Confirm with: `Noted (N total today).` where N is the count of bullets in the file.

## When the user invokes this without arguments

Show today's notes (read the daily file). If the file is empty or missing, say "No notes yet today."

## Examples

- `/note remembered to email the client` → adds `- 14:23 — remembered to email the client`
- `/note that bug repro is in commit a3f4b21` → adds with timestamp
- `/note` → shows today's notes

## Why this exists

Quick capture without surface-switching. Mid-flow when something pops into your head, you don't want to open Notion or break your context. The daily file is reviewable at end of day or rolled into `/reflect`.
