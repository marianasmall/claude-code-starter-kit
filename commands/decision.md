---
name: decision
description: Log a structured decision with reasoning, alternatives, and predicted outcome. For tracking decision quality over time.
argument-hint: "[short description of decision]"
---

# /decision — Structured Decision Log

Log a significant decision with enough structure to evaluate its quality later.

## Workflow

If the user provides `$ARGUMENTS`, use it as the decision title. Otherwise, ask: "What decision are we logging?"

Then walk the user through these fields:

1. **What was decided?** (one-liner — the actual choice made)
2. **Why?** (the reasoning — what made this the right call)
3. **Alternatives considered?** (what else was on the table, and why those were rejected)
4. **Confidence at decision time?** (HIGH / MEDIUM / LOW with one-line rationale)
5. **Predicted outcome?** (what success looks like, what failure looks like)
6. **Review trigger?** (what event/timeframe should prompt revisiting this — "in 30 days," "after first client uses it," "if X happens")

Keep questions terse — don't make it feel like a form.

## Persisting

Append to `~/.claude/decision-log.md` (create with header if missing):

```markdown
## YYYY-MM-DD — <Decision Title>

**Decided:** <one-liner>
**Why:** <reasoning>
**Alternatives:** <considered + why rejected>
**Confidence:** <H/M/L> — <rationale>
**Predicted outcome:** <what success/failure looks like>
**Review trigger:** <when to revisit>
**Outcome:** _(pending)_

---
```

Confirm with: `Decision logged. Review trigger: <trigger>.`

## Outcome update mode

If the user runs `/decision review` or `/decision outcome`, list the most recent 5 decisions where Outcome is `_(pending)_` and walk them through filling in actual outcomes.

For each:
- **Actual outcome?** (what really happened)
- **Calibration?** (was confidence well-calibrated? where did predictions miss?)

Update the entry in-place (replace `_(pending)_` with the outcome paragraph).

## Why this exists

Decisions made in the moment look obvious in retrospect — usually wrong. The journal forces explicit reasoning + creates a feedback loop on confidence calibration. Most useful for: strategic choices, architectural picks, hiring/client decisions, methodology pivots.

Don't use for trivial choices ("which color"). Use for: choices you'd want to second-guess in 3 months.
