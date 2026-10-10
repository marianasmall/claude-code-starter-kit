# Changelog

## 0.2.2 — 2026-10-10

**Automatic checks, so a broken kit can't ship again.** Both 0.2.0 bugs passed every check we had, because we only ever tested from the repo folder. Now:

- `.github/workflows/check.yml` runs on every PR, every push to main, and every Monday, on Linux and macOS with the latest Claude Code. It runs Claude Code's strict plugin checker, the hook fire drill, and the new install test. The weekly run catches a Claude Code update tightening the rules even when nothing in the kit changed.
- New `scripts/install-test.sh` installs the kit into a throwaway Claude config the way a user does. It then runs `/kit:verify`'s own lookup, read straight from `commands/verify.md`, and the fire drill from the installed copy. Run against 0.2.0, it fails at the lookup, and the plugin checker rejects that version's `hooks.json`.
- New `RELEASING.md`: what runs automatically, plus the by-hand steps (version bump, doc counts, a Windows/WSL install).

- **`/kit:maintain` now validates every installed plugin** with `claude plugin validate --strict` and runs the `/kit:verify` drill. A plugin whose hooks can't load still shows as enabled with no error in `/plugin`, so this is the only way your regular sweep would notice. The summary gets a Plugins row.

To get the `/kit:maintain` change, run `/plugin update kit`. Nothing else to do.

## 0.2.1 — 2026-10-09

**Hooks fix (please read if you installed earlier).** `hooks/hooks.json` listed its hook events at the top level of the file. Claude Code's plugin format expects them inside a `"hooks"` object, so **earlier installs may not have loaded the kit's hooks at all, including the safety and backup hooks. Reinstall to get them:** `/plugin update kit` (or `/plugin uninstall kit`, then install again), then run `/kit:verify` to confirm they fire.

- `hooks/hooks.json` now uses the documented shape, has a description, and quotes every plugin path so install folders with spaces work. `claude plugin validate` passes with no warnings.
- **`/kit:verify` can find the kit again.** When `$CLAUDE_PLUGIN_ROOT` wasn't set, it searched for a folder named `claude-code-starter-kit*`, but plugins install to `~/.claude/plugins/cache/<marketplace>/kit/<version>/`, so the search came back empty. It now looks for the drill script under that real layout. `INSTALL.md`'s example path is corrected to match. Both this and the hooks.json bug were reported from a fresh install on Windows (WSL).
- **The fire drill now checks hooks.json's shape**, not just that it parses. The 0.2.0 file parsed fine and named every script, so the drill passed while Claude Code refused to load it. A misplaced event now fails the drill.
- **Hardened hook scripts against prompt-text injection.** Several hooks built small Python programs by pasting text straight into the program: prompts, file names, tool names, and the contents of state files. Text containing quote marks could break out and run as code. Text now reaches Python only through environment variables, with the Python source in single quotes or a quoted heredoc so the shell never expands it. Numbers read from state files are checked to be digits before shell arithmetic, which can also run code. Changed: `self-guard`, `retry-nudge`, `persistence-rule`, `writing-humanizer`, `idle-summary`, `context-monitor`, `session-end`, `pushover.sh`, and the optional `scope-creep-detector`. A regression test with break-out payloads confirmed the old versions of `self-guard`, `retry-nudge`, `persistence-rule` and `scope-creep-detector` could be made to run injected code; the new versions don't.
- Two hooks that did nothing by default came out of the wiring: `stop-check` (returned "ok" and nothing else) and `scope-creep-detector` (off unless `SCOPE_CREEP_ENABLED=1`). Their scripts are in `hooks/_optional/` with instructions for wiring them back in. **13 hooks are wired:** 4 safeguards, 3 notifications, 6 nudges.
- The CLAUDE.md template gets back the finer search-and-verification habits (follow loose ends, the filename-rename exceptions, stop long searches, cold-read docs before they go out). It's now 53 lines.
- Docs pass: every count and file list in README, INSTALL, getting-started, ARCHITECTURE and the primers now matches the repo (13 hooks, 15 commands, 6 agents, 5 skills, 17 recipes). The calendar-handoff primer is now linked from the README. The layering primer's `/goal` section was checked against the official command reference (it is a built-in) and now links the docs and explains how it differs from `/loop`.

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
