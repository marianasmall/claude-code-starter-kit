# Layered CLAUDE.md, Skills as Folders, and Context Hygiene

> **Credit:** The practices in this primer come from JJ at [Tenex](https://www.tenex.co), who taught them in the Anthropic x Tenex virtual Claude Code workshop on October 2, 2026. They're summarized and adapted here in our own words, with a few notes on how they fit this kit. Tenex runs free virtual Claude Code and Cowork workshops every week ([sign up here](https://www.anthropic.com/events/build-with-claude)), publishes copy-paste [playbooks](https://www.tenex.co/playbooks), and writes the weekly [ultrathink](https://www.tenex.co/ultrathink) newsletter. Go to the source if you want the full version.

Every new Claude Code session starts with **zero memory**. Think of a very smart new hire who shows up each morning having forgotten everything. Most of what makes Claude feel "smart about your stuff" is how quickly you can bring that new hire up to speed, and how you keep them focused once they are.

---

## 1. Layer your CLAUDE.md files

A single CLAUDE.md at the top of a project is a good start. The step most people skip is **layering**: putting shorter CLAUDE.md files inside the big sub-folders, so the deeper Claude goes, the more specific its directions get.

| File | Scope | What belongs in it |
|---|---|---|
| `CLAUDE.md` at the project root | Every session | What this project is, the house rules, and a **map of where things live** |
| `some-folder/CLAUDE.md` | When Claude works in that folder | How this area works, its own rules, where to find things inside it |
| `some-folder/<topic>.md` | When Claude needs depth on one topic | One topic in detail (e.g. "how we format money"). The folder's CLAUDE.md points to it |
| `CLAUDE.local.md` | Only you (not shared) | Your personal preferences for this project. Keep it out of git |
| `.claude/rules/*.md` with `paths:` frontmatter | Only when matching files are opened | Detail that would be noise until Claude touches that kind of file |

Picture a hiking trail with a signpost at every fork: "you made it this far; here's what you need to know about this stretch." Without signposts, Claude reads everything in a folder to figure out where it is, which is slow, burns tokens, and repeats in every new session.

**The workspace map matters most.** A root CLAUDE.md that says "the API routes live in `src/api/`, the tests live next to each file, the money helpers are in `src/lib/money.ts`" saves the agent from rediscovering your project from scratch every time.

### Don't have one yet?

- Run **`/init`** in a project to have Claude draft a starting CLAUDE.md for that codebase.
- You can also ask Claude: *"Look at this repo's structure and my CLAUDE.md files and tell me where adding more would make you more efficient."*

### How to know where you need one: the step-count test

Open a **fresh** session and ask Claude to go somewhere you visit often: *"Go to the part of the code that handles X and explain how it works."* Then count the tool calls (the steps) it takes to get there.

- **3 or fewer:** that area is well mapped.
- **5 to 10:** Claude is lost and wasting tokens on every visit, so add a CLAUDE.md (or a pointer in the parent one) there.

Repeat for your 3-5 most-visited areas. Re-run afterwards to confirm the count dropped. You can also ask: *"Look at my recent activity in this project and tell me where better documentation would get you there faster."*

### One honest caveat

CLAUDE.md is followed **most** of the time, not every time. Claude is built on a language model, and the longer a conversation runs, the more likely early instructions drift. For rules that must never be broken, use a **hook** (section 5).

> **Fits with this kit:** [`project-conventions.md`](project-conventions.md) covers the project-local CLAUDE.md alongside README, PLANNING, CONTEXT-SUMMARY and handoff. This primer adds the *layering* inside a project.

---

## 2. Keep each session focused

Every message you send resends the **whole conversation** to the model, so long sessions cost more and get sloppier. Think of five people with one task each versus one person juggling five: focus wins.

- **One session per task.** When something new comes up, start a new session for it.
- **`/compact`** summarizes a long conversation to free up room. You can say what to keep raw, e.g. *"/compact but keep the full discussion about the database schema."* A common habit is compacting around 60-70% full, unless the session is deep in a problem and still needs that detail.
- **`/clear`** wipes the session and starts fresh.
- **`/btw`** opens a side question in its own panel, so it doesn't distract the main session.
- **Fork** a session (⋯ menu in the desktop app) to copy its full context into a new session. Use it for "feature B" while the original keeps working on "feature A."
- Watch the **context indicator** (bottom-right in the desktop app). If most of your tokens go to skills or MCP tools, you've loaded more than you need.

> **Fits with this kit:** the kit's context bar and low-context warnings tell you when to act. [`multi-session-coordination-primer.md`](multi-session-coordination-primer.md) covers running several sessions side by side.
>
> **Later update:** [`context-budget-primer.md`](context-budget-primer.md) adds `/context` habits and a more conservative compaction point (about half the window), plus a `# Compact instructions` section you can put in CLAUDE.md so every compaction keeps what matters.

---

## 3. Plan first, then let it run (`/goal`)

Tenex engineers report spending roughly **60-70% of their time planning and reviewing** and 30-40% building. An agent that keeps stopping to ask you questions is usually a sign the plan was thin.

A good plan decides up front what's in scope, what's **out** of scope, and **how you'll know it's done**. Then:

- **Plan mode** lets Claude propose before it touches anything (see [`plan-mode-primer.md`](plan-mode-primer.md)).
- **`/goal`** (built into Claude Code) sets a goal with a "done when..." condition. Claude keeps working until the condition is met, then stops and tells you. Pair it with your written plan: *"/goal Build what's in docs/plan.md. Done when every acceptance criterion is met and the tests pass."*

The "done when" line is the whole game. Vague goals stop too early or wander.

---

## 4. Skills are folders, not single files

A skill (a reusable procedure Claude follows) works much better as a **folder** than as a lone `SKILL.md`:

```
my-skill/
├── SKILL.md          # the steps
├── references/
│   ├── good/         # examples of what great output looks like
│   └── bad/          # examples of what to avoid
├── checklist.md      # pass/fail checks the skill grades itself against
└── scripts/          # checks a program can run (word counts, banned words, broken links)
```

With good and bad examples plus a checklist, a skill can **check its own work and rewrite until it passes** before you ever see it. JJ uses this pattern for his weekly newsletter: the skill loops for up to an hour, and his first read is a 90-95% draft.

Two tips:
- **Scripts beat judgment** for anything a program can check. They give the same answer every time.
- **Cap the loop** (a maximum number of rewrite rounds) so a skill can't burn tokens indefinitely.

> **Fits with this kit:** the kit's `skills/` folder uses this layout. Adding `references/` and a checklist is the cheapest upgrade to any skill you build.

---

## 5. Skills, subagents, and hooks: the difference

**Skill vs. subagent comes down to one word: context.**

- A **skill** runs *inside* your current conversation and uses everything already in it.
- A **subagent** starts with a *fresh, separate* context. Use one when you want an opinion that isn't biased by the conversation so far.

The classic case is review. Claude tends to think code it just wrote is good, because it wrote it. A subagent reviewing that code is like a good engineer from another company looking at your pull request. Ask for *"a subagent to check this for bugs and another to check it for security"* and they run in parallel. You can save a subagent definition in the repo (`.claude/agents/`) so your whole team reviews the same way.

For longer builds you can also tell the main model to **orchestrate**: plan and review with the most capable model, hand the legwork to subagents on an efficient model, and send weak work back for another pass.

**Hooks are the only part that's deterministic.** CLAUDE.md and skills are followed most of the time; a hook runs **every** time. Hooks fire before or after a tool is used, for example:

- Before a push: run the tests and a security check, and **block the push** if either fails.
- Before a message goes out: scan for sensitive data (like patient information) and stop it.
- At session start: load the documents every session needs.

Use hooks for rules that truly can't be broken. A small local script costs nothing to run; a hook that launches agents costs tokens every time, so don't over-layer them.

> **Fits with this kit:** the kit ships safety hooks (see the hooks section of the [README](../README.md)). If you have a rule you keep repeating in CLAUDE.md that must *never* be broken, that's a candidate for a hook.

---

## A one-hour starter routine

1. Make sure each active project has a root CLAUDE.md with a **workspace map** (`/init` if it doesn't). 10 min
2. Run the **step-count test** on your 3 most-visited areas; add a sub-folder CLAUDE.md where a fresh session needs more than 3 steps. 25 min
3. Pick your most-used skill and add `references/good`, `references/bad`, and a `checklist.md`. 15 min
4. Write down your one never-break rule and ask Claude to turn it into a hook. 10 min

---

*Credit again to JJ and Tenex for the material in this primer. Any mistakes in summarizing it are ours.*
