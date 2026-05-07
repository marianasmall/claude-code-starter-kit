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

Located at `~/.claude/CLAUDE.md`. It's loaded into every Claude Code session. The starter kit shipped with a template — find it at `$CLAUDE_PLUGIN_ROOT/CLAUDE.md.template`.

**Action item:** Copy the template to `~/.claude/CLAUDE.md` and customize it. Replace the `[YOUR_NAME]`, `[YOUR_ROLE]`, `[YOUR_PROJECTS]` placeholders. Spend 15 minutes on this — it's the highest-leverage time you'll spend on your setup.

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

Type these in Claude Code:

- `/session-end` — Log the session, update active-context for next time
- `/reflect` — End-of-session retrospective (quick or deep)
- `/debt` — Review operational debt items
- `/recall <topic>` — Search across past sessions for something
- `/maintain` — Periodic system health check
- `/note <text>` — Quick timestamped capture to today's notes
- `/decision <title>` — Log a structured decision with reasoning
- `/permissions-audit` — Review and prune settings.json permissions
- `/checkpoint` — Save mid-session state snapshot
- `/extract-skill` — Scaffold a new skill from an emerging pattern

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

Walk the user through this:

- [ ] Customize `~/.claude/CLAUDE.md` from the template
- [ ] Optionally install the statusline (`cp $CLAUDE_PLUGIN_ROOT/examples/statusline.sh ~/.claude/statusline.sh && chmod +x ~/.claude/statusline.sh`)
- [ ] Add `statusLine` block to `~/.claude/settings.json` (template at `$CLAUDE_PLUGIN_ROOT/settings.json.template`)
- [ ] Optional: enable `explanatory-output-style` plugin for `★ Insight` boxes
- [ ] Optional: configure Pushover for phone notifications (see `examples/pushover-setup.md`)
- [ ] Optional: configure Notion sync for `/debt` and `/session-end` (see `examples/debt-sync.sh.opt-in`)
- [ ] Run `/maintain quick` to verify everything's wired correctly

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
