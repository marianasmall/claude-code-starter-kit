---
name: learning-capture
description: "Use when you want to capture, review, or export learning moments from conversations. Triggers on 'pin this', 'capture that', 'learning moment', 'remember this insight', or 'export learnings'."
metadata:
  version: "1.0.0"
  status: active
---

# Learning Capture

Extracts and structures learning moments from conversations.

## Core Philosophy

Learning happens in conversation but evaporates without capture. This skill creates a lightweight habit loop:
1. **Notice** something valuable → PIN it
2. **Review** accumulated pins → APPROVE or SKIP
3. **Export** approved items → Notion database

## Modes

### PIN Mode

Triggers: "pin this", "capture that", "save this", "mark this learning", "that's useful"

When triggered:
1. Extract the learning moment from recent context (last 2-3 exchanges usually)
2. Auto-suggest a category (user can override)
3. Generate a concise title (5-8 words)
4. Capture the core insight (1-3 sentences)
5. Note the source context (what prompted this)
6. Add to session's capture buffer
7. Confirm with brief summary, continue conversation naturally

**Capture format:**
```
[PIN #{n}]
Title: {concise title}
Category: {framework|decision|insight|question|term|resource}
Insight: {1-3 sentence core takeaway}
Context: {what prompted this / conversation thread}
Timestamp: {ISO datetime}
```

### REVIEW Mode

Triggers: "review captures", "what did I learn", "show pins", "review learning"

When triggered:
1. Display all session captures in numbered list
2. For each item, user can:
   - **APPROVE** (or just the number) → keeps item, moves to export queue
   - **SKIP** → removes from queue
   - **EDIT** → modify title, category, or insight
   - **MERGE** → combine related items
3. Show summary: X approved, Y skipped, Z remaining

**Review display format:**
```
## Learning Captures ({n} items)

1. [framework] **Title here**
   Insight summary...
   → approve / skip / edit?

2. [insight] **Another title**
   ...
```

### EXPORT Mode

Triggers: "export to notion", "send learning to notion", "save captures to notion"

When triggered:
1. Confirm target: Notion database for learning captures
2. For each approved item, create Notion page with properties:
   - Title (title property)
   - Category (select)
   - Insight (rich text)
   - Source Context (rich text)
   - Capture Date (date)
   - Session Link (url - if available)
3. Report: X items exported, provide Notion links

**If no Notion database exists:** Offer to create one with appropriate schema, or output as markdown for manual transfer.

## Categories

| Category | Use for | Examples |
|----------|---------|----------|
| framework | Mental models, approaches, methodologies | "4 C's of IA", decision matrices |
| decision | Choices made, rationale captured | "Chose X over Y because..." |
| insight | Eureka moments, unexpected connections | "Realized that A relates to B" |
| question | Open threads, areas to explore | "Need to investigate X" |
| term | Vocabulary, definitions worth remembering | "RAG means...", jargon decoded |
| resource | Tools, links, references discovered | URLs, tool names, book recs |

## Implicit Capture Signals

Beyond explicit "pin this" triggers, watch for:
- "Oh interesting" / "huh" / "that's good"
- "I should remember that"
- "Wait, say that again"
- "That's exactly what I needed"
- Asking to repeat or clarify something valuable

When detected, gently offer: "Want me to pin that insight?"

## Session Persistence

Captures persist within a conversation session. At natural break points or session end:
- Offer review if captures exist
- Remind user of pending unexported items
- Suggest export before context loss

## Integration Notes

**For Notion export:**
- Use notion-create-pages tool with appropriate data_source_id
- Schema: Title (title), Category (select), Insight (rich_text), Source Context (rich_text), Capture Date (date)
- If user has existing learning database, adapt to their schema

**Without Notion access:**
- Output as structured markdown
- Offer to save as file in outputs directory
- Format suitable for manual paste into any system

## Quick Reference

| Want to... | Say... |
|------------|--------|
| Capture something | "pin this" / "capture that" |
| See all captures | "review captures" / "what did I learn" |
| Approve an item | "approve 1" or just "1" |
| Skip an item | "skip 2" |
| Edit an item | "edit 3 - change category to decision" |
| Export everything | "export to notion" |
| Quick export all | "approve all and export" |