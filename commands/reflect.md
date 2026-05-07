---
name: reflect
description: End-of-session reflection to capture learnings and route them to persistent surfaces
argument-hint: "[quick|deep]"
---

# Reflect: $ARGUMENTS

Run a structured end-of-session reflection to capture learnings and route them to the right surfaces. This is a self-improving learning loop — each session makes the next one better.

**Mode selection:**
- If `$ARGUMENTS` is empty or "quick": run **Quick Reflect** (default — use after every session)
- If `$ARGUMENTS` is "deep": run **Deep Reflect** (use after build sessions, messy sessions, or when something went wrong)

---

## Quick Reflect (Default)

Answer these 5 questions. Be honest, not performative. If the answer is "nothing" for a question, say so and move on.

### 1. What worked well?
What went right this session? What patterns, tools, or approaches should be reinforced?

### 2. Staff Engineer Review
If a staff engineer reviewed everything we built or discussed this session, what would they flag? This includes: over-engineering, under-testing, missed edge cases, architectural concerns, scope creep, or low-value work that should have been caught.

### 3. Confidence Calibration
Where did I signal confidence I didn't have? Where was I uncertain but didn't say so? Where did I hedge when I should have been direct? This is the single most important self-correction — miscalibrated confidence erodes trust.

### 4. What would make the next session better?
One concrete thing — a missing context file, a tool that should exist, an instruction that's unclear, a pattern to watch for.

### 5. Correction extraction — what did the user keep correcting me on?

Where did the user have to repeat or correct me multiple times this session? Each repeated correction is a signal that **the canonical files are missing context the system needs.** This is a learning-extraction prompt, not a satisfaction check.

For each repeated correction, answer:
- What was the user correcting?
- What context is missing that would have prevented it?
- WHERE should that context land? (CLAUDE.md, MEMORY.md, a new memory file, active-context.md, a skill description, a CONTEXT-SUMMARY.md?)

If the answer is "nothing — no repeated corrections" — that's a sign canonical files are well-tuned. Note it and move on.

This is more powerful than #3 (Confidence Calibration) because it surfaces gaps the AI didn't realize it had. #3 is self-reported uncertainty; #5 is externally-revealed missing context.

### 6. Forward Motion (Routing)
This is the mandatory step. Reflections that don't route somewhere don't compound.

For each applicable surface, make the update directly (don't just note it):

| Surface | What goes here | Action |
|---------|---------------|--------|
| **MEMORY.md** | Tactical observations, patterns noticed, preferences learned | Write directly with appropriate tag |
| **CLAUDE.md** | Strategic instruction changes, new workflows, permission updates | Propose to user, apply if approved |
| **Dead Ends** (`~/.claude/dead-ends.md`) | Approaches that failed and why | Append entry |
| **Session Summary** | Handled by `/session-end` — just flag what to include | Note for next step |

After routing, tell the user: "Reflection complete. Run `/session-end` to log the session."

---

## Deep Reflect

Run all 6 Quick Reflect questions above PLUS the following additional sections:

### 7. Error Taxonomy
What went wrong this session, and what TYPE of error was it?

| Error Type | Fix Category | Where to Fix |
|------------|-------------|--------------|
| Misunderstood intent | Better context upfront | MEMORY.md or ask earlier |
| Wrong tool choice | Instruction gap | CLAUDE.md |
| Missing context | Memory gap | MEMORY.md or active-context.md |
| Architectural misjudgment | Process gap | Use plan mode next time |
| Scope creep | Discipline gap | Constitution reminder |
| Repeated failure | Pattern problem | Check dead-ends.md and MEMORY.md tags |

Classify each error and propose the structural fix, not just the immediate patch.

### 8. Cross-Session Patterns
Check MEMORY.md for tagged observations (`[PATTERN]`, `[DRIFT]`, `[FRICTION]`, `[TOOL-GAP]`, `[DEAD-END]`).

- Is today's issue a first occurrence or a recurring pattern?
- If recurring: this is a system problem, not a note problem. What structural fix does it need?
- If first occurrence: tag it and move on. It becomes a pattern only if it repeats.

### 9. Dead Ends
What did we try that didn't work, and why? Log each to `~/.claude/dead-ends.md` with:
- Date
- What was attempted
- Why it failed
- What to do instead

This prevents future sessions from retrying failed approaches.

### 10. Capability Gaps
Where did I hit the edge of what I can do well? Classify:

| Gap Type | Example | Where to Route |
|----------|---------|---------------|
| Tool gap | "No MCP server for X" | Future build list |
| Context gap | "Didn't know about Y" | MEMORY.md |
| Instruction gap | "Wasn't clear I should Z" | CLAUDE.md |
| Knowledge gap | "Don't know enough about W" | Flag for research |

### 11. Automation Opportunities
Is there anything we did repeatedly that could be automated? A hook, a skill, a workflow, an agent? If the answer is yes, log to a build list with enough detail to construct it later.

### 12. ROI on Complexity
Did solution complexity match problem complexity? Over-engineered or under-engineered? The right amount of complexity is the minimum needed for the current task.

### 13. Knowledge Transfer Check
If a fresh Claude Code session started tomorrow with only CLAUDE.md and MEMORY.md, what critical knowledge from this session would be missing? Whatever that is — route it now.

### Forward Motion (same as Quick, but more thorough)
Run the same routing table from Quick Reflect, but with the additional items from sections 7-13 included.

After routing, tell the user: "Deep reflection complete. Run `/session-end` to log the session."

---

## MEMORY.md Tags Reference

When writing to MEMORY.md during reflection, use these tags for pattern detection:

- `[PATTERN]` — Recurring behavior or preference (positive or negative)
- `[DRIFT]` — Moment where I drifted from partnership principles
- `[FRICTION]` — Something that slowed us down or caused unnecessary effort
- `[TOOL-GAP]` — Missing tool or capability that would have helped
- `[DEAD-END]` — Approach that failed (also log to dead-ends.md)
- `[CONTEXT-GAP]` — Missing information that caused problems
- `[WIN]` — Something that worked exceptionally well and should be repeated

---

## Principles

- **Honesty over comfort.** A reflection that makes me look good but misses the real issues is worse than useless.
- **Specific over general.** "Communication could be better" is useless. "I should have flagged the API limitation before spending 10 minutes on it" is actionable.
- **Route or it doesn't count.** Every observation must go somewhere persistent, or it's just talk.
- **Quick is the default.** Deep is for when it matters. Consistency beats comprehensiveness.
