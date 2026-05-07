# claude-code-starter-kit

A working Claude Code setup, ready to install — hooks, slash commands, agents, and a CLAUDE.md framework for serious knowledge workers.

This is what a real working Claude Code setup looks like. Not "hello world." Not a demo. The actual hooks, commands, and patterns from a daily-driver setup, depersonalized so anyone can start with them.

## What's in here

```
claude-code-starter-kit/
├── .claude-plugin/plugin.json    # Plugin manifest
├── CLAUDE.md.template            # Your customization starting point
├── MEMORY.md.template            # Memory architecture scaffold
├── settings.json.template        # Sensible-default settings.json
├── hooks/
│   ├── hooks.json                # Wires the hooks into Claude Code events
│   └── scripts/                  # 16 hook scripts
├── commands/                     # 11 slash commands
├── agents/                       # 5 specialized agents
├── skills/                       # 4 generally-useful skills
├── examples/
│   ├── statusline.sh             # Custom status line with context bar
│   ├── debt-sync.sh.opt-in       # Optional Notion integration
│   └── pushover-setup.md         # Phone notification setup
└── docs/
    ├── ARCHITECTURE.md           # The philosophy
    ├── project-conventions.md    # README/PLANNING/CONTEXT-SUMMARY templates + workflow
    ├── output-styles-primer.md   # Native CC feature: output styles
    ├── plan-mode-primer.md       # Native CC feature: plan mode
    └── worktrees-primer.md       # Parallel work via worktrees
```

## Highlights

### Hooks (16 — most run silently in the background)

| Hook | What it does |
|---|---|
| `safety-net` | Blocks destructive shell commands (rm -rf on dangerous paths, force push to main, curl-piped-to-bash, etc.) |
| `self-guard` | Prevents Claude from authoring foot-gun scripts without dry-run gates |
| `backup-before-edit` | Auto-backs up files before Claude edits them |
| `retry-nudge` | Coaches Claude to retry validation errors before escalating |
| `context-monitor` | Warns when context is low + sends notifications |
| `idle-summary` | When you return after >15min, prepends "where we left off" summary |
| `persistence-rule` | Enforces the 2-action write rule (after 2 web searches, persist findings) |
| `writing-humanizer` | Auto-runs humanizer pass on long-form prose before delivery |
| `scope-creep-detector` | (opt-in) Warns when conversation drifts >10 turns from original ask |
| `permission-ding` | Distinct sound when waiting for permission (vs turn completion) |
| `pushover` | (opt-in) Phone notifications via Pushover API |
| `pre-compact` | Logs context compaction events |
| `session-end` | Logs every session for recovery |
| `user-prompt-context` | Injects active-context, debt count, project state before every prompt |
| `notify-done` | macOS notification on turn completion |
| `stop-check` | Bulletproof stop hook |

### Slash Commands (12)

| Command | What it does |
|---|---|
| `/getting-started` | Guided first-run walkthrough of the kit |
| `/session-end` | Log session, update active-context for next time |
| `/reflect [quick\|deep]` | End-of-session retrospective |
| `/debt` | Review operational debt items |
| `/recall <topic>` | Search across past sessions |
| `/maintain [full\|quick]` | Periodic system health check |
| `/note <text>` | Quick timestamped capture to today's notes |
| `/decision <title>` | Structured decision log with outcome tracking |
| `/permissions-audit` | Review and prune settings.json permissions |
| `/checkpoint <label>` | Save mid-session state snapshot |
| `/extract-skill <name>` | Scaffold a new skill from an emerging pattern |
| `/scaffold-project [name]` | Drop the recommended project files (README, PLANNING, CONTEXT-SUMMARY) into the current directory |

### Agents (5)

- `deep-research` — Multi-source research with confidence calibration
- `strategic-reviewer` — Devil's advocate for plans, proposals, decisions
- `skill-diagnostics` — Debug skill triggering issues
- `task-decomposition-expert` — Break complex goals into ordered steps
- `communication-excellence-coach` — Email refinement, difficult conversations

### Skills (4)

- `humanizer` — Remove AI tells from writing
- `learning-capture` — Pin valuable insights mid-conversation
- `idea-to-scope` — Transform vague ideas into structured scope docs
- `kaizen` — Continuous improvement framework

## Installation

See [INSTALL.md](INSTALL.md) for step-by-step instructions.

Short version:
```
# In Claude Code:
/plugin install marianasmall/claude-code-starter-kit
```

Then run `/getting-started` to walk through the setup.

## Philosophy

This is a *partnership* setup, not a *power-user* setup. The hooks aren't trying to make Claude faster — they're trying to make Claude *correct* and *safe*. The CLAUDE.md template isn't trying to be exhaustive — it's trying to give Claude enough context to be a thoughtful partner.

If you find yourself fighting the kit, change it. None of this is sacred.

Read [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) for the longer version.

## Customization

Everything here is editable:

- **Hooks too noisy?** Edit `hooks/hooks.json` and remove what you don't want.
- **Command doesn't fit?** Delete the file from `commands/` or rewrite it.
- **CLAUDE.md template wrong shape?** Strip and rebuild. Use it as a prompt, not a constraint.

## What's NOT in here

This kit deliberately doesn't include:

- **Consulting workflows** — Different professions need different patterns. Build your own.
- **Specific MCP integrations** (Notion, Slack, etc.) — Anthropic ships those as separate plugins. Install what you need.
- **Personal data or credentials** — Everything you bring is yours.
- **Opinionated project conventions** (PLANNING.md format, repo naming) — Suggested in templates but not enforced.

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
