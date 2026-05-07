# claude-code-starter-kit

A starter setup for Claude Code, ready to install — so you don't have to spend months figuring out what to build yourself.

> Built and depersonalized from a real working setup so anyone can start with what took months to figure out.

> 🚀 **Just want to install?** → [Skip to Installation](#installation)

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

- **Safe** — Destructive commands get blocked before they run. Files get backed up before edits. Risky scripts require explicit dry-run gates.
- **Proactive** — Claude retries validation errors before escalating to you. Warns when context is running low. Reminds you to persist findings before they evaporate.
- **Memorable** — Remembers where you left off across sessions. Tracks decisions, notes, and operational debt. Surfaces past context when you ask *"didn't we decide X already?"*
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

**Don't like something?** None of this is one-way. You can disable individual hooks, disable the whole plugin (`/plugin disable claude-code-starter-kit`), uninstall it entirely (`/plugin uninstall claude-code-starter-kit`), or restore overwritten files from the timestamped backups the kit auto-creates. Full revert paths in [INSTALL.md](INSTALL.md#dont-like-something-heres-how-to-back-out).

---

## Reading order

The repo's other files are alphabetical, which doesn't help you know where to start. Here's the recommended sequence:

1. **[INSTALL.md](INSTALL.md)** — if you're about to install. Step-by-step setup.
2. **[docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)** — the philosophy + the "three-space memory" model (why CLAUDE.md, MEMORY.md, and project files all play different roles).
3. **[docs/project-conventions.md](docs/project-conventions.md)** — the four-file project pattern (README, PLANNING, CONTEXT-SUMMARY, project-local CLAUDE.md) + naming conventions.
4. **[examples/sample-project/](examples/sample-project/)** — a worked example showing what those four files look like fully filled in for an imaginary project. Read this if conventions feel abstract.
5. **The native CC primers** (read on demand when relevant):
   - [`docs/output-styles-primer.md`](docs/output-styles-primer.md) — explanatory / concise / technical / conversational
   - [`docs/plan-mode-primer.md`](docs/plan-mode-primer.md) — when to plan vs just go
   - [`docs/worktrees-primer.md`](docs/worktrees-primer.md) — parallel work on the same repo
6. **[CLAUDE.md.template](CLAUDE.md.template)** + **[settings.json.template](settings.json.template)** — open these when customizing your own setup.

---

## Quick glossary

If you're new to Claude Code, these terms come up a lot. The kit's quick definitions below; for the full docs, see [Going deeper](#going-deeper) at the end of this file.

| Term | What it is |
|---|---|
| **Hook** | A small script that runs automatically on Claude Code events (before a tool runs, after a session ends). Background safety + automation. |
| **Slash command** | A shortcut you type at Claude Code's prompt, like `/note` or `/session-end`. Triggers pre-written instructions. |
| **Agent** | A specialist Claude can spawn for a complex task — deep research, strategic review. You don't usually invoke them directly. |
| **Skill** | A piece of reusable knowledge Claude loads on demand when relevant. Like a framework or methodology. |
| **CLAUDE.md** | A file loaded into every Claude Code session. Your personal instructions to Claude. The most important file in your setup. |

---

## What's in the kit

A curated set of:

### 4 Skills

Reusable frameworks Claude loads when relevant:

- **humanizer** — Removes AI tells from your writing
- **learning-capture** — Pin valuable insights mid-conversation
- **idea-to-scope** — Turn vague ideas into structured scope docs
- **kaizen** — Continuous improvement framework

### 12 Slash Commands

Type at Claude Code's prompt:

| Command | What it does |
|---|---|
| `/getting-started` | Guided first-run walkthrough |
| `/session-end` | Log session, update active-context for next time |
| `/reflect [quick\|deep]` | End-of-session retrospective |
| `/note <text>` | Quick timestamped capture to today's notes |
| `/decision <title>` | Structured decision log with outcome tracking |
| `/checkpoint <label>` | Save mid-session state snapshot |
| `/recall <topic>` | Search across past sessions |
| `/debt` | Review operational debt items |
| `/maintain [full\|quick]` | Periodic system health check |
| `/permissions-audit` | Review and prune settings.json permissions |
| `/extract-skill <name>` | Scaffold a new skill from a pattern |
| `/scaffold-project [name]` | Drop project files (README, PLANNING, CONTEXT-SUMMARY) into the current directory |

### 5 Agents

Specialists Claude can spawn for complex tasks:

- **deep-research** — Multi-source research with confidence calibration
- **strategic-reviewer** — Devil's advocate for plans, proposals, decisions
- **task-decomposition-expert** — Break complex goals into ordered steps
- **communication-excellence-coach** — Email refinement, difficult conversations
- **skill-diagnostics** — Debug skill triggering issues

### 16 Hooks (most run silently)

Background automation. The most-relatable:

- **safety-net** — Blocks destructive shell commands before they run
- **backup-before-edit** — Auto-backs up files before Claude edits them
- **idle-summary** — When you return after >15min, Claude knows where you left off
- **context-monitor** — Warns when context is getting low (with phone notification, optional)
- **retry-nudge** — Coaches Claude to retry validation errors before escalating

…plus 11 more covering session logging, scope-creep detection, writing-humanizer passes, project-state injection, and more. Full list in [`hooks/scripts/`](hooks/scripts/).

---

## Installation

> **The friendly version:** Open a terminal, type `claude`, then at Claude Code's prompt type:
> ```
> /plugin install marianasmall/claude-code-starter-kit
> ```
> Then run `/getting-started` for the guided walkthrough.

Full instructions, including how to customize CLAUDE.md and set up the optional integrations: **[INSTALL.md](INSTALL.md)**.

---

## Customization

Everything here is editable:

- **Hooks too noisy?** Edit `hooks/hooks.json` and remove what you don't want.
- **Command doesn't fit?** Delete the file from `commands/` or rewrite it.
- **CLAUDE.md template wrong shape?** Strip and rebuild. Use it as a prompt, not a constraint.

The kit is a starting point, not a religion. After a week of use, you'll know what to tune.

---

## What's NOT in here

This kit deliberately doesn't include:

- **Consulting workflows** — Different professions need different patterns. Build your own.
- **Specific MCP integrations** (Notion, Slack, etc.) — Anthropic ships those as separate plugins. Install what you need.
- **Personal data or credentials** — Everything you bring is yours.
- **Enforced project conventions** — The kit *suggests* conventions for project file structure (README/PLANNING/CONTEXT-SUMMARY) and naming (see [`docs/project-conventions.md`](docs/project-conventions.md)) and ships templates for them, but nothing is enforced. Use what fits, ignore what doesn't.

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
- [Output styles](https://code.claude.com/docs/en/output-styles) — explanatory, concise, technical, conversational
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
│   └── scripts/                  # 16 hook scripts
├── commands/                     # 12 slash commands
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
