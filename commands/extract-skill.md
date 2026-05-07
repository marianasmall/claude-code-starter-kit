---
name: extract-skill
description: Scaffold a new skill from an emerging pattern in conversation. Quick capture so good patterns become reusable.
argument-hint: "[skill name]"
---

# /extract-skill — Fast Skill Scaffolding

Capture a reusable pattern from this conversation as a new skill.

## When to use

You just solved a problem in a way that:
- Took non-obvious thinking to figure out
- You'd want to apply again in a similar context
- Has clear-enough triggers that Claude could activate it autonomously next time

If it doesn't pass that bar, use `/note` instead.

## What to do

### 1. Determine name + description

If `$ARGUMENTS` is provided, use as a slug. Otherwise ask:
- "What's the skill name?" (kebab-case, 1-3 words)
- "When should this skill activate?" (the description — frame in third person, e.g., "Use when the user asks for X")

### 2. Reconstruct the pattern

Look back at the recent conversation and extract:
- **What was the problem?** (one paragraph)
- **What was the approach that worked?** (steps, principles, or framework)
- **What were the trigger words/phrases?** (so Claude knows when to activate)
- **What were the gotchas?** (things that almost went wrong, edge cases)

If any of these are unclear, ask the user to clarify before writing.

### 3. Decide skill location

Ask: "Where should this skill live?"
- `~/.claude/skills/<name>/` — personal skill, available immediately
- Inside a plugin directory — if user wants to ship it to others
- Project-local at `<project>/.claude/skills/<name>/` — only available in this project

### 4. Write SKILL.md

Create `<location>/<name>/SKILL.md` with this structure:

```markdown
---
name: <skill-name>
description: <Third-person description with explicit trigger phrases. Use when [context]. Triggers on '<phrase 1>', '<phrase 2>'.>
---

# <Skill Title>

<One-paragraph framing of what this skill does.>

## When to Use

- <Specific situation 1>
- <Specific situation 2>
- <Trigger phrases>

## Approach

<The methodology that worked. Numbered steps or principles.>

### Step 1: <name>
<details>

### Step 2: <name>
<details>

## Gotchas

- <thing that almost went wrong>
- <edge case to watch for>

## Examples

<Brief example showing the skill in use, if helpful.>
```

### 5. Confirm

Tell the user:
```
Skill scaffolded: <location>/<name>/SKILL.md
Triggers: <phrases>
Test it by asking something that should trigger it (e.g., "<example query>")
```

Optionally suggest invoking the `plugin-dev:skill-reviewer` agent to validate the skill before committing it.

## Why this exists

Patterns are most legible right after they emerge. If you wait until end-of-session, the texture is lost. This makes capture as fast as `/note` so good patterns don't escape.

The four-test gate before extracting (per skill-extraction discipline):
1. **Repeatable** — Will this come up again?
2. **Non-obvious** — Did it take real thinking?
3. **Triggerable** — Are the activation conditions clear?
4. **Worth the friction** — Does loading the skill cost less than re-deriving?

If you can't honestly say yes to all four, this isn't a skill — it's a note. Use `/note` instead.
