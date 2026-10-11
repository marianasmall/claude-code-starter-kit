# Plan Mode Primer

Plan mode is one of the most underused native Claude Code features. It changes how Claude approaches a task by forcing a planning step before any execution.

## What it does

In plan mode, Claude:
1. Analyzes the task
2. Proposes a step-by-step plan
3. Waits for your approval
4. Only then begins executing

While in plan mode, Claude **can't edit your files** until you approve the plan. It can still read files and run commands that look around (searching, listing, checking git status), and in auto mode a safety check approves those for you. So plan mode means "no changes yet", not "no commands at all".

## When to use it

Plan mode shines for:

| Situation | Why plan mode helps |
|---|---|
| **Multi-step refactors** | Forces explicit thinking about order of operations |
| **Touching unfamiliar code** | Surfaces what Claude understands vs. assumes |
| **High-stakes changes** | You want to know what's about to happen before it does |
| **Long sessions** | Plans are checkpoints — easier to recover from compaction |
| **Working with someone else's codebase** | Plan reveals Claude's mental model so you can correct it |

## When NOT to use it

Skip plan mode for:

- Simple, single-file edits
- Quick lookups or research
- Brainstorming (you want exploration, not commitment)
- "Just answer my question" type requests

Plan mode adds friction. Friction is good when stakes are high and bad when stakes are low.

## How to enter plan mode

Several ways:

**1. Explicitly via slash command:**
```
/plan
```
(Or press **Shift+Tab** to cycle permission modes until the plan-mode indicator shows.)

**2. By telling Claude:**
> "Use plan mode for this — I want to see the plan before you start."

Or:
> "Plan first, then execute after I approve."

**3. Via tool restriction:**
Claude can be invoked with restricted tools (no Edit, no Bash) and forced to plan instead of execute. Some skills/agents do this internally.

## How to exit plan mode

When the plan is ready, Claude shows it with a menu of choices:

- **Yes, and use auto mode**: approve the plan and let Claude work through it in auto mode. Note that this switches the whole session into auto mode, not just this plan. (If auto mode isn't available to you, this option reads **Yes, auto-accept edits**.)
- **Yes, manually approve edits**: approve the plan and review each file change as Claude makes it.
- **No, keep planning**: stay in plan mode and tell Claude what to change.

To leave plan mode without approving anything, press **Shift+Tab** to switch to another mode. To plan again later, press Shift+Tab until plan mode shows, or start your message with `/plan`. Details: [permission modes docs](https://code.claude.com/docs/en/permission-modes#review-and-approve-a-plan).

## What a good plan looks like

A useful plan includes:

1. **What's about to happen** (the actual changes)
2. **What order** (dependencies between steps)
3. **What gets touched** (specific files/paths)
4. **What gets verified** (how Claude will know it worked)
5. **What's *not* in scope** (calling out what's deliberately excluded)

If a plan is too vague, push back: "Be more specific about step 3."

## Plan mode + this kit

The `superpowers` plugin (recommended in `settings.json.template`) ships several skills that pair well with plan mode:

- `superpowers:writing-plans` — Skill for writing implementation plans before code
- `superpowers:executing-plans` — Skill for following a written plan with review checkpoints

Pattern: write the plan in plan mode → save it as a markdown file → execute it in a fresh session with `superpowers:executing-plans`.

## Don't over-plan

Plan mode can become procrastination. If you find yourself in plan mode for 30 minutes, that's a signal to:
- Cut scope
- Just start and learn
- Or admit you don't have enough context yet (do research first, don't plan in a vacuum)

Plan mode is a tool for *clarity*, not *certainty*.
