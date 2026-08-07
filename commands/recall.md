---
name: recall
description: Search across all memory layers for a topic, decision, or conversation. Use when trying to find something discussed in a past session.
---

# /recall — Cross-Session Memory Search

Search query: `$ARGUMENTS`

## Search Strategy

Run these searches in parallel and synthesize the results:

### Layer 1: Memory Files (fastest, most curated)
Search `~/.claude/projects/*/memory/` directories for relevant topic files using grep. Memory files contain curated patterns, feedback, and project notes that you (Claude) have written across sessions.

### Layer 2: Active context + debt + dead-ends
Quick grep across:
- `~/.claude/active-context.md` — current state
- `~/.claude/debt.md` — open + resolved debt items
- `~/.claude/dead-ends.md` — failed approaches (skip if user is asking about something to try)
- `~/.claude/MEMORY.md` (if present) — index of memory topics

### Layer 3: Session log + transcripts (deepest, slowest)
Use `~/.claude/session-log.md` to identify candidate transcripts by date, then grep the `.jsonl` transcript files for the query terms. Don't read full transcripts — grep for relevant lines and read 10 lines of surrounding context.

### Layer 4 (optional): Notion or external knowledge bases
If the user has connected a Notion workspace or other external knowledge base via MCP, query it as well. Skip if no MCP integration is present.

## Presenting Results

Present findings organized by relevance, not by source:

1. **Direct answer** — If the search clearly answers the question, lead with that
2. **Source** — Which session(s) or memory file(s) the answer came from, with dates
3. **Transcript available** — If a session-log entry has a transcript path, mention it: "Full transcript available if you want me to dig deeper"
4. **Confidence** — HIGH if found in multiple sources, MEDIUM if single source, LOW if inferred

If nothing is found across all layers, say so honestly. Don't guess.

## Examples

- `/kit:recall when did we set up the hook system` → finds the setup session and configuration details
- `/kit:recall what did we decide about [topic]` → finds the discussion and decision
- `/kit:recall [project] timeline` → finds when/what was decided about that project
- `/kit:recall errors with [tool]` → finds prior failures and what fixed them
