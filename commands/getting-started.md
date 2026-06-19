---
name: getting-started
description: First-run orientation for the claude-code-starter-kit plugin. Walks through what's included, where things live, and how to customize.
---

# Welcome to claude-code-starter-kit

This is a guided first-run walkthrough. Read it once, then customize.

## What you just installed

A curated set of hooks, slash commands, agents, and skills for Claude Code, plus a CLAUDE.md framework. The goal: a calm, structured, partnership-style setup where Claude Code knows how to work with you, not just for you.

**The architecture:**

```
You ──── CLAUDE.md (your instructions) ────────┐
                                                ↓
                                            Claude Code
                                                ↓
        ┌──────────────────┬──────────────────┐
        │                  │                  │
     Hooks         Slash Commands         Agents/Skills
   (automation)    (your shortcuts)    (specialized work)
```

## Walk through it

Tell the user (the human reading this):

### 1. CLAUDE.md is the most important file

Located at `~/.claude/CLAUDE.md`. It's loaded into every Claude Code session. The starter kit shipped with a template you can use as your starting point.

**Action item:** Offer to copy the template to `~/.claude/CLAUDE.md` for the user (you have the plugin path; they don't). Then tell them to open it and replace the `[YOUR_NAME]`, `[YOUR_ROLE]`, `[YOUR_PROJECTS]` placeholders. Tell them to spend 15 minutes on this — it's the highest-leverage time they'll spend on their setup.

### 2. Hooks run automatically

Hooks are scripts that run on Claude Code events. The kit installs:

- **safety-net** — Blocks destructive shell commands (rm -rf on dangerous paths, force push to main, etc.)
- **self-guard** — Prevents Claude from authoring foot-gun scripts without dry-run gates
- **backup-before-edit** — Auto-backs up files before Claude edits them
- **retry-nudge** — Coaches Claude to retry validation errors before escalating
- **context-monitor** — Warns when context is getting low
- **idle-summary** — When you return after >15min, prepends a "where we left off" summary
- **session-end** — Logs every session for recovery
- **user-prompt-context** — Injects active-context.md before every prompt
- (...and a few more — see `hooks/scripts/`)

You don't run these. They run themselves. Read `hooks/scripts/*.sh` if you want to understand what's happening.

### 3. Slash commands are your shortcuts

Type these in Claude Code. (Installed plugin commands are namespaced, so they all start with `/kit:`.)

- `/kit:session-end` — Log the session, update active-context for next time
- `/kit:reflect` — End-of-session retrospective (quick or deep)
- `/kit:debt` — Review operational debt items
- `/kit:recall <topic>` — Search across past sessions for something
- `/kit:maintain` — Periodic system health check
- `/kit:note <text>` — Quick timestamped capture to today's notes
- `/kit:decision <title>` — Log a structured decision with reasoning
- `/kit:permissions-audit` — Review and prune settings.json permissions
- `/kit:checkpoint` — Save mid-session state snapshot
- `/kit:extract-skill` — Scaffold a new skill from an emerging pattern

> This is a curated subset. The full list of all 14 commands lives in the README.

### 4. Agents are specialists

When a task is big enough, Claude can spawn an agent to handle it:

- **deep-research** — Multi-source research with confidence calibration
- **strategic-reviewer** — Devil's advocate review of plans/proposals
- **skill-diagnostics** — Debug skill triggering issues
- **task-decomposition-expert** — Break complex goals into ordered steps
- **communication-excellence-coach** — Email refinement, difficult conversations

You don't usually invoke these directly — Claude picks them when appropriate.

### 5. Skills are reusable knowledge

Generic frameworks Claude loads on demand:

- **humanizer** — Remove AI tells from writing
- **learning-capture** — Pin valuable insights mid-conversation
- **idea-to-scope** — Transform vague ideas into structured scope docs
- **kaizen** — Continuous improvement framework

## Setup checklist

Walk the user through this. **For each item, offer to do it for them** — most users don't want to type `cp` commands. The plugin variables (`$CLAUDE_PLUGIN_ROOT`) only resolve when Claude runs commands, not when the user runs them in a regular terminal.

- [ ] Copy CLAUDE.md template to `~/.claude/CLAUDE.md` (offer to do it for them, then they edit)
- [ ] Customize `~/.claude/CLAUDE.md` placeholders (`[YOUR_NAME]`, `[YOUR_ROLE]`, `[YOUR_PROJECTS]`)
- [ ] Optionally install the statusline (offer to copy `examples/statusline.sh` to `~/.claude/statusline.sh` and chmod it executable)
- [ ] Optionally add `statusLine` block to `~/.claude/settings.json`
- [ ] Optional: enable `explanatory-output-style` plugin for `★ Insight` boxes
- [ ] Optional: configure Pushover for phone notifications (see `examples/pushover-setup.md`)
- [ ] Optional: configure Notion sync for `/kit:debt` and `/kit:session-end` (see `examples/debt-sync.sh.opt-in`)
- [ ] Run `/kit:maintain quick` to verify everything's wired correctly
- [ ] **First success moment:** ask the user to type `/kit:note testing the kit` — a timestamped line will land in `~/.claude/notes/YYYY-MM-DD.md`. That's a hook + a slash command + a file, all working together.

## What to do if something feels wrong

- Hooks too noisy? Edit `hooks/hooks.json` and remove what you don't want.
- A slash command doesn't fit your workflow? Delete it from `commands/` or rewrite it.
- Want to disable a hook temporarily? Add `IDLE_SUMMARY_DISABLE=1` (and similar) to your shell env.

This is a starter kit, not a religion. Adapt it.

## Where to go next

- Read `docs/ARCHITECTURE.md` for the philosophy
- Read `docs/output-styles-primer.md` for native output style options
- Read `docs/plan-mode-primer.md` for when to use plan mode
- Read `docs/worktrees-primer.md` for parallel work patterns

Welcome aboard.
