# Changelog

## 0.2.0 — 2026-10-09

Practices informed by the Anthropic × Tenex Claude Code workshop (Oct 2026).

**CLAUDE.md**
- The user-level template went from 219 lines to 47. It now covers only how you work: who you are, tone, modes, partnership, search-before-asking, verification, session hygiene, and the constitution. Nothing was dropped. Every section it used to carry is in [`docs/claude-md-section-library.md`](docs/claude-md-section-library.md), with a note on which layer it belongs in.
- New `# Compact instructions` section in the template: keep the active task, open loops, decisions, and exact IDs and paths; drop tool output that's already saved.
- New [`examples/layered-repo/`](examples/layered-repo/): a root CLAUDE.md that answers what this is, where things live and how work ships; an app-folder note; a path-scoped `.claude/rules/` file; and a personal `CLAUDE.local.md` kept out of git.

**Context**
- New [`docs/context-budget-primer.md`](docs/context-budget-primer.md): what loads when and what it costs, `/context` at startup and after adding an MCP server, compacting at about half the window, one task per session.
- `/kit:maintain` adds a monthly `/context` readout (you run the command, Claude logs the totals to `~/.claude/context-log.md` and flags growth) and a `/context` check after any new MCP server.

**Hooks**
- Documented the rule for when a hook is the right tool: only when skipping is never OK, and most setups need three or four. The primer sorts the kit's 15 hooks into safeguards, notifications and nudges. No hooks were removed or changed.

**Skills**
- `kaizen` (726 → 120 lines) and `humanizer` (459 → 130 lines) moved their examples and pattern write-ups into `references/`, unchanged. The SKILL.md files keep the steps and rules.
- Every kit skill now ships `evals/evals.json` with trigger and near-miss test prompts.
- `/kit:extract-skill` explains the three loading levels, adds the "explained it twice" test, and scaffolds evals.

**Agents**
- New read-only `investigator` agent (`tools: Read, Grep, Glob`). It diagnoses with file-and-line evidence and never fixes.

## 0.1.0

Initial release: hooks, slash commands, agents, skills, CLAUDE.md and settings templates, primers, automation recipes.
