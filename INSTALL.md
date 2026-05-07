# Installation Guide

Step-by-step setup for `claude-code-starter-kit`. Plain language. Light-technical friendly.

## Prerequisites

### Don't have Claude Code yet?

Here's a guest pass to get you started:

**https://claude.ai/referral/wYS1mXeEWg**

That'll get you up and running with Claude (you need at least Claude Pro to use Claude Code).
Already have a Claude account? Skip this and follow the official install: https://claude.com/code

---

You need:
- **Claude Code** installed and working (`claude --version` should print something)
- A **macOS, Linux, or WSL** environment (Windows native is partially supported but the macOS notification hooks won't fire)
- **`jq`** and **Python 3** in your `$PATH` (most systems have these — `jq --version` and `python3 --version` to check)

Optional (only if you want their features):
- **Pushover** account (for phone notifications)
- **Notion** workspace + API key (for `/debt` and session sync)
- **`gitleaks`** (for the secrets scan in `/maintain`)

> **Where to type things:** The instructions below use commands in two places:
> - **In your terminal** (regular shell — Terminal app on Mac, etc.) — for things like opening Claude Code or editing files
> - **At Claude Code's prompt** (after you launch it) — for slash commands like `/plugin install`
>
> Where it matters, I'll call out which one. The friendliest path is to **let Claude do the file copies for you** — see Step 3.

## Step 1: Open Claude Code

If Claude Code isn't already running:

1. **Open Terminal**
   - **macOS:** Press `Cmd + Space`, type "Terminal", press Enter
   - **Linux:** Press `Ctrl + Alt + T`, or find Terminal in your apps menu
   - **Windows (WSL):** Open your WSL distro from the Start menu
2. **Type `claude` and press Enter**
3. You should see Claude Code's prompt — that's where slash commands go

If `claude` says "command not found," Claude Code isn't installed yet. Scroll back up to Prerequisites.

## Step 2: Install the plugin

**At Claude Code's prompt** (not the regular terminal), type:

```
/plugin install marianasmall/claude-code-starter-kit
```

Or, if you cloned the repo locally:

```
/plugin install /path/to/claude-code-starter-kit
```

This wires the hooks, commands, agents, and skills into Claude Code. They become available immediately.

## Step 3: Let Claude set you up (the easy way)

The friendliest path: just ask Claude to do the file setup for you. Type this at Claude Code's prompt:

> Set me up with the starter kit defaults. Copy the CLAUDE.md template, settings.json template, and statusline to my ~/.claude/ directory. Make the statusline executable. Tell me what you did.

Claude already knows where the plugin's files live (it has the `$CLAUDE_PLUGIN_ROOT` variable available). It'll copy the templates, set permissions, and report back.

**Why this is easier than typing commands manually:** the file paths use environment variables that only exist *inside* Claude Code — if you tried to run them in a regular terminal, they'd fail silently.

If you'd rather do it yourself manually, see **Manual Setup** at the bottom of this file.

## Step 4: Customize your CLAUDE.md

After Claude copies the template, open `~/.claude/CLAUDE.md` in any text editor (VS Code, TextEdit, vim — whatever you have).

Replace the `[YOUR_NAME]`, `[YOUR_ROLE]`, `[YOUR_PROJECTS]` placeholders with your actual context. **Spend 15-30 minutes on this.** It's the highest-leverage time you'll spend on your setup.

You don't need to fill every section. Strip what doesn't apply.

## Step 5: Walk through `/getting-started`

**At Claude Code's prompt:**

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

---

## Manual Setup (for those who'd rather do it themselves)

If you'd rather copy the templates by hand instead of asking Claude (Step 3 above), here's the manual path. **All commands here run in your regular terminal** (not at Claude Code's prompt).

### Find the plugin path

After installing the plugin, ask Claude:

> Where is this plugin installed? Print the absolute path.

Claude will respond with something like `/Users/yourname/.claude/plugins/cache/<id>/claude-code-starter-kit/`. Copy that path — you'll use it as `<PLUGIN_PATH>` below.

### Copy the CLAUDE.md template

```
cp <PLUGIN_PATH>/CLAUDE.md.template ~/.claude/CLAUDE.md
```

### Copy the settings.json template (optional)

If you don't already have `~/.claude/settings.json`:

```
cp <PLUGIN_PATH>/settings.json.template ~/.claude/settings.json
```

If you already have one, **don't overwrite it** — open both files in a text editor and merge the useful sections (`enabledPlugins`, `spinnerVerbs`, any permissions you want). Replace `[CUSTOMIZE]` placeholders (mostly your username in path patterns).

### Install the statusline (optional, recommended)

The statusline shows context window remaining, cost, duration, and rate limits at the bottom of your terminal.

```
cp <PLUGIN_PATH>/examples/statusline.sh ~/.claude/statusline.sh
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

Restart Claude Code (`/quit`, then re-launch) and you'll see the bar at the bottom of your terminal.

### Why the easy path is easier

Inside Claude Code, the variable `$CLAUDE_PLUGIN_ROOT` resolves to the plugin path automatically. Outside Claude Code (in your regular terminal), it doesn't — which is why the manual path requires you to find the plugin path first. If you skip that, the `cp` commands will silently fail.
