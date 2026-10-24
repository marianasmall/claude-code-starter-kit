# Changelog

## Unreleased

- **New skill: `image-humanizer`.** The image counterpart to `humanizer`. Audits an AI image against a 20-point checklist (product structure, light and physics, scene, surface), rates each tell blocker / noticeable / polish, and routes it to the right fix: regenerate, retouch (step-by-step for Photoshop, Firefly, Canva, Lightroom), or finish. `scripts/finish.py` is a deterministic finishing pass (grain, highlight roll-off, saturation control, vignette, lens softness) with `product` and `lifestyle` presets. It writes a new file, keeps EXIF, and tags the output with IPTC `DigitalSourceType` so AI disclosure isn't lost. Two hard rules: the product must stay true to the real piece, and the skill won't strip AI-disclosure metadata. Ships with evals.
- **New guide: [Never lose a project](docs/never-lose-a-project.md).** Replaces the older five-file project layout with the current standard: README, `AGENTS.md` plus a one-line `CLAUDE.md` that loads it, `PLANNING.md`, a numbered `decisions.md` that records the options you rejected, a newest-first `handoff.md`, and a gitignored `_private/` folder. Also covers the session-continuity loop (session summary, handoff, decisions check, commit, calendar sweep, then compact with a focus line), plan-then-subagents for big builds, and repo and file naming. Fictional worked examples and blank templates included. A companion template repo has the same package ready for GitHub's **Use this template**. `docs/project-conventions.md` is now a short pointer to the new guide.
- **`/kit:session-end` and `/kit:handoff`:** the handoff is now a new block added to the top of `handoff.md` (newest first, last few kept) instead of replacing the file, so a session that ends badly no longer wipes the trail. Old-format files convert automatically. The session summary gains **Open Loops** and **Where State Lives** fields. `/kit:session-end` adds a decisions check and a calendar sweep (only when a calendar tool is connected), and both commands offer a paste-ready `/compact` line once state is saved.
- **`/kit:scaffold-project`** now drops the new package and adds `_private/`, secrets files, and `_backups/` to `.gitignore`. It no longer creates `CONTEXT-SUMMARY.md`. The prompt-context hook still reads one if you have it, so existing projects keep working.
- **New skill: `meeting-recap`.** Any transcript (Fireflies, Granola, Plaud, Wispr Flow, Otter, or pasted) becomes an eight-section recap (TL;DR, decisions, action items with owners, open questions, risks, quotes, follow-up triggers, source) delivered as a draft in your email tool or a page in your notes, never sent. Ships with evals.

## 0.2.4 — 2026-10-10

**Safer settings template, and out-of-date advice fixed.** Every change was checked against the official Claude Code docs, release notes or `claude --help`.

- **The settings template no longer lets risky commands skip auto mode's safety check.** Since Claude Code 2.1.284, sessions start in auto mode, and anything on your `allow` list runs with no review. The old template allowed every `rm`, `mv`, `chmod`, `git`, `gh` and `brew` command. Those are gone; the list now holds commands that only look at things (`ls`, `cat`, `git status`, `git diff`, `gh pr view` and similar) plus `mkdir` and `touch`. In auto mode this doesn't add prompts: the safety check reviews the dropped commands instead of you.
- **New `ask` list** in the template for things you can't undo: `rm -rf`, `git push --force`/`-f`, `git reset --hard`, and deleting or editing a GitHub repo or release. Ask rules win over allow rules and still ask you in auto mode.
- Also out of the template: the `python3`/`node`/`npm`/`npx`/`pip3` rules (auto mode drops them anyway), the `Edit`/`Write` rules for `~/.claude` (that folder is always protected, and `Write` path rules are never checked), `ENABLE_PROMPT_CACHING_1H` (subscribers already get it; API users pay more, so it's now an explained opt-in), `CLAUDE_CODE_FORK_SUBAGENT` (on by default now), the `"// ==="` strings inside the allow list, and the `_comment` inside `enabledPlugins`. `WebFetch` now allows `code.claude.com` and `platform.claude.com` instead of the old `docs.anthropic.com`. INSTALL.md explains each change in plain language.
- **Updating the kit:** the docs now give the documented commands. In a terminal, `claude plugin update kit@claude-code-starter-kit`, then restart Claude Code, then `/kit:verify`. Or `/plugin` → **Installed** → kit → **Update now**. (`/plugin update kit` isn't a documented command.)
- **Windows:** the plugins primer said settings live only inside WSL. Claude Code runs natively on Windows too, where the file is `%USERPROFILE%\.claude\settings.json`.
- **Status line:** `examples/statusline.sh` read a rate-limit field that doesn't exist (`percentage_used`), so the 5-hour usage segment never showed. It now reads `used_percentage`.
- README: auto mode became the default in **2.1.284** (0.2.3 said 2.1.285); the fail-closed safety hooks need Claude Code **2.1.295** or later; the Shift+Tab order includes auto mode; `knowledge-work-plugins` must be added as a marketplace before installing from it; `/recap` gives a one-line summary; `/color` and `/effort` have no version or plan limits worth noting; plan requirements include Team, Enterprise and Console; the Concise output style is listed; the plan-mode link points to the permission modes page; `/reload-plugins` is no longer a required install step.
- Primers: `/output-style` is back (since 2.1.269) and style changes apply from your next message; the Concise style is added; Proactive no longer promises permission prompts; plan mode can run exploring commands and ends with an approval menu; claude.ai paths are now **Customize → Connectors** and **Settings → Instructions for Claude**; `pdf-viewer` installs from `knowledge-work-plugins`.
- Smaller fixes: the getting-started step explains that `~/.claude/MEMORY.md` isn't auto-loaded; the memory template's limit is 25KB; `/doctor prompt-audit` needs 2.1.283; the deep-research agent uses the `Agent` tool name; hooks.json says six nudges; ARCHITECTURE.md shows the current version and `/kit:` command names.

**If you copied `settings.json.template` before 0.2.4,** your `~/.claude/settings.json` still has the old allow list. See [INSTALL.md, "Copy the settings.json template"](INSTALL.md#copy-the-settingsjson-template-optional) for what to remove and a prompt that has Claude walk you through it. To get the rest of 0.2.4, update the kit as above.

## 0.2.3 — 2026-10-10

- **The safety hooks now fail closed.** `safety-net` and `self-guard` carry `"onFailure": "block"`. If either can't start, times out or crashes, Claude Code blocks the action instead of letting it through. Needs Claude Code 2.1.295 or later. On older versions the setting has no effect and the hooks behave as before.
- **Auto mode explained.** Since Claude Code 2.1.285, auto mode is the default permission mode. The README's Plan mode tip now says what that means, how to switch modes, and that the kit's safety hooks still run underneath.
- **`/kit:maintain` gets a monthly instruction tune-up** (new step 2f): it asks you to run Claude Code's built-in `/doctor prompt-audit`, then sorts the findings into quick fixes and judgment calls.
- New [`docs/choosing-plugins-and-connectors-primer.md`](docs/choosing-plugins-and-connectors-primer.md): pick plugins by goal, red flags to check before installing, turning off claude.ai plugin sync (`syncClaudeAiPlugins`), connector and settings hygiene, and a starter set. Linked from the README's plugin section, which now notes that the productivity plugin creates its own task files.

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
