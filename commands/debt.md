---
name: debt
description: Review and resolve operational debt items — the running log of things flagged mid-session that need closure
argument-hint: "[add <severity> <description>]"
---

# Operational Debt Review

Read `~/.claude/debt.md` and present debt items for review. Follow this exact flow:

## If `$ARGUMENTS` starts with "add"

Parse as `add <severity> <effort> <description>` (e.g., `add MED ~30m Reconnect Slack MCP server`). Effort defaults to `~30m` if omitted. Append a new `[ ]` entry to the `## Open` section of `~/.claude/debt.md` with today's date (absolute, not "today"). Confirm with: `Added: [sev] [effort] description (N total open)`. Do not enter review mode.

## Otherwise — enter review mode

**Step 1: Read the file.** Parse all `[ ]` entries under `## Open`. If `~/.claude/debt.md` doesn't exist, create it with this structure:

```
# Operational Debt Register

## Open

## Resolved

## Deferred / Dismissed
```

Then report "Debt register initialized — no open items" and end.

**Step 2: Show the header.**
```
━━━━ DEBT REGISTER: N open items ━━━━
 CRIT: x   HIGH: x   MED: x   LOW: x          ~5m: x   ~30m: x   ~2h+: x
```

**Step 3: Pre-select top 3 "for today."** Sort open items by:
1. Severity descending (CRIT → HIGH → MED → LOW)
2. Within same severity, age descending (oldest first)

Show them with one-letter action prompts (include effort tag so the user can batch by available time):

```
▼ Top 3 for today:
  1. [CRIT, ~5m, 8d] Description here                          [r / d / x ?]
  2. [HIGH, ~30m, 3d] Description here                         [r / d / x ?]
  3. [MED, ~2h, 5d]  Description here                          [r / d / x ?]
```

**Step 4: Show the full open list in a compact table.**

```
▼ All open items:
  #  SEV   EFF   AGE  DESCRIPTION
  1  CRIT  ~5m    8d  ...
  2  HIGH  ~30m   3d  ...
  ...
```

**Step 5: Prompt for action.**

End with: *"Pick an item by number, then tell me: **r**esolve / **d**efer (with reason) / **x** dismiss. Or say 'skip' to close without changes."*

## Actions

When the user responds with `<number> r` or `<number> resolve`:
- Move the item from `## Open` to `## Resolved`
- Change `[ ]` to `[x]`
- Append `→ resolved YYYY-MM-DD` to the line
- Confirm: `Resolved #N. N-1 items remaining.`

When the user responds with `<number> d <reason>` or `<number> defer <reason>`:
- Move the item from `## Open` to `## Deferred / Dismissed`
- Change `[ ]` to `[-]`
- Append `→ deferred YYYY-MM-DD (reason: ...)`
- Confirm: `Deferred #N. N-1 items remaining.`

When the user responds with `<number> x` or `<number> dismiss`:
- Move the item from `## Open` to `## Deferred / Dismissed`
- Change `[ ]` to `[~]`
- Append `→ dismissed YYYY-MM-DD`
- Confirm: `Dismissed #N. N-1 items remaining.`

After any action, ask: *"Next item?"* unless all items are closed, in which case end with: *"Debt register clear. Nice."*

## When flagging new items mid-session (for Claude, not user-triggered)

When YOU (Claude) say "flag," "noted," "pending," "later," "follow-up," or similar deferral language about a concrete action item, immediately append to `~/.claude/debt.md` with Edit/Write tool. Use format:

```
- [ ] `SEV` `EFFORT` YYYY-MM-DD — One-line description of what needs to happen and why it's open.
```

Severity heuristic:
- `CRIT` = blocks current work / data loss risk / security
- `HIGH` = blocks next step / client deliverable impact
- `MED` = operational friction, workaround exists
- `LOW` = nice-to-have, no time pressure

Effort heuristic (coarse on purpose — don't estimate precisely):
- `~5m` = trivial (flip a config, decide a yes/no, quick delete)
- `~30m` = focused slice (rewrite a section, research + execute a decision)
- `~2h` = real block (new hook, non-trivial build, anything with multiple subtasks)

Do not ask the user to pick severity or effort — make your best call and note both. They can override via `/kit:debt`.
