# Installation Guide

Step-by-step setup for `claude-code-starter-kit`. Plain language. Light-technical friendly.

## Prerequisites

You need:
- **Claude Code** installed and working (`claude --version` should print something)
- A **macOS, Linux, or WSL** environment (Windows native is partially supported but the macOS notification hooks won't fire)
- **`jq`** and **Python 3** in your `$PATH` (most systems have these — `jq --version` and `python3 --version` to check)

Optional (only if you want their features):
- **Pushover** account (for phone notifications)
- **Notion** workspace + API key (for `/debt` and session sync)
- **`gitleaks`** (for the secrets scan in `/maintain`)

## Step 1: Install the plugin

In Claude Code:

```
/plugin install marianasmall/claude-code-starter-kit
```

Or, if installing from a local clone:

```
/plugin install /path/to/claude-code-starter-kit
```

This wires the hooks, commands, agents, and skills into Claude Code. They become available immediately.

## Step 2: Customize CLAUDE.md

The plugin ships a template. Copy it to your real CLAUDE.md location:

```
cp $CLAUDE_PLUGIN_ROOT/CLAUDE.md.template ~/.claude/CLAUDE.md
```

(In Claude Code, `$CLAUDE_PLUGIN_ROOT` resolves to the installed plugin's path.)

Open `~/.claude/CLAUDE.md` and replace the `[YOUR_NAME]`, `[YOUR_ROLE]`, `[YOUR_PROJECTS]` placeholders. **Spend 15-30 minutes on this.** It's the highest-leverage time you'll spend on your setup.

You don't need to fill every section. Strip what doesn't apply.

## Step 3: Set up settings.json (optional but recommended)

If you don't already have `~/.claude/settings.json`, copy the template:

```
cp $CLAUDE_PLUGIN_ROOT/settings.json.template ~/.claude/settings.json
```

If you already have one, **don't overwrite it** — instead, look at the template and merge useful sections:
- `enabledPlugins` — make sure `claude-code-starter-kit@local` and `explanatory-output-style` are enabled
- `spinnerVerbs` — totally optional but adds personality
- Permissions you might want to add to your existing allowlist

Replace `[CUSTOMIZE]` placeholders (mostly your username in path patterns).

## Step 4: Install the statusline (optional, recommended)

The statusline shows context window remaining, cost, duration, and rate limits at the bottom of your terminal. The `context-monitor` hook reads from a file the statusline writes — without the statusline, that hook degrades to a no-op.

```
cp $CLAUDE_PLUGIN_ROOT/examples/statusline.sh ~/.claude/statusline.sh
chmod +x ~/.claude/statusline.sh
```

Then add to `~/.claude/settings.json` (top level — outside any other block):

```json
"statusLine": {
  "type": "command",
  "command": "~/.claude/statusline.sh",
  "refreshInterval": 30
}
```

Restart Claude Code and you'll see the bar at the bottom of your terminal.

## Step 5: Walk through `/getting-started`

In Claude Code, run:

```
/getting-started
```

This walks you through the architecture, what each hook does, and the customization options.

## Step 6: Verify everything's working

```
/maintain quick
```

This runs a quick health check. It'll flag any wiring issues.

If something looks wrong:
- Hook scripts not executable? Run `chmod +x $CLAUDE_PLUGIN_ROOT/hooks/scripts/*.sh`
- Statusline not showing? Make sure `~/.claude/settings.json` has the `statusLine` block
- A command doesn't appear? Restart Claude Code (`/quit` then re-launch)

## Step 7: Optional integrations

### Pushover (phone notifications)

1. Sign up at https://pushover.net
2. Create an app, get your User Key + API Token
3. Create `~/.env.local` with:
   ```
   PUSHOVER_USER_KEY=your_user_key
   PUSHOVER_API_TOKEN=your_api_token
   ```
4. The `permission-ding` and `context-monitor` hooks will start sending notifications.

### Notion (debt sync, session logs)

1. Create a Notion integration at https://www.notion.so/my-integrations
2. Create a database for operational debt with these properties:
   - Title (title), Date (date), Status (select: Open/Resolved/Deferred/Dismissed), Resolved (date)
3. Share the database with your integration
4. Add to `~/.env.local`:
   ```
   NOTION_RELAY_TOKEN=your_integration_token
   ```
5. Edit `examples/debt-sync.sh.opt-in` — set `DATABASE_ID` to your database ID
6. Copy it to `hooks/scripts/debt-sync.sh` and add a wire in `hooks/hooks.json` (PostToolUse on Edit|Write)

(This is more involved — see `examples/debt-sync.sh.opt-in` for full instructions.)

## Common questions

### "Will this conflict with my existing setup?"

If you already have hooks in `~/.claude/settings.json`, they'll continue to fire alongside the plugin's hooks. Run `/maintain` to detect any duplicate behavior.

### "Can I disable individual hooks?"

Yes. Edit `$CLAUDE_PLUGIN_ROOT/hooks/hooks.json` and remove the entry. Or set environment variables:
- `IDLE_SUMMARY_DISABLE=1` — disable idle-summary hook
- `SCOPE_CREEP_ENABLED=0` — keep scope-creep off (it's off by default anyway)

### "How do I update the plugin?"

```
/plugin update claude-code-starter-kit
```

### "How do I uninstall?"

```
/plugin uninstall claude-code-starter-kit
```

Removes the plugin and its hook wiring. Your CLAUDE.md, settings.json, and any files you wrote (notes, decision-log, debt.md) stay — they're outside the plugin.

## What to do next

Once you've customized CLAUDE.md and verified everything works:

1. Use Claude Code for a real task and see how the hooks feel
2. After a session, run `/reflect` and `/session-end` to start building habits
3. After a week, run `/permissions-audit` to clean up any permissions that accumulated
4. Edit ruthlessly — this kit is a starting point, not a religion

Welcome aboard.
