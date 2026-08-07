---
name: idea-to-scope
description: Transform vague ideas into structured scope documents through guided questioning. Use when someone says "I want to build...", "Can you help me with a project...", "I have an idea for...", or presents an unclear request that needs definition before execution. Warm but persistent — extracts what's actually needed before diving into implementation.
metadata:
  version: "1.0.0"
  status: active
---

# Idea to Scope

Transform rough ideas into clear, actionable scope documents through structured conversation.

## Foundational Principle

**Don't start building until you know what you're building.** Vague requests lead to wasted effort, misaligned expectations, and scope creep. This skill ensures the idea is fully defined before any implementation begins.

## When to Activate

- "I want to build..." / "I have an idea for..."
- "Can you help me with a project..."
- Any request where the goal, constraints, or success criteria are unclear
- When someone jumps straight to "how" without establishing "what" or "why"

## Core Approach

**Warm but persistent.** Every question includes context for WHY that information matters. Don't interrogate — collaborate. But don't let gaps slide.

Example framing:
- ❌ "What's the timeline?"
- ✅ "I need to understand timeline because it affects whether we build something quick-and-dirty or invest in a robust solution. When do you need this working?"

## The Scoping Sequence

Work through these phases in order. Don't skip ahead.

### Phase 1: The Real Goal (2-3 questions)

Before anything else, understand what success looks like.

| Question | Why it matters |
|----------|----------------|
| "What are you trying to accomplish?" | Surface the actual goal, not the assumed solution |
| "What problem does this solve? What's painful right now?" | Grounds the project in real need |
| "If this works perfectly, what changes?" | Defines success in concrete terms |
| "What else could this be used for?" | Surfaces adjacent opportunities — a slightly broader framing might unlock more value |

**Checkpoint:** Reflect back the goal in one sentence. Get explicit confirmation before proceeding.

### Phase 2: Constraints & Context (4-6 questions)

Constraints shape every decision. Get them early.

| Question | Why it matters |
|----------|----------------|
| "When do you need this? Is that a hard deadline or preferred?" | Timeline determines complexity tolerance |
| "Who else is involved or affected?" | Surfaces stakeholders, approvals, dependencies |
| "What do you already have that we can use?" | Prevents rebuilding what exists |
| "What's definitely out of scope?" | Prevents scope creep, focuses effort |
| "Are there budget or resource limits?" | Affects build vs. buy, DIY vs. hire |
| "What have you already tried?" | Avoids repeating failed approaches |

**Checkpoint:** Summarize constraints. Confirm nothing's missing.

### Phase 3: Requirements & Edge Cases (3-5 questions)

This is where vague ideas fall apart. Push for specifics.

| Question | Why it matters |
|----------|----------------|
| "Walk me through how someone would actually use this." | Exposes hidden requirements |
| "What happens when [X edge case]?" | Surfaces unconsidered scenarios |
| "What data or inputs does this need? Where do they come from?" | Identifies dependencies and integration points |
| "Who decides if this is 'done'? What would they check?" | Defines acceptance criteria |
| "What's the simplest version that would still be useful?" | Establishes MVP scope |

**Checkpoint:** Validate requirements back in chunks (3-4 items at a time, not a wall of text). Get confirmation on each chunk before continuing.

### Phase 4: Open Questions & Risks

Surface what's still uncertain. It's better to name unknowns than ignore them.

- "What are you still unsure about?"
- "What could go wrong?"
- "What decisions can we make now vs. what needs more information?"

## Chunk Validation Protocol

**Never dump a full scope doc without incremental validation.**

After each phase:
1. Summarize what you understood (keep it short — 3-5 bullet points max)
2. Ask explicitly: "Did I get that right? Anything to add or correct?"
3. Only proceed after confirmation

This prevents the "I said that 30 messages ago" problem.

## Not Done Until

The scoping conversation is complete when you can fill out every section of the Scope Document (see template below) AND the person has confirmed each section.

If gaps remain, name them explicitly: "We still need to figure out [X] before starting. Can you find that out, or should we flag it as an open question?"

## Output: Scope Document

When scoping is complete, produce this document:

```markdown
# [Project Name] — Scope Document

## Goal
[One sentence: what this accomplishes and why it matters]

## Success Criteria
[Bullet list: how we'll know it's working]

## Requirements
### Must Have
- [Critical for MVP]

### Should Have
- [Important but not blocking]

### Out of Scope
- [Explicitly excluded]

## Constraints
- **Timeline:** [Date and whether hard/soft]
- **Budget/Resources:** [Limits, if any]
- **Dependencies:** [What we need from others]
- **Stakeholders:** [Who's involved, who decides]

## Existing Assets
[What already exists that we can use]

## Open Questions
[What still needs to be figured out]

## Next Steps
[Immediate actions to move forward]
```

## Additional Considerations

After delivering the scope document, offer 1-2 observations based on patterns you noticed during the conversation. This is where you add value beyond extraction.

Frame as possibilities, not prescriptions:
- "Given what you're building, this could also work for [adjacent use case] — worth considering?"
- "I noticed [X and Y] have similar structures. If you solve this well, it might apply to [Z] too."
- "One thing that often comes up with projects like this: [common extension or pitfall]. Something to keep in mind."

**When to skip:** If the scope is already ambitious or the person seems eager to start, don't pile on. The goal is to surface opportunities, not create scope creep.

## Anti-Patterns to Avoid

- **Firing questions without context** — Always explain why you're asking
- **Accepting "I don't know" without probing** — Try "What would you guess?" or "Who might know?"
- **Moving to implementation before scoping is complete** — Resist the urge to start building
- **Showing the full scope doc before chunk validation** — They won't read it; validate incrementally
- **Letting scope remain vague because "we'll figure it out"** — Name the gaps explicitly

## Example Transformation

**Vague request:**
> "I want to build something to track car maintenance."

**After scoping:**
> **Goal:** Track maintenance history and upcoming service for personal vehicles so nothing gets missed.
>
> **Success Criteria:** Can log maintenance events, see history per car, get reminders for scheduled service.
>
> **Must Have:** Add cars, log maintenance with date/mileage/cost, view history, basic reminders.
>
> **Out of Scope:** Multi-user, shop integration, parts inventory.
>
> **Timeline:** No hard deadline, but want something usable within 2 weeks.
>
> **Existing Assets:** Spreadsheet with past maintenance data for 2 cars.
>
> **Open Questions:** How should reminders work — email, app notification, or just a dashboard flag?

---

*This skill ensures that before any building starts, everyone agrees on what "done" looks like.*