# Context Budget: What Loads, What It Costs, and Which Tool to Reach For

> Practices informed by the Anthropic × Tenex Claude Code workshop (Oct 2026).

Everything Claude knows in a session sits in one context window, and the whole thing is re-sent with every message. A line in your CLAUDE.md costs you on every turn of every session, including the turns where it doesn't matter. This primer covers how to keep that budget lean, and how to pick the right container for each kind of instruction: CLAUDE.md, a rule, a skill, a subagent, or a hook.

It builds on [`claude-md-layering-and-context-primer.md`](claude-md-layering-and-context-primer.md), which covers layering and the step-count test. Read that one first if you haven't.

---

## 1. What loads, and when

| Layer | Loads | Cost |
|---|---|---|
| `~/.claude/CLAUDE.md` | Every session, every project | Every turn, everywhere |
| Repo-root `CLAUDE.md` | Every session in that repo | Every turn in that repo |
| Sub-folder `CLAUDE.md` | When Claude works in that folder | Only in that area |
| `.claude/rules/<topic>.md` with `paths:` | When a file matching the globs is opened | Only when relevant |
| `CLAUDE.local.md` | Every session in that repo, your machine only | Every turn in that repo |
| Skill name + description | Always | Small, permanent |
| Skill body | When the skill triggers | Only on use |
| Skill `references/`, `scripts/`, `assets/` | When a run needs them | Only on demand |
| Subagent name + description | Always | Small, permanent |
| Subagent's own work | In its own separate context | You get back a summary |
| MCP servers | Tool names + server instructions at start; full schemas when used | Grows with every server connected |

**Size targets:** keep your user file to ~60 lines of working style (the kit's template is under 50), and any single CLAUDE.md under ~200 lines. Longer files cost more and get followed less closely.

**The user file is about how you work.** If a line describes a project, a repo, a folder, or a kind of file, it's in the wrong layer. [`claude-md-section-library.md`](claude-md-section-library.md) has a routing table, and [`examples/layered-repo/`](../examples/layered-repo/) shows every layer filled in.

**Write what Claude can't derive.** It can read folder structures and dependency files on its own. It can't read the decisions, constraints and traps behind them. Write those, specifically enough to check in a diff, and name the failure a rule prevents.

---

## 2. Context hygiene habits

- **Run `/context` at startup** in a new setup or project, and **again right after adding any MCP server.** Check the Memory files list (if a file isn't there, Claude can't see it) and the MCP tools line (a connected server costs context even when idle).
- **One task, one session.** Start fresh, or `/clear`, when you move to unrelated work. Clearing is cheaper than compacting, and stale context is paid for on every later message.
- **Compact at about half the window** rather than waiting for auto-compact. Compaction you trigger yourself, with instructions, keeps more of what matters: `/compact keep the file paths we changed and the open questions`.
- **Write the instructions once.** A `# Compact instructions` section in your CLAUDE.md (the kit's template has one) tells Claude what to keep every time it compacts, including the automatic ones.
- **Compaction only shrinks the conversation.** Tools, MCP servers, skills and CLAUDE.md cost the same afterwards. If those are your problem, compacting won't fix it; trimming will.
- **Only free space is usable.** The auto-compact buffer shown in `/context` is reserved headroom. Quality drops before anything visibly breaks, so act while you still have room.
- **Point, don't paste.** `@path/to/file` beats pasting a file's contents, and pointing at specific files beats asking Claude to "explore."
- **Prefer a CLI when one exists** (`gh`, `aws`, `gcloud`). It costs no standing context. Toggle unused MCP servers off in `/mcp` instead of deleting them; that's the fastest way to test whether one is worth what it costs.
- **`/rename` then `/resume`** a session you'll come back to, instead of keeping one open all day.
- **Watch the meter.** The kit's statusline shows context remaining at the bottom of your terminal.

### Monthly `/context` readout

`/kit:maintain` asks for this once a month. `/context` is a command only you can type, so the flow is: you run it, paste the output (or say "done" if Claude can see it), and Claude logs the totals for each category to `~/.claude/context-log.md` with the date, then compares them to last month. Watch for the categories you control growing: memory files, custom agents, skills, MCP tools.

---

## 3. Hooks: only for rules that can never be skipped

CLAUDE.md, skills and subagents are advice. Claude follows them most of the time, and the misses cluster where they hurt: long sessions, right after a compaction, under time pressure. A hook is a script that runs at a set moment every time, and a `PreToolUse` hook can block the action outright.

**The test:** write the rule in CLAUDE.md when a thoughtful colleague could reasonably do it another way. Write a hook only when there is no acceptable run where it gets skipped. Most setups need three or four enforcement hooks. Past that, the environment gets noisy and every injected nudge costs context.

**Prove each one fires.** A hook you've never seen fire is a hook you don't have. `/kit:verify` stages fake dangerous input to show the kit's guards actually block.

### The kit's own hooks against that test

The kit wires 15 hook scripts. Read them in three groups:

| Group | Hooks | Verdict |
|---|---|---|
| **Enforcement** (skipping is never OK) | `safety-net` (blocks destructive shell commands), `backup-before-edit` (copy before every edit), `self-guard` (blocks destructive scripts with no dry-run gate), `session-end` (transcript breadcrumb, runs after Claude can't) | **Keep.** These are the kit's three-or-four. |
| **Signals** (sounds and notifications; add nothing to context) | `notify-done`, `permission-ding`, `pre-compact` | Keep if you like them. They aren't rules, so the test doesn't apply, and they cost nothing in context. |
| **Nudges** (inject advice into context) | `user-prompt-context`, `context-monitor`, `idle-summary`, `retry-nudge`, `persistence-rule`, `writing-humanizer`, `scope-creep-detector` (off by default), `stop-check` (a no-op) | **Review.** These are judgment calls delivered by hook. Each could be a line in CLAUDE.md or a skill description instead. `user-prompt-context` re-injects `active-context.md` on every prompt, so keep that file short. |

None of these are removed in this release. If you want a leaner setup, the nudges are the ones to turn off first (see [INSTALL.md](../INSTALL.md#level-1-lightest-disable-a-single-hook)).

---

## 4. Skills: three loading levels

A skill is a folder. Only its **name and description** sit in context all the time. The **SKILL.md body** loads when the skill triggers. Files in **`references/`, `scripts/` and `assets/`** load only when a run needs them. So a thin SKILL.md with good pointers beats one long file: the long file is paid in full on every trigger.

```
my-skill/
├── SKILL.md            # description (when to use) + numbered steps + short rules
├── references/         # detail, examples, frameworks: read on demand
├── scripts/            # deterministic checks: run, not read
├── assets/             # templates for the output
└── evals/
    └── evals.json      # test prompts: how you know it works
```

- **If you've explained it twice, make it a skill.** The best candidates are dull: things you retype by hand, inconsistently. `/kit:extract-skill` scaffolds one.
- **Write the description for the trigger**, in the words someone would actually type, saying *when* to use it. A vague description means the skill never fires.
- **Keep SKILL.md to the steps and the rules.** Move examples, long pattern lists and frameworks into `references/` and say in the steps when to read them.
- **Add `evals/evals.json`.** A handful of realistic prompts with the expected behavior. Run them after any edit. Every skill in this kit ships one.
- **Fix bad behavior in the skill file,** not just in the conversation, or it comes back next session.
- **Never paste a skill body into CLAUDE.md** "to be safe." That turns an on-demand cost into a permanent one.

---

## 5. Subagents: a read-only investigator

A subagent runs in its own context and hands back only its findings, so a diagnosis that reads forty files costs you a summary. The `tools:` line in its frontmatter is the permission boundary: give it `Read, Grep, Glob` and it provably can't edit anything.

The kit ships one: [`agents/investigator.md`](../agents/investigator.md). It diagnoses and never fixes. Ask *"use the investigator to find out why X"* and you get back symptoms, root causes with file and line, evidence, what it ruled out, and what's still unknown. You decide what to change, in your main session. Findings from an agent that couldn't touch the code are safe to act on directly.

Two habits:
- **Run the built-ins first.** `/code-review` and `/security-review` are free. Build a custom reviewer only for rules a generic one can't know.
- **Give narrow, mechanical subagents a cheaper model** (`model: haiku` in the frontmatter).

---

## Which tool for which job

| You want… | Use |
|---|---|
| Claude to know how you work, everywhere | User `CLAUDE.md` |
| Claude to know how one repo works | That repo's `CLAUDE.md` (plus folder files and rules) |
| A repeatable procedure that loads only when needed | A skill |
| An unbiased second opinion, or a big read that shouldn't fill your context | A subagent |
| A rule that must hold every single time | A hook |
| Access to an outside system | A CLI if one exists, otherwise an MCP server |
