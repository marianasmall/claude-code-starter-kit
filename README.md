# claude-code-starter-kit

A starter setup for Claude Code, ready to install — so you don't have to spend months figuring out what to build yourself.

> Built and depersonalized from a real working setup so anyone can start with what took months to figure out.

> 🚀 **Just want to install?** → [Skip to Installation](#installation)
>
> 🍳 **Don't code? Start with the [Automation Recipes](docs/automation-recipes/README.md)** — seventeen follow-along guides (morning brief, subscription audit, paperwork decoder…) that work with plain Claude Code, no installation required.

---

## Philosophy

This is a *partnership* setup, not a *power-user* setup. The hooks aren't trying to make Claude faster — they're trying to make Claude **correct** and **safe**. The CLAUDE.md template isn't trying to be exhaustive — it's trying to give Claude enough context to be a thoughtful partner.

If you find yourself fighting the kit, change it. None of this is sacred.

---

## What this is

This plugin structures Claude Code so you start with:

- **A memory system** that survives across sessions
- **Visual polish** — a context bar at the bottom of your terminal, structured insights when Claude is teaching, distinct sounds for "done" vs "waiting"
- **Safety hooks** that block destructive commands before they run
- **A library of slash commands** for common rituals (logging sessions, capturing notes, reviewing decisions)
- **Specialists Claude can call on** for complex work (deep research, devil's-advocate review)
- **A CLAUDE.md framework** that teaches Claude how *you* work

All curated, depersonalized from a real working setup, installable in under five minutes.

---

## What you get

Installing this gets you a Claude Code that's:

- **Safe** — Destructive commands get blocked before they run. Files get backed up before edits. Risky scripts require explicit dry-run gates. Critical claims get verified against primary sources before propagating across files.
- **Proactive** — Claude retries validation errors before escalating to you. Warns when context is running low. Reminds you to persist findings before they evaporate.
- **Memorable** — Remembers where you left off across sessions. Tracks decisions, notes, and operational debt. Surfaces past context when you ask *"didn't we decide X already?"*
- **Continuable** — When a thread fills up, `/kit:session-end` auto-generates a `handoff.md` in your project folder. Copy it into a new thread to pick up exactly where you left off — no re-explaining required. (See [project conventions](docs/project-conventions.md#the-handoff-ritual-how-to-continue-work-in-a-new-thread) for the full ritual.)
- **Polished** — Custom statusline at the bottom of your terminal showing context, cost, and time. `★ Insight ─` boxes when Claude is teaching. Notifications when you've stepped away.
- **Invested in your success** — A CLAUDE.md framework captures who you are and how you work. After 15 minutes of customization, Claude works *with* your specific shape — not against it.

> The metaphor: Claude Code out of the box is a brilliant intern on day one — capable, but unfamiliar with how you work. This kit is the intern with three months of context already loaded.

---

## How this is different from Claude Code out of the box

Out of the box, Claude Code is powerful but generic. To get this same setup yourself, you'd need to:

- Learn Anthropic's hook system, plugin structure, slash command syntax, and output styles
- Find and adopt skills scattered across various repos
- Build hook scripts for safety, backups, context monitoring, retry coaching
- Write a CLAUDE.md that actually captures how you work (this is the step most people underestimate — strong CLAUDE.md files are rare in the wild)
- Figure out project-level conventions (PLANNING.md, CONTEXT-SUMMARY.md) that let Claude resume cold

That's months of "I wish I'd done this earlier" learning, scattered across blog posts and trial-and-error.

This plugin shortcuts that. Install it, customize one file, you're set up.

---

## Already using Claude Code? Or starting fresh?

**If you've been using Claude Code for a while** and want to refine your setup, this won't override what you have. The hooks, commands, agents, and skills all install alongside your existing setup — they live in their own plugin namespace.

The only two files to think about are `CLAUDE.md` and `settings.json` (your personal config files in `~/.claude/`). If you already have them, **add a `.backup` suffix to the filename first** — so `~/.claude/CLAUDE.md` becomes `~/.claude/CLAUDE.md.backup`, and `~/.claude/settings.json` becomes `~/.claude/settings.json.backup`. Or during install, tell Claude: *"I already have these — show me the templates so I can decide what to merge."*

**If you're starting fresh,** you'll be ahead of the game. The kit is months of "I wish I'd done this earlier" learning packaged for one install + 15 minutes of customization.

**Don't like something?** None of this is one-way. You can disable individual hooks, disable the whole plugin (`/plugin disable kit`), uninstall it entirely (`/plugin uninstall kit`), or restore overwritten files from the timestamped backups the kit auto-creates. Full revert paths in [INSTALL.md](INSTALL.md#dont-like-something-heres-how-to-back-out).

---

## Reading order

The repo's other files are alphabetical, which doesn't help you know where to start. Here's the recommended sequence:

1. **[INSTALL.md](INSTALL.md)** — if you're about to install. Step-by-step setup.
2. **[docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)** — the philosophy + the "three-space memory" model (why CLAUDE.md, MEMORY.md, and project files all play different roles).
3. **[docs/project-conventions.md](docs/project-conventions.md)** — the five-file project pattern (README, PLANNING, CONTEXT-SUMMARY, project-local CLAUDE.md, handoff.md) + naming conventions.
4. **[examples/sample-project/](examples/sample-project/)** — a worked example showing four of those files fully filled in for an imaginary project (handoff.md is generated at runtime). Read this if conventions feel abstract.
5. **The native CC primers** (read on demand when relevant):
   - [`docs/output-styles-primer.md`](docs/output-styles-primer.md) — Default / Proactive / Explanatory / Learning
   - [`docs/plan-mode-primer.md`](docs/plan-mode-primer.md) — when to plan vs just go
   - [`docs/worktrees-primer.md`](docs/worktrees-primer.md) — parallel work on the same repo
   - [`docs/multi-session-coordination-primer.md`](docs/multi-session-coordination-primer.md) — running several sessions as colleagues: shared surfaces, handoffs, wrap rituals
   - [`docs/1password-environments-primer.md`](docs/1password-environments-primer.md) — get your API keys out of plaintext files (if you use 1Password)
   - [`docs/scoped-imessage-access-primer.md`](docs/scoped-imessage-access-primer.md) — give Claude your work texts (and nothing else) via a Contacts group
6. **[docs/automation-recipes/](docs/automation-recipes/README.md)** — ten follow-along recipes for everyday automations (morning brief, budget planner, meeting prep, news digest…). Where the primers explain features, these assemble them into daily habits. A good first stop if you'd rather build something useful than read about architecture.
7. **[CLAUDE.md.template](CLAUDE.md.template)** + **[settings.json.template](settings.json.template)** — open these when customizing your own setup.

---

## Quick glossary

If you're new to Claude Code, these terms come up a lot. The kit's quick definitions below; for the full docs, see [Going deeper](#going-deeper) at the end of this file.

| Term | What it is |
|---|---|
| **Hook** | A small script that runs automatically on Claude Code events (before a tool runs, after a session ends). Background safety + automation. |
| **Slash command** | A shortcut you type at Claude Code's prompt, like `/kit:note` or `/kit:session-end`. Triggers pre-written instructions. |
| **Agent** | A specialist Claude can spawn for a complex task — deep research, strategic review. You don't usually invoke them directly. |
| **Skill** | A piece of reusable knowledge Claude loads on demand when relevant. Like a framework or methodology. |
| **CLAUDE.md** | A file loaded into every Claude Code session. Your personal instructions to Claude. The most important file in your setup. |

---

## What's in the kit

A curated set of:

### 5 Skills

Reusable frameworks Claude loads when relevant:

- **humanizer** — Removes AI tells from your writing
- **learning-capture** — Pin valuable insights mid-conversation
- **idea-to-scope** — Turn vague ideas into structured scope docs
- **kaizen** — Continuous improvement framework
- **bring-up-to-speed** — Brief anyone on a project whose history is scattered across email, meetings, and docs: source-weighted claims, honest blind spots, bottom line up front

### 15 Slash Commands

Type at Claude Code's prompt. (Installed plugin commands are namespaced under the plugin name, so they all start with `/kit:`.)

| Command | What it does |
|---|---|
| `/kit:getting-started` | Guided first-run walkthrough |
| `/kit:verify` | Fire drill — proves every hook is alive and the safety hooks actually block |
| `/kit:session-end` | Log session, update active-context for next time |
| `/kit:reflect [quick\|deep]` | End-of-session retrospective |
| `/kit:note <text>` | Quick timestamped capture to today's notes |
| `/kit:decision <title>` | Structured decision log with outcome tracking |
| `/kit:checkpoint <label>` | Save mid-session state snapshot |
| `/kit:recall <topic>` | Search across past sessions |
| `/kit:debt` | Review operational debt items |
| `/kit:maintain [full\|quick]` | Periodic system health check |
| `/kit:permissions-audit` | Review and prune settings.json permissions |
| `/kit:extract-skill <name>` | Scaffold a new skill from a pattern |
| `/kit:scaffold-project [name]` | Drop project files (README, PLANNING, CONTEXT-SUMMARY) into the current directory |
| `/kit:consistency-check [path]` | Pre-ship audit for doc bundles — catches count drift, broken anchors, ambiguous pronouns, audience assumptions, jargon |
| `/kit:handoff` | Refresh `<project>/handoff.md` without the full session-end ritual (mid-session context switch) |

### 5 Agents

Specialists Claude can spawn for complex tasks:

- **deep-research** — Multi-source research with confidence calibration
- **strategic-reviewer** — Devil's advocate for plans, proposals, decisions
- **task-decomposition-expert** — Break complex goals into ordered steps
- **communication-excellence-coach** — Email refinement, difficult conversations
- **skill-diagnostics** — Debug skill triggering issues

### 16 hook scripts — 15 wired events + 1 shared helper (most run silently)

Background automation. The most-relatable:

- **safety-net** — Blocks destructive shell commands before they run
- **backup-before-edit** — Auto-backs up files before Claude edits them
- **idle-summary** — When you return after >15min, Claude knows where you left off
- **context-monitor** — Warns when context is getting low (with phone notification, optional)
- **retry-nudge** — Coaches Claude to retry validation errors before escalating

…plus 10 more wired events covering session logging, scope-creep detection, writing-humanizer passes, project-state injection, and more — 15 wired hooks total, plus a shared notification helper (`pushover.sh`). Full list in [`hooks/scripts/`](hooks/scripts/).

---

## What's NOT in here — and what the kit touches

This kit deliberately doesn't include:

- **Specific MCP integrations** (Notion, Slack, etc.) — Anthropic ships those as separate plugins. Install what you need.
- **Enforced project conventions** — The kit *suggests* conventions for project file structure (README/PLANNING/CONTEXT-SUMMARY) and naming (see [`docs/project-conventions.md`](docs/project-conventions.md)) and ships templates for them, but nothing is enforced. Use what fits, ignore what doesn't.

**And so you know exactly what you're installing:** the hooks run locally on every prompt and tool call. They write only to your Claude home folder (`~/.claude/notes/`, `debt.md`, `decision-log.md`) and to timestamped `_backups/` folders next to files Claude edits. Nothing phones home — the only network call anywhere in the kit is the optional Pushover phone notification, and only if you add your own credentials. Everything you bring is yours.

---

## Installation

**Prerequisites:** Claude Code on a Pro/Max plan or API billing, plus `jq` and Python 3 on your `$PATH` (`jq --version` / `python3 --version` to check — most systems have both).

> **The friendly version:** Open a terminal, type `claude`, then at Claude Code's prompt run these two commands:
> ```
> /plugin marketplace add https://github.com/marianasmall/claude-code-starter-kit
> /plugin install kit@claude-code-starter-kit
> ```
> Then `/reload-plugins` to activate, and `/kit:getting-started` for the guided walkthrough.
>
> **Heads-up on command names:** the kit's own commands are namespaced under the plugin name, so you type `/kit:getting-started`, `/kit:session-end`, `/kit:note`, etc. — not the bare names. (That's standard for any installed plugin; the `/kit:` prefix is just this plugin's namespace.)
>
> **Why two commands?** The first registers this repo as a *marketplace* on your machine (one-time trust step). The second installs the plugin from it (`kit` is the plugin name; `claude-code-starter-kit` is the marketplace name). Using the HTTPS URL avoids SSH host-key prompts that some setups hit on a first clone of GitHub.

Full instructions, including how to customize CLAUDE.md and set up the optional integrations: **[INSTALL.md](INSTALL.md)**.

---

## Customization

Everything here is editable:

- **Hooks too noisy?** Edit `hooks/hooks.json` and remove what you don't want.
- **Command doesn't fit?** Delete the file from `commands/` or rewrite it.
- **CLAUDE.md template wrong shape?** Strip and rebuild. Use it as a prompt, not a constraint.

The kit is a starting point, not a religion. After a week of use, you'll know what to tune.

---

## Pro tips (native Claude Code features worth knowing)

These aren't part of the kit — they ship with Claude Code itself — but they're easy to miss and they change how the tool feels day-to-day.

**1. Name your sessions.** Claude Code auto-names each session based on your first prompt, but you can override it. Launch with `claude -n "session-name"`, or use `/branch <name>` and `/rename <name>` mid-session. Names show in the terminal tab, the prompt box, and the `/resume` picker — useful when you have multiple sessions running at once.

**2. Plan mode (Shift+Tab cycles modes).** Hit `Shift+Tab` to cycle between auto-accept, plan-first, and manual-confirm modes. Plan mode forces Claude to outline its approach before touching anything — invaluable for risky changes (refactors, deletions, multi-file edits) where you want to review the plan before approving execution.

**3. `@<filename>` to reference files.** Inside a prompt, type `@` and start typing a filename — Claude Code autocompletes from your project. Beats copy-pasting code into the prompt, and Claude reads the file directly so you don't burn context on quoted blocks.

**4. `Esc` to interrupt.** When Claude is heading down the wrong path, hit `Esc` to interrupt the current tool call. You can then redirect with a corrective prompt instead of waiting for a multi-step task to finish before pivoting.

**5. `/recap` to re-orient.** Returning to a session you started yesterday? `/recap` summarizes what's happened so far, what was decided, and where you left off. Cheaper than re-reading the whole transcript.

Other power features worth exploring once these feel natural: `/color blue` (persistent prompt-bar accent per session — pairs with named tabs for telling parallel sessions apart; needs v2.1.205+), `/usage` (context, cost, rate limits at a glance), `/effort` (raise reasoning depth for hard tasks — Pro/Max only), `Ctrl+R` (search past prompts across sessions), `--worktree` (parallel work on the same repo with no merge headaches).

---

## Recommended plugins to add

The kit is intentionally lean. Once you have it installed, here's what most users grab next, organized by what they do.

**Foundational** (most people benefit):
- `superpowers@claude-plugins-official` — brainstorming, systematic debugging, plan-writing skills. This kit's discipline-first philosophy is influenced by it; install for the full skill set.
- `context7@claude-plugins-official` — fetches current library/framework docs on demand.
- `github@claude-plugins-official` — manage repos, PRs, issues conversationally. **Setup note:** needs `GITHUB_PERSONAL_ACCESS_TOKEN` in your `~/.claude/settings.json` env block. The `gh` CLI's token works — run `gh auth token` to get the value.

**Knowledge workers** (pick by role):
- `productivity@knowledge-work-plugins` — Notion / Asana / Linear / Monday / ClickUp connectors for tasks, calendars, personal context.
- `data@knowledge-work-plugins` — SQL queries, dashboards, statistical analysis.
- `marketing@knowledge-work-plugins` — Figma / Notion / Ahrefs / SimilarWeb integrations for marketers.
- `cowork-plugin-management@knowledge-work-plugins` — for customizing or building your own plugins (like this one).

**Skill bundle:** (add the marketplace once — `claude plugin marketplace add anthropics/skills` — then install either plugin)
- `example-skills@anthropic-agent-skills` — Anthropic's example skills: `theme-factory` (design themes), `brand-guidelines`, `algorithmic-art`, `canvas-design`, and more.
- `document-skills@anthropic-agent-skills` — document creation/editing skills: `docx`, `pdf`, `pptx`, `xlsx`.

**Communication channels** (pick whichever you prefer for chatting with Claude outside the terminal):
- `slack@claude-plugins-official`, `telegram@claude-plugins-official`, or `imessage@claude-plugins-official`.

**Specialists** (install only if relevant to your work):
- `figma@claude-plugins-official` — design work
- `playwright@claude-plugins-official` — browser automation and web testing
- `hookify@claude-plugins-official` — building custom hooks
- `Notion@notion-plugin-marketplace` — deeper Notion integration than the productivity plugin alone

**Honest caveats — skip these unless your stack matches:**
- `enterprise-search@knowledge-work-plugins` — designed for Microsoft 365. Skip on Google Workspace; the Gmail / Calendar connector slots ship empty.
- `legal@knowledge-work-plugins` and `finance@knowledge-work-plugins` — same MS365 dependency.

**Install commands:**
```bash
# From your terminal
claude plugin install <name>@<marketplace>

# Or from inside Claude Code
/plugin install <name>@<marketplace>

# Browse what's available
claude plugin marketplace list
```

---

## Going deeper

Want to understand how Claude Code actually works under the hood? The official docs are well-written and worth a read:

**Claude Code documentation:**
- [Overview](https://code.claude.com/docs/en/overview) — start here
- [Hooks guide](https://code.claude.com/docs/en/hooks-guide) — what they are, how to write them
- [Slash commands](https://code.claude.com/docs/en/commands) — full reference
- [Skills](https://code.claude.com/docs/en/skills) — auto-activating knowledge
- [Sub-agents](https://code.claude.com/docs/en/sub-agents) — specialists Claude can spawn
- [Plugins](https://code.claude.com/docs/en/plugins) — how this kit packages itself
- [Memory & CLAUDE.md](https://code.claude.com/docs/en/memory) — the file at the heart of customization
- [Output styles](https://code.claude.com/docs/en/output-styles) — Default, Proactive, Explanatory, Learning + custom styles
- [Plan mode](https://code.claude.com/docs/en/interactive-mode) — when to plan before executing
- [MCP servers](https://code.claude.com/docs/en/mcp) — connecting external tools

**Broader Claude ecosystem:**
- [Anthropic platform docs](https://platform.claude.com/docs/en/home) — for the underlying Claude API and general capabilities

**Local primers in this kit:**
- [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) — the philosophy + three-space memory model
- [`docs/project-conventions.md`](docs/project-conventions.md) — README/PLANNING/CONTEXT-SUMMARY pattern
- [`docs/output-styles-primer.md`](docs/output-styles-primer.md) — when to use each style
- [`docs/plan-mode-primer.md`](docs/plan-mode-primer.md) — when to plan vs just go
- [`docs/worktrees-primer.md`](docs/worktrees-primer.md) — parallel work on the same repo

---

## Repository structure

For reference (most users won't need to navigate this directly):

```
claude-code-starter-kit/
├── .claude-plugin/plugin.json    # Plugin manifest
├── CLAUDE.md.template            # Your customization starting point
├── MEMORY.md.template            # Memory architecture scaffold
├── settings.json.template        # Sensible-default settings.json
├── hooks/
│   ├── hooks.json                # Wires hooks into Claude Code events
│   └── scripts/                  # 16 hook scripts (15 wired + pushover.sh helper)
├── commands/                     # 15 slash commands
├── scripts/
│   └── verify-hooks.sh           # Hook fire drill (run via /kit:verify)
├── agents/                       # 5 specialized agents
├── skills/                       # 4 generally-useful skills
├── examples/
│   ├── statusline.sh             # Custom status line with context bar
│   ├── debt-sync.sh.opt-in       # Optional Notion integration
│   ├── pushover-setup.md         # Phone notification setup
│   └── sample-project/           # Worked example: filled-in project files
└── docs/
    ├── ARCHITECTURE.md           # The philosophy
    ├── project-conventions.md    # README/PLANNING/CONTEXT-SUMMARY templates + workflow
    ├── output-styles-primer.md   # Native CC feature: output styles
    ├── plan-mode-primer.md       # Native CC feature: plan mode
    ├── multi-session-coordination-primer.md  # Running parallel sessions as colleagues
    ├── 1password-environments-primer.md      # Secrets out of plaintext files
    └── worktrees-primer.md       # Parallel work via worktrees
```

---

## Credits

Built by **[Mariana Small](https://github.com/marianasmall)** — the original setup, the depersonalization, the voice, and the structural decisions are hers. This kit is what her daily-driver Claude Code looks like, made shareable.

Inspired by:

- The Anthropic team's own hook examples and plugin patterns
- The `superpowers` plugin's discipline-first approach
- Boris Cherny's self-improving Claude Code patterns
- The broader Claude Code community's hook/skill experiments

Co-built with Claude (Opus 4.7) over the course of one long, productive evening.

## License

MIT — do what you want with it. If you build on it, attribution is nice but not required.

## Contributing

If you build something useful on top, open a PR. The kit should evolve with the community's patterns, not stay frozen.
