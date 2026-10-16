# Never lose a project

**What this gives you:** every project you run with Claude can be picked up cold, by you, by a fresh Claude session, or by a different AI tool, without anyone re-explaining it. You stop losing the thread between sessions, you stop re-making decisions you already made, and the things only you can do land on your calendar instead of in a chat you'll never scroll back to.

**Time to set up:** about ten minutes per project. Faster if you start from the [template repo](#set-it-up) or run `/kit:scaffold-project`.

**Replaces:** the older five-file layout (README, PLANNING, CONTEXT-SUMMARY, project-local CLAUDE.md, handoff) that earlier versions of this kit taught. See [What changed from the five-file layout](#what-changed-from-the-five-file-layout) if you already use it.

---

## The problem it solves

A project lives across many sessions, and each session starts with an assistant that remembers nothing. The usual failure is gradual: the first gap costs you five minutes of re-explaining, the third costs you a decision you already made and now make differently, and by the tenth the project quietly dies because restarting it feels like work.

The fix is to keep the project's memory **in the project folder**, in a few plain files with one job each, and to run the same short loop at the end of every session so those files stay true. Nothing here is clever. The value is that it's the same in every project, so neither you nor Claude has to think about where anything is.

Three ideas carry the whole system:

1. **Every fact has one home.** What the project is, what was decided, and where you left off each live in a different file, and only there.
2. **State gets saved before it can evaporate.** At the end of a session, and before you compact a long one, the current state goes to disk first.
3. **Anything only you can do goes on your calendar.** Chat scrolls away. A calendar comes and finds you.

---

## Part 1: the project package

Every project meant to last starts with the same set of files at its root.

| File | Its one job | Who reads it | When to start it |
|---|---|---|---|
| `README.md` | What this is and how to use it, in plain language | Humans landing cold | Day one |
| `AGENTS.md` | Everything an AI needs to brief itself on this project | Any AI model | Day one |
| `CLAUDE.md` | One line that loads `AGENTS.md` into Claude Code | Claude Code | Day one (copy it, never edit it much) |
| `PLANNING.md` | Goal, scope, roadmap, current state | You and Claude | Once the project is past a sketch |
| `decisions.md` | What was decided, why, and what was rejected | You and Claude, before any big change | The first time you make a real choice |
| `handoff.md` | Where the last session stopped and how to restart | The next session | After your first working session |
| `_private/` | Sensitive notes that stay on your machine | You only | The first time you have something you wouldn't publish |

Two optional add-ons, only when their trigger applies:

| File | Add it when | Its one job |
|---|---|---|
| `BULLETIN.md` | Two or more AI tools work the same project (for example Claude Code plus a research assistant, or two Claude seats) | A shared message board, so the tools coordinate through the repo instead of through you copy-pasting |
| `docs/instructions-for-[you].md` | A non-technical owner drives the project | Your whole ritual in plain words: the one command to open it, what to say, what you never need to do |

Small or throwaway folders can skip all of this. The package is for anything you expect to come back to.

### README.md: the human door

Written for a person who has never seen the project. What it is, who it's for, where to start. Keep it light and keep the AI instructions out of it; those go in `AGENTS.md`. Two readers, two doors.

### AGENTS.md and the one-line CLAUDE.md: the machine door

`AGENTS.md` is the "don't make me re-explain" file. Many AI coding tools look for a file by that name, so writing your context there means any of them can self-brief. It answers, briefly:

- what this project is and what it produces
- where things live
- the rules a newcomer must know before changing anything (rules you can check, like "prices are always shown with tax included," not vibes like "be careful")
- how work is submitted and what "done" means
- who's who, and known traps

Claude Code automatically loads a file called `CLAUDE.md`, so the package includes a `CLAUDE.md` whose only real content is `@AGENTS.md`. That `@` line tells Claude Code to pull `AGENTS.md` in at the start of every session. One source of truth, every tool covered.

Keep `AGENTS.md` short: well under 200 lines. It's re-read on every turn, so every line costs you a little every time. Narrow detail that only matters for certain files belongs in `.claude/rules/` files that load only when those files are opened (see the [layering primer](claude-md-layering-and-context-primer.md)). Include a `# Compact instructions` section in `CLAUDE.md` saying what to keep when a long session gets compacted.

### PLANNING.md: the map

Goal, what's in and out of scope, the roadmap as a checklist, and a short "current state" paragraph. It changes when the plan changes, not every session. Session-by-session detail goes in `handoff.md`, not here.

### decisions.md: so you never re-argue a settled question

An append-only log. Each decision gets a number (`D-1`, `D-2`, ...) so you and Claude can refer to it in one token: "that's settled by D-7." Newest at the top. Every row records **why**, and every row records **what you rejected and why**. The rejected option is the part people skip and the part that pays off, because three weeks later the rejected idea will come back sounding fresh.

Two sections work well:

- **Locked:** decided, do not reopen without a new reason.
- **Open:** questions still pending, each with an owner and a date it should be settled by.

Tell Claude in `AGENTS.md` to read `decisions.md` before any structural change and to add a row in the same session a decision lands, not later.

### handoff.md: where you left off

The file the next session reads first. It works like a stack of notes with the newest on top:

- Each session adds a short **top block**: date and time, what got done, what's mid-flight, what's waiting on you, the next action, and what not to touch.
- The top block ends with a **paste-ready prompt** under a `--- PASTE BELOW ---` line. Copy it into a new session and the work resumes.
- Older blocks slide down under an "Earlier sessions" heading. Prune it to the last few; the full history is in git and in your session summaries.

Why newest-on-top instead of replacing the file each time: a session that ends badly (a crash, a forgotten wrap-up) leaves the previous block intact, and the next session can see the last two or three steps of the trail, not just the last one.

### _private/: the drawer that stays home

A folder for anything you wouldn't publish: notes about people, raw research with personal details, drafts with real figures. The package's `.gitignore` lists `_private/`, so git skips it and it won't be pushed to GitHub by a normal commit.

Be clear about what that does and doesn't do. It is a filing rule, not encryption. Anyone or anything with access to your computer can still read the folder, a forced `git add` can still commit it, and if the project lives inside a synced cloud folder, the sync service copies it like any other file. The ignore rule also only covers files git isn't already tracking: if anything in `_private/` was committed before you added the rule, run `git rm -r --cached _private/` once to stop tracking it (the files stay on your disk, but they remain in the repo's history).

One more boundary: `handoff.md` and `decisions.md` are committed on purpose, so they travel with the repo. If the repo is public, or shared with people who shouldn't see everything, keep names and sensitive detail out of those two files and put it in `_private/` instead. Treat `_private/` as "not for the repo," and keep real secrets (passwords, API keys) in a password manager, never in any project file.

---

## Part 2: the session-continuity loop

The files only help if they stay true. One short loop keeps them that way.

```
  start ──▶ work ──▶ decisions land ──▶ wrap up ──▶ (long session?) compact
    ▲         │            │                │                    │
    │         │      add a D-row now   1. session summary        │
    │         │                        2. handoff top block      │
    │   things only you can do         3. decisions check        │
    │   ──▶ calendar event, now        4. commit                 │
    │                                  5. calendar sweep         │
    └──────────── next session: "pick up the handoff" ◀──────────┘
```

### During the session

- **A decision lands → add a row to `decisions.md` right then.** Including the rejected option.
- **Something only you can do comes up** (a login-gated edit, an email to send, an approval, a call) → it goes on your calendar right then, with every link and location written into the event. The [calendar handoff primer](calendar-handoff-primer.md) has the rule to install and the shapes those events should take. Per-item capture is the mechanism; the end-of-session sweep is only the net.

### At the end of the session

Run `/kit:session-end`. It does these in order:

**1. Session summary.** Written to your session log (`~/.claude/session-summaries.md` by default, or a notes database if you've connected one). Always the same fields:

| Field | What goes in it |
|---|---|
| What was done | The main tasks, and what changed (files created, edited, moved) |
| Decisions | Each choice with its reasoning and the option rejected, plus its D-number |
| Open loops | Anything owed, by whom, by when, including what's waiting on you |
| Next steps | The first concrete action for next time |
| Where state lives | The project folder, the branch, and the files that hold the current truth |
| Transcript | The path to this session's transcript, so detail can be recovered later |

**2. Handoff top block.** A new block at the top of `handoff.md`, ending in the paste-ready prompt.

**3. Decisions check.** Any decision from this session without a numbered row in `decisions.md` gets one now.

**4. Commit.** So the state is in git, not only on disk.

**5. Calendar sweep.** Anything agreed that never got an event gets one now (when a calendar tool is connected; otherwise the report lists those items so you can schedule them yourself).

### Save state, THEN compact

Long sessions fill up. When that happens Claude Code compacts the conversation: it replaces the full history with a summary, and anything not in that summary is gone. If you wait for it to happen automatically, it happens at an arbitrary moment, mid-thought.

So pick a clean breakpoint yourself, at roughly a quarter to a third of your context left:

1. **Save state first.** Run `/kit:handoff` (or the full `/kit:session-end`) so `handoff.md` and `decisions.md` are current and committed.
2. **Then compact with a focus line**, which tells the summary what must survive:

```
/compact Keep: the bakery site menu-page work on branch menu-page-2026-03-12, open Q-3 (prices), the owner owes allergen sign-off (calendar Fri), and the rule to never publish allergen claims without the owner's sign-off. Drop: the font-comparison tool output.
```

Never compact before state is saved. If the summary drops something, the files still have it.

### Starting the next session

Open the project folder and say "pick up the handoff," or paste the block from under `--- PASTE BELOW ---`. Claude reads `AGENTS.md` (loaded automatically), then `handoff.md`, and continues. If you've lost track of which project you were in, the session summary names it.

---

## Part 3: big builds, plan first, then hand tasks to subagents

Some jobs are too big for one session to hold in its head: more than three or four files, several decisions that depend on each other, or more than about half an hour of focused work. For those, don't start building. Plan first.

1. **Write the plan to disk.** A plan document in the project (for example `docs/plans/2026-03-12-menu-page-plan.md`) that breaks the job into small numbered tasks, each with what "done" looks like.
2. **Keep a progress ledger next to it** (`docs/plans/2026-03-12-menu-page-PROGRESS.md`): one line per task, its status, the commit it landed in, and anything a reviewer flagged. The ledger is what survives a crash or a compaction. A new session reads it and knows exactly which task is next.
3. **One fresh subagent per task to build it, and a separate fresh subagent to review it.** A subagent is a helper session Claude launches with a clean slate. Fresh context matters: an implementer that has been working for hours carries assumptions; a new one reads only the plan and the task. The reviewer's job is to try to break the work, not to admire it. Fix what it finds, then re-review just that part.
4. **The main session coordinates and doesn't build.** It hands out tasks, reads results, updates the ledger. That keeps its own context clean for the whole build.
5. **Match the model to the job.** Use your most capable model for design judgment and the final review of the whole build; a lighter, cheaper one is usually enough for a well-specified task.

If you use the community **Superpowers** plugin, its `writing-plans` and `subagent-driven-development` skills run this pattern for you. You can also just ask: "write a plan with a progress ledger, then run it with a fresh implementer and reviewer per task."

When to skip it: small fixes, one-file edits, anything you'd describe as "quick." The overhead is worth it only when the job is genuinely big.

---

## Part 4: naming

### Repo and project-folder names

All lowercase, words joined with hyphens, a short category prefix up front so related folders sort together when you browse:

| Prefix | Use it for | Example |
|---|---|---|
| `project-` | Active initiatives | `project-spring-launch` |
| `client-` | One folder per client engagement | `client-hollow-oak-bakery` |
| `site-` | Deployed websites | `site-portfolio` |
| `app-` | Standalone applications | `app-recipe-scaler` |
| `config-` | Your Claude Code setup, skills, automations | `config-my-skills` |
| `brand-` | Your business brand and methodology | `brand-studio` |
| `ref-` | Reference material, not active work | `ref-style-guide` |
| `archive-` | Finished or abandoned work | `archive-old-blog` |

When a `project-` ends, rename it `archive-` rather than deleting it.

**Check before you create.** Before making a new repo or folder, list what already exists (`gh repo list` for GitHub, or just look in your projects folder). Duplicates are how a project ends up split across two places with half its history in each.

### File names inside a project

Pick one pattern and stick to it. Consistency matters more than which one you pick.

| Pattern | Good for | Example |
|---|---|---|
| Topic first, date last | Knowledge work, consulting, research | `Bakery_Menu_Pricing-Notes_2026-03-12.md` |
| Date first | Journals, daily logs | `2026-03-12_Bakery_Menu-Notes.md` |
| All lowercase with hyphens | Code, web content, anything in a URL | `bakery-menu-pricing-2026-03-12.md` |

If unsure, start with topic-first. Then add one line to your user-level `CLAUDE.md` so Claude names files the same way:

> **File naming:** Use topic-first format `[Topic]_[Subtopic]_[Description]_YYYY-MM-DD.ext` for anything I save in my projects.

Adopting a convention mid-project? Apply it going forward. Don't bulk-rename old files unless findability is actually broken.

---

## Worked example: a made-up bakery website

Everything below is fictional. "Hollow Oak Bakery" is an imaginary neighborhood bakery getting a simple website: a home page, a menu page, and an order-ahead form. It shows the texture of real entries, which empty templates can't.

### decisions.md

```markdown
# Decisions: client-hollow-oak-bakery

> Append-only. Newest at top. Read before any structural change. Do not reopen
> a Locked row without a new reason, and say what the new reason is.

## Locked

| # | Date | Decision | Why | Rejected |
|---|---|---|---|---|
| D-9 | 2026-03-12 | Menu photos are the owner's own phone photos, shot on the shop counter. | Real bread sells better than stock; the owner already has 40+ usable shots. | Stock photography (looks generic, licensing to track). Hiring a photographer (owner said "not this year"). |
| D-8 | 2026-03-10 | Order-ahead uses a simple form that emails the shop, not a payment system. | The shop takes payment at pickup today and wants to keep it that way for launch. | Online checkout (fees, refunds, more to maintain). Revisit after 3 months of order volume. |
| D-7 | 2026-03-08 | Allergen information appears on the menu page only after the owner signs off on each item, in writing. | Wrong allergen info is a safety problem, not a typo. | Copying allergen notes from the old printed menu (it is two years out of date). |

## Open

| # | Question | Owner | Settle by |
|---|---|---|---|
| Q-3 | Show prices on the menu page, or "ask in store"? | Owner | 2026-03-19 |
```

### handoff.md, top block

```markdown
# Handoff: client-hollow-oak-bakery

> **▶ 2026-03-12 4:40 PM. READ THIS FIRST.**
> - **Done:** home page copy final; menu page layout built on branch `menu-page-2026-03-12` (commit a1b2c3d), photos placed per D-9.
> - **Mid-flight:** order-ahead form (D-8) is wired but untested; test send goes to our own inbox, not the shop's.
> - **Waiting on the owner:** price decision (Q-3) and allergen sign-off for 6 items (D-7). Both on the calendar for Fri 3/13, with the item list in the event.
> - **Next:** test the form end to end, then open a pull request for the menu page.
> - **Don't touch:** allergen lines stay as "pending sign-off" placeholders until D-7 is satisfied.

--- PASTE BELOW ---

Continuing the Hollow Oak Bakery website in ~/Projects/client-hollow-oak-bakery,
branch menu-page-2026-03-12.

Read first: AGENTS.md (loads automatically), then this handoff, then decisions.md
D-7 to D-9.

State: menu page built, order form wired but untested. Prices and allergen
sign-off are waiting on the owner (calendar, Fri 3/13).

First action: send a test order through the form to our own inbox and confirm
the email arrives with every field. Do not change allergen placeholders.

---

## Earlier sessions

> **2026-03-10 11:15 AM.** Home page copy drafted; D-8 settled (email form, no checkout). Next was the menu layout.
```

### Session summary

```markdown
## 2026-03-12 16:40 — Bakery site: menu page + order form

**What was done:**
- Built the menu page layout with the owner's photos (D-9)
- Wired the order-ahead form to email the shop (D-8); not yet tested
- Files: site/menu.html, site/order.html, site/css/menu.css

**Decisions:**
- D-9: owner's own photos. Rejected stock (generic, licensing) and a hired photographer (owner declined).

**Open loops:**
- Owner owes: price decision (Q-3) and allergen sign-off for 6 items. Calendar, Fri 3/13.
- We owe: end-to-end form test before the pull request.

**Next steps:**
- Test the form, then open the menu-page pull request.

**Where state lives:**
- ~/Projects/client-hollow-oak-bakery, branch menu-page-2026-03-12
- handoff.md (top block), decisions.md (D-7 to D-9, Q-3)

**Transcript:** ~/.claude/projects/<project-folder>/<session-id>.jsonl
```

---

## Set it up

Two ways, same result.

**Start from the template repo.** The companion [project template repository](https://github.com/marianasmall/ref-project-template-public) holds the whole package with placeholder text and these fictional examples. On GitHub, open it and click **Use this template**, name your new repo with the right prefix, then clone it into your projects folder. Fill in the brackets in `README.md`, `AGENTS.md`, and `PLANNING.md`, and delete `BULLETIN.md` if only one AI tool will work the project.

**Or scaffold an existing folder.** Inside the folder, run `/kit:scaffold-project`. It drops in the same files (asking before it touches anything that already exists) and adds `_private/` to `.gitignore`.

Then, once, add this line to `AGENTS.md` under "Rules for this repo" so Claude keeps the loop running without being asked:

> Read `handoff.md` at the start of every session. Add a `decisions.md` row in the same session a decision lands, including the option rejected. At session end, add a new top block to `handoff.md`.

---

## How it fits with the rest of the kit

- **`/kit:session-end`** writes the session summary, adds the handoff top block, checks decisions were logged, offers to commit, and sweeps for anything that should be on your calendar.
- **`/kit:handoff`** adds just the handoff top block, for a mid-session checkpoint or right before you compact.
- **The prompt-context hook** (`user-prompt-context.sh`) shows Claude a short preview of the project's state on every prompt, when you're working inside a git repo. It reads `CONTEXT-SUMMARY.md` if you kept one from the older layout, otherwise `PLANNING.md`. Keep `PLANNING.md`'s "Current state" paragraph near the top so the preview is useful.
- **`/kit:decision`** logs significant cross-project decisions to your personal decision journal. Project-specific decisions belong in that project's `decisions.md`.
- **The calendar rule** from the [calendar handoff primer](calendar-handoff-primer.md) handles everything only you can do.

---

## Known traps

- **Decisions logged "later."** Later means never. The row goes in during the session the decision lands, or it doesn't exist.
- **A handoff with no locations.** "Continue the menu work" is a riddle in three days. Name the folder, the branch, the file, and the first action.
- **Compacting before saving.** The compaction summary is lossy. Save to `handoff.md` first, every time.
- **An `AGENTS.md` that grows into a diary.** It describes the project, not its history. History goes in `handoff.md`, `decisions.md`, and git. If it passes 200 lines, move detail out.
- **A stale `BULLETIN.md`.** An entry open more than two weeks is a smell: close it or escalate it. If only one AI tool works the project, delete the file.
- **Sensitive detail in committed files.** `handoff.md` and `decisions.md` go wherever the repo goes. In a public or widely shared repo, keep names and private detail in `_private/`.
- **Trusting `_private/` as a vault.** It keeps files out of git, nothing more. See the [section above](#_private-the-drawer-that-stays-home).
- **Different structure in every project.** The value is sameness. Resist redesigning the package per project; add an optional file when its trigger applies instead.

---

## What changed from the five-file layout

| Before | Now | Why |
|---|---|---|
| `CONTEXT-SUMMARY.md` dashboard, overwritten each session | Dropped. Current state lives in the `handoff.md` top block and `PLANNING.md` "Current state" | Two files saying "where we are" drift apart. One is enough. |
| Project-local `CLAUDE.md` with full instructions, optional | `AGENTS.md` holds the context; `CLAUDE.md` is a one-line `@AGENTS.md` loader, always present | Other AI tools read `AGENTS.md`; one source covers all of them. |
| Decisions as bullets inside `PLANNING.md` | Their own numbered `decisions.md`, with rejected options | Numbered decisions can be cited in one word, and the rejected column stops relitigating. |
| `handoff.md` replaced every session | Newest top block first, last few kept | A bad session end no longer wipes the trail. |
| No sensitive-material rule | `_private/`, gitignored | A standard place for what doesn't belong in the repo. |

Migrating an existing project: keep your `PLANNING.md`, move its decisions into a new `decisions.md` (number them), move `CLAUDE.md`'s content into `AGENTS.md` and replace it with the one-liner, and fold `CONTEXT-SUMMARY.md` into the first `handoff.md` top block, then delete it (while it exists, the kit's prompt hook previews it instead of `PLANNING.md`). Ten minutes. `examples/sample-project/` still shows the older layout; the fictional bakery above shows the current one.

---

## Appendix: blank templates

`/kit:scaffold-project` uses these. Replace every `[bracket]`.

### README.md

```markdown
# [Project Name]

> One sentence: what this is.

## What this is
[What it holds, who it's for, what it produces.]

## How to use it
[Where to start, what to open first.]

## Key files
| Path | What's there |
|---|---|
| `AGENTS.md` | AI context. Any model reads this first |
| `PLANNING.md` | Goal, scope, roadmap |
| `decisions.md` | Numbered decision log |
| `handoff.md` | Where the last session stopped |
```

### AGENTS.md

```markdown
# AGENTS.md: AI context for [project-name]

> Any AI working in this repo: read this first. Keep it current. When something
> here changes, update it in the same session.

## What this repo is
[2-3 sentences: purpose, what it produces, who uses it.]

## Where things live
[Key files and folders and their jobs.]

## Rules for this repo
- Read `handoff.md` at the start of every session.
- Read `decisions.md` before any structural change. Add a row in the same
  session a decision lands, including the option rejected.
- At session end, add a new top block to `handoff.md`.
- Nothing from `_private/` gets copied into tracked files.
- [Project-specific rules you could check in a diff.]

## How work is submitted
[Branch and commit conventions, who reviews, what "done" means.]

## Who's who
[Roles involved. Roles are enough; skip personal details.]

## Gotchas
[Known traps, stale areas, things that look canonical but aren't.]
```

### CLAUDE.md

```markdown
@AGENTS.md

<!-- This file exists so Claude Code loads AGENTS.md automatically. Keep it tiny. -->

# Compact instructions

When compacting, keep: files changed this session and why; open decisions and
who owns them; the next step from handoff.md; any "don't touch" areas.
Drop: exploratory dead ends and raw tool output.
```

### PLANNING.md

```markdown
# Planning: [project-name]

## Current state
[One short paragraph. Update when the plan changes, not every session.]

## Goal
[What done looks like.]

## Scope
[In. Explicitly out.]

## Roadmap
- [ ] [First milestone]
```

### decisions.md

```markdown
# Decisions: [project-name]

> Append-only. Newest at top. Do not reopen a Locked row without a new reason.

## Locked

| # | Date | Decision | Why | Rejected |
|---|---|---|---|---|
| D-1 | YYYY-MM-DD | [decision] | [reason] | [option passed on, and why] |

## Open

| # | Question | Owner | Settle by |
|---|---|---|---|
| Q-1 | [question] | [who decides] | YYYY-MM-DD |
```

### handoff.md

```markdown
# Handoff: [project-name]

> **▶ YYYY-MM-DD HH:MM. READ THIS FIRST.**
> - **Done:** [what finished, with branch and commit]
> - **Mid-flight:** [what's half done]
> - **Waiting on you:** [what only the owner can do, and when it's on the calendar]
> - **Next:** [the single first action]
> - **Don't touch:** [anything off-limits]

--- PASTE BELOW ---

Continuing [project] in [folder], branch [branch].
Read first: AGENTS.md, this handoff, [other files].
State: [one or two sentences].
First action: [the one thing to do first].

---

## Earlier sessions

> **YYYY-MM-DD HH:MM.** [one-line recap]
```

### .gitignore (add these lines)

```
_private/
CLAUDE.local.md
.env
.env.*
!.env.example
_backups/
.DS_Store
```

`_backups/` matters if you use the kit: its backup hook saves a copy of every file before Claude edits it, including copies of `CLAUDE.local.md` or `.env` files, which would otherwise be committed.
