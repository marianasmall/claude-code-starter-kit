# Architecture

The philosophy and design choices behind this starter kit.

## The core problem

Claude Code out of the box is *capable* but *characterless*. It can do almost anything you ask it to, but it has no idea:
- Who you are
- How you work best
- What "done" looks like for the kind of work you do
- What patterns you've already established
- What mistakes you've already learned not to repeat

Most users never customize past defaults. They lose 80% of the value the tool can provide.

This kit is the minimum viable infrastructure to extract that value.

## Three-space memory

Borrowed loosely from cognitive architectures: memory works best when separated by *purpose* and *pace of change*.

### Space 1: Self (Identity + Methodology)
**What Claude needs to know to *be* the right partner.** Slow-changing.

- `~/.claude/CLAUDE.md` — Your curated instructions. You control this. Strategic, stable.
- `~/.claude/projects/-<encoded-path>/memory/MEMORY.md` — Auto-observations Claude writes. Tactical, evolving.

### Space 2: Domain Knowledge
**What Claude needs to know to *do the work*.** Steady accumulation.

- Skills (in plugins or `~/.claude/skills/`)
- Reference files
- Project-specific docs (PLANNING.md, CONTEXT-SUMMARY.md)

### Space 3: Operations
**What's happening *now*.** Fluctuating.

- `~/.claude/active-context.md` — Current state, injected before every prompt
- `~/.claude/session-summaries.md` — Session log
- `~/.claude/debt.md` — Operational debt (`/debt`)
- `~/.claude/notes/YYYY-MM-DD.md` — Daily notes (`/note`)
- `~/.claude/decision-log.md` — Structured decisions (`/decision`)
- `~/.claude/checkpoints/` — Mid-session snapshots (`/checkpoint`)

**Why three spaces matter:** Mixing them causes retrieval pollution. Session logs in domain knowledge = search noise. Identity docs in operations = stale context loaded unnecessarily. Keep them separate; load from the right space for the task at hand.

## The hook design philosophy

Hooks in this kit follow these principles:

### 1. Default to safe, fail to silent

Every hook exits 0 (allow) on any error condition, and most also echo `{"ok": true}` explicitly. No hook should block work because *the hook itself* is broken. Better to lose a feature than break a session. (One deliberate exception: the safety hooks refuse to run blind — if `python3` is missing they say so instead of silently switching protection off.)

### 2. Bounded blast radius

Hooks that block (`safety-net`, `self-guard`) only block well-defined patterns. They don't try to be smart — they catch known-bad patterns and let everything else through. Better to have a small false-negative rate than a false-positive rate.

### 3. Information, not enforcement

Hooks like `retry-nudge`, `persistence-rule`, `writing-humanizer`, `scope-creep-detector` emit *advisory* messages via `additionalContext`. They never prevent Claude from proceeding. Claude is trusted to read the advice and act on it.

### 4. Degrade gracefully

Hooks that depend on external services (`pushover`, `debt-sync`) silently no-op when credentials aren't configured. Installing the kit shouldn't fail because you don't have a Pushover account.

### 5. Make the invisible visible

`backup-before-edit`, `pre-compact`, `session-end` all create artifacts you can audit later. If something went wrong, there's a paper trail.

## The slash command design philosophy

Commands here follow a different principle than typical CLI tools:

**Commands aren't shortcuts. They're rituals.**

`/session-end` isn't faster than typing "log a session summary" — it's a *consistent* prompt that produces a *consistent* shape. The discipline is the value, not the time saved.

`/reflect` doesn't surface novel insights — it forces you to ask the same six questions every time. That's the point. Variation breeds drift.

`/debt`, `/decision`, `/note` — they all create *append-only logs* with consistent formatting. You can grep them in a year. You can review them in aggregate.

The slash commands are how you build a *practice*, not a *workflow*.

## The CLAUDE.md template

The template isn't a fill-in-the-blank form. It's a *prompt* for thinking about your own context.

You're meant to:
1. Read it once
2. Strip 50% of it (the parts that don't apply)
3. Add your own sections (the things only you need)
4. Edit it when something feels off

A good CLAUDE.md after 6 months looks nothing like the template — it's been weathered into a shape that fits *your* work. That's the goal.

## What's deliberately not here

### No "personality" engineering

Some Claude Code setups try to give Claude a persona ("act as a senior engineer," "be skeptical," etc.). This kit doesn't. Personality emerges from your CLAUDE.md and the way you talk to Claude. Layered prompts cause drift.

### No "agentic" complexity

There's no orchestration layer trying to chain agents together autonomously. Claude Code is already smart enough to call the right agent at the right time. Layering more orchestration on top creates fragile pipelines.

### No proprietary conventions

Things like specific filename patterns, project-state file naming (PLANNING.md vs CONTEXT-SUMMARY.md), or strict directory layouts are *suggested* in the templates but not *enforced*. The kit doesn't care if you don't use them.

### No "feature flags"

Every hook either runs or doesn't (per `hooks.json`). There's no settings layer above that. If you want to disable something, edit the JSON.

## When this kit isn't right

Skip the kit if:

- **You're a first-week Claude Code user.** Use defaults until you've felt the pain points yourself. The kit's value comes from the patterns it embeds — patterns that only make sense after you've encountered the problems they solve.
- **You only use Claude Code for one specific thing.** This kit is for general-purpose knowledge work. If you only do code review, install code-review-focused tools instead.
- **You hate opinions.** This kit has them. If "the kit thinks I should journal decisions" makes you irritated, you'll fight it. Better to roll your own.

## Versioning + evolution

This kit is at **v0.1.0** — early. Expect:
- Hooks to be added or refined as new Claude Code events become available
- Commands to absorb good patterns from the community
- Templates to get cleaner as feedback accumulates

If something breaks after an update, you can roll back by checking out an earlier tag of this repo and installing from that copy. (Note: in `/plugin install kit@claude-code-starter-kit`, the `@` names the *marketplace*, not a version — there is no version-pinning install syntax.)
