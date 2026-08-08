# Installation Guide

Step-by-step setup for `claude-code-starter-kit`. Plain language. Light-technical friendly.

## Prerequisites

### Don't have Claude Code yet?

Follow the official setup guide to get Claude Code installed: **https://code.claude.com/docs/en/setup**

Claude Code requires a Claude paid plan (Pro or Max) or Anthropic API billing.

---

You need:
- **Claude Code** installed and working (`claude --version` should print something)
- A **macOS, Linux, or WSL** environment. Note: the sound/notification hooks (done-chime, permission ding, compaction alert) use macOS `osascript` — on Linux/WSL and Windows all safety and coaching hooks work identically, but you get no audible/desktop alerts unless you wire your own `notify-send` equivalent.

**Heads-up on backups:** the pre-edit backup hook drops a timestamped copy into a `_backups/` folder *next to any file Claude edits* — in every project, not just `~/.claude/`. That's the safety net working as designed, but add `_backups/` to your global gitignore (`git config --global core.excludesFile`) so it never lands in a commit.
- **`jq`** and **Python 3** in your `$PATH` (most systems have these — `jq --version` and `python3 --version` to check)

Optional (only if you want their features):
- **Pushover** account (for phone notifications)
- **Notion** workspace + API key (for `/kit:debt` and session sync)
- **`gitleaks`** (for the secrets scan in `/kit:maintain`)
- **`pipx`** (for the Python tool checks in `/kit:maintain` — install via `brew install pipx`. Modern Python enforces PEP 668, which blocks system-wide pip installs.)

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

**At Claude Code's prompt** (not the regular terminal), run these two commands:

```
/plugin marketplace add https://github.com/marianasmall/claude-code-starter-kit
/plugin install kit@claude-code-starter-kit
```

Then activate:

```
/reload-plugins
```

**What's happening:** the first command registers this repo as a *marketplace* on your machine (one-time per machine — Claude Code keeps a local registry of trusted plugin sources). The second installs the plugin from that registered source. The third reloads the active session so the new hooks, commands, agents, and skills become available without restarting.

> **Why the HTTPS URL?** The `owner/repo` shortform works on most machines, but on some setups it resolves to an SSH clone (`git@github.com`), which fails if you've never SSH'd to GitHub before (you'll see a "Host key verification failed" error). The HTTPS URL sidesteps SSH entirely, so it's the safer default for a first install.

**Alternative — local install:** If you cloned the repo locally and want to install from your filesystem:

```
/plugin marketplace add /path/to/claude-code-starter-kit
/plugin install kit@claude-code-starter-kit
```

## Step 3: Let Claude set you up (the easy way)

The friendliest path: just ask Claude to do the file setup for you. Pick the prompt that matches your situation:

### If you're starting fresh (no existing CLAUDE.md or settings.json)

Type this at Claude Code's prompt:

> Set me up with the starter kit defaults. Copy the CLAUDE.md template, settings.json template, and statusline to my ~/.claude/ directory. Make the statusline executable. Tell me what you did.

### If you already have a CLAUDE.md or settings.json (existing setup)

Type this instead — it tells Claude **not** to overwrite anything:

> I already have a CLAUDE.md and/or settings.json. Show me what's in the starter kit templates so I can decide what to merge. Don't overwrite my existing files. For the statusline, copy it only if I don't have one.

Claude will read the template files and surface what's worth merging (e.g., new spinner verbs, new permissions, the `enabledPlugins` block) without touching your existing customization.

### Why this works

Claude already knows where the plugin's files live (it has the `$CLAUDE_PLUGIN_ROOT` variable available). It'll handle the templates, set permissions, and report back. The file paths use environment variables that only exist *inside* Claude Code — if you tried to run them in a regular terminal, they'd fail silently.

> **Extra safety:** Even if Claude does try to overwrite a file via the Edit or Write tools, the kit's `backup-before-edit` hook automatically creates a timestamped `.bak` copy first. So you can recover if anything unexpected happens.

If you'd rather do it yourself manually, see **Manual Setup** at the bottom of this file.

## Step 4: Customize your CLAUDE.md

Once `~/.claude/CLAUDE.md` is in place (whether Claude copied it fresh in Step 3 or you merged from your existing one), open it and edit it.

> ⚠️ **Heads up:** `~/.claude/` is a **hidden folder** on macOS. Finder won't show it by default. Use one of these instead:
>
> - **In TextEdit:** Open TextEdit → `File → Open` → press `Cmd+Shift+G` → paste `~/.claude/CLAUDE.md` → press Enter. (TextEdit may open the file in Rich Text mode — if it looks fancy with formatting toolbars, press `Cmd+Shift+T` to switch to Plain Text before editing. Markdown should stay plain text.)
> - **In VS Code:** Run `code ~/.claude/CLAUDE.md` in your terminal
> - **In vim:** Run `vim ~/.claude/CLAUDE.md` in your terminal
> - **Easiest of all:** Just ask Claude — *"Open my CLAUDE.md so I can edit it."* Claude can show you the contents and even make edits if you tell it what to change.

Inside the file, you'll find placeholders in brackets like `[YOUR_NAME]`, `[YOUR_ROLE]`, `[YOUR_PROJECTS]`. Replace them with your real context.

**Examples of good fill-ins:**

| Placeholder | Example |
|---|---|
| `[YOUR_NAME]` | Your first name |
| `[YOUR_ROLE]` | "Marketing executive who understands code conceptually but doesn't write it" or "Senior backend engineer at a fintech startup" |
| `[YOUR_PROJECTS]` | "Building a fractional CMO consulting practice + a course on AI literacy" |

**Spend 15-30 minutes on this.** It's the highest-leverage time you'll spend on your setup.

You don't need to fill every section. Strip what doesn't apply. The template is a prompt, not a constraint.

## Step 5: Walk through `/kit:getting-started`

**At Claude Code's prompt:**

```
/kit:getting-started
```

This walks you through the architecture, what each hook does, and the customization options.

## Step 6: Verify everything's working

**At Claude Code's prompt:**

```
/kit:verify
```

This runs the hook fire drill: it proves every installed hook is alive — including staging fake dangerous input to confirm the safety hooks actually block it. Dry-run, changes nothing. All green means you're wired correctly. (For a broader checkup — Claude Code version, packages — there's also `/kit:maintain quick`.)

If something looks wrong, ask Claude:

- *"My hook scripts aren't executable. Can you fix them?"* (Claude will run the chmod for you — the file paths use plugin variables it knows but you don't.)
- *"My statusline isn't showing. Help me debug."*
- *"This slash command isn't appearing. What's wrong?"* (Sometimes you need to type `/quit` to exit Claude Code, then type `claude` again in Terminal to start a fresh session — that picks up new commands.)

> ## 🎉 You're done with the basics
>
> If `/kit:verify` came back all green, **you're set up.** Steps 7+ below are optional integrations — only do them if you want the specific features they add.
>
> **Try this right now to feel the kit working:** type `/kit:note testing the kit` at Claude Code's prompt. A timestamped line will land in `~/.claude/notes/YYYY-MM-DD.md` (that's a hidden folder — to view it, use the same TextEdit `Cmd+Shift+G` trick from Step 4, or just ask Claude *"show me what's in today's notes file"*). That's a hook + a slash command + a file the kit created, all working together. Welcome aboard.

## Step 7 (optional): Integrations

### Pushover (phone notifications)

> **Why bother:** Get a notification on your phone when Claude needs your approval to do something — useful when you've stepped away from your laptop. Also pings you when context is running low so you know to wrap up. ~$5 one-time, no subscription.

1. Sign up at https://pushover.net
2. Create an app, get your User Key + API Token
3. Create `~/.env.local` with:
   ```
   PUSHOVER_USER_KEY=your_user_key
   PUSHOVER_API_TOKEN=your_api_token
   ```
4. The `permission-ding` and `context-monitor` hooks will start sending notifications automatically.

### Notion (debt sync, session logs)

> **Why bother:** Sync your operational debt items and session summaries to Notion automatically. Useful if Notion is already your daily hub for notes/projects. Skip this if you'd rather keep everything local in markdown files (the kit works fully without it).

1. Create a Notion integration at https://www.notion.so/my-integrations
2. Create a database for operational debt with these properties:
   - Title (title), Date (date), Status (select: Open/Resolved/Deferred/Dismissed), Resolved (date)
3. Share the database with your integration
4. Add to `~/.env.local`:
   ```
   NOTION_RELAY_TOKEN=your_integration_token
   ```
5. Edit `examples/debt-sync.sh.opt-in` — set `DATABASE_ID` to your database ID
6. Copy it to `hooks/scripts/debt-sync.sh` and register it in `hooks/hooks.json` (add an entry under PostToolUse with matcher `Edit|Write`)

(This is the most involved integration — see `examples/debt-sync.sh.opt-in` for full instructions. Most users skip it and the kit works fine.)

## Common questions

### "Will this conflict with my existing setup?"

If you already have hooks in `~/.claude/settings.json`, they'll continue to fire alongside the plugin's hooks. Run `/kit:maintain` to detect any duplicate behavior.

### "How do I update the plugin?"

```
/plugin update kit
```

---

## Don't like something? Here's how to back out

None of this is one-way. Three levels of revert, light to heavy:

### Level 1 (lightest): Disable a single hook

If one specific hook is annoying you (the writing-humanizer keeps nudging when you don't want it, the idle-summary fires too often), disable just that one.

**Easiest way:** ask Claude — *"Disable the writing-humanizer hook from the starter kit."* Claude will edit the plugin's `hooks/hooks.json` to remove that entry. The other hooks keep working.

**Some hooks have built-in env-var disables:**
- `IDLE_SUMMARY_DISABLE=1` — turns off idle-summary for the current session
- `SCOPE_CREEP_ENABLED=0` — keeps scope-creep off (it's off by default anyway)

Add these to your shell environment (`~/.zshrc` or similar) to make them permanent.

### Level 2 (medium): Disable the whole plugin

Keep it installed but stop everything from firing:

```
/plugin disable kit
```

All hooks stop firing. All slash commands disappear from `/help`. Your personal CLAUDE.md, settings.json, notes, and decision-log are untouched. Re-enable any time with `/plugin enable kit`.

### Level 3 (heaviest): Uninstall entirely

```
/plugin uninstall kit
```

Removes the plugin and all its files. Your personal config files (CLAUDE.md, settings.json, statusline.sh) and any files you wrote (`~/.claude/notes/*`, `~/.claude/decision-log.md`, `~/.claude/debt.md`) all stay — they're outside the plugin.

### Restoring an overwritten CLAUDE.md or settings.json

If during install Claude overwrote a file you wanted to keep, the kit's `backup-before-edit` hook auto-created a timestamped backup. Find it:

```
ls ~/.claude/_backups/
```

You'll see files like `CLAUDE.md.20260506_143022.bak`. Restore by copying back:

```
cp ~/.claude/_backups/CLAUDE.md.20260506_143022.bak ~/.claude/CLAUDE.md
```

> **Caveat:** the backup hook only fires when Claude uses the **Edit/Write tools**, not when it runs `cp` via Bash. If Claude used Bash to copy the template, there's no auto-backup. This is the only real risk, and it's why we recommend appending `.backup` to your existing filenames *before* installing if you want belt-and-suspenders safety. For example, in your terminal:
>
> ```
> mv ~/.claude/CLAUDE.md ~/.claude/CLAUDE.md.backup
> mv ~/.claude/settings.json ~/.claude/settings.json.backup
> ```
>
> If anything goes sideways during install, restore by renaming back: `mv ~/.claude/CLAUDE.md.backup ~/.claude/CLAUDE.md`.

## What to do next

Once you've customized CLAUDE.md and verified everything works:

1. Use Claude Code for a real task and see how the hooks feel
2. After a session, run `/kit:reflect` and `/kit:session-end` to start building habits
3. After a week, run `/kit:permissions-audit` to clean up any permissions that accumulated
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

The statusline shows context window remaining, cost, duration, and rate limits at the bottom of your terminal — and names your terminal tab after the conversation (Claude Code's auto-generated session title, or whatever you set with `/rename`), so parallel sessions stay tellable-apart.

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
