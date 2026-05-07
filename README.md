# claude-code-starter-kit

A working Claude Code setup, ready to install — with the safety, structure, and shortcuts that make Claude Code feel less like a tool and more like a partner.

> Built and depersonalized from a daily-driver setup so anyone can start with what took months to figure out.

---

## What you'll actually feel after installing this kit

**Mid-flow capture, no surface-switching.** Type `/note kept thinking about that pricing structure` and a timestamped line lands in today's notes file. No Notion. No Apple Notes. No tab-switch.

**Welcome back, automatically.** Step away for 20 minutes. When you return and type your next message, Claude prepends a "where we left off" summary so you don't have to re-explain.

**Safety nets that hold.** Claude tries to run `rm -rf` on the wrong directory. The hook blocks it *before* the command runs. You see what was attempted and why it was stopped.

**Sessions that compound.** Type `/session-end` to wrap up. Claude writes a summary, updates a context file, and queues you up for next time. Three months later, type `/recall pricing decision` and find what you decided and why.

**Status at a glance.** A bar at the bottom of your terminal shows context window remaining, cost, time elapsed, and rate-limit usage. You always know how much room you have.

**Calm by design.** Validation errors get a "try retrying with different parameters" nudge instead of escalating to you. Long writes get a humanizer pass before delivery. Decisions can be logged with reasoning, alternatives, and predicted outcomes.

---

## Quick glossary

If you're new to Claude Code, these terms come up a lot:

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

## Philosophy

This is a *partnership* setup, not a *power-user* setup. The hooks aren't trying to make Claude faster — they're trying to make Claude **correct** and **safe**. The CLAUDE.md template isn't trying to be exhaustive — it's trying to give Claude enough context to be a thoughtful partner.

If you find yourself fighting the kit, change it. None of this is sacred.

> Read [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) for the longer version of the philosophy, including the "three-space memory" model and why hooks default to advisory rather than enforcing.

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
- **Opinionated project conventions** (PLANNING.md format, repo naming) — Suggested in templates but not enforced.

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

Built and depersonalized from a daily-driver Claude Code setup. Inspired by:

- The Anthropic team's own hook examples and plugin patterns
- The `superpowers` plugin's discipline-first approach
- Boris Cherny's self-improving Claude Code patterns
- The broader Claude Code community's hook/skill experiments

## License

MIT — do what you want with it. If you build on it, attribution is nice but not required.

## Contributing

If you build something useful on top, open a PR. The kit should evolve with the community's patterns, not stay frozen.
