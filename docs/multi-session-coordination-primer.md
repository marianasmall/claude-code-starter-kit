# How Claude sessions "see" each other: a multi-session coordination primer

*Written August 2026, from a real two-day build where five-plus Claude Code sessions and a dozen subagents shipped one project without stepping on each other (mostly). Claude Code's features will evolve; the architecture below doesn't depend on any one of them.*

---

## Who this is for

You, if any of these are true:

- You run more than one Claude Code session — parallel terminals today, or a new thread tomorrow that should pick up where the last one stopped
- You've pasted three paragraphs of "here's where we left off" into a fresh session and thought *there has to be a better way*
- You're rolling Claude Code out to a team and need sessions run by *different people* to act like colleagues, not strangers
- A session once redid — or undid — work another session had already finished

That last one is the problem this primer solves. Two sessions editing the same project without coordination don't feel like a team. They feel like two contractors who were never told about each other, meeting in your kitchen at 2am, each convinced the other is an intruder. (This actually happened to us. Both contractors were polite about it. It still cost an evening.)

## The one idea everything else hangs on

**Claude sessions share no memory. They share a filing cabinet.**

A session knows exactly three kinds of things: what's in its own conversation, what it reads from disk, and what Claude Code itself hands it. There is no backchannel where session A whispers to session B. When your setup *feels* like sessions are aware of each other, what's actually happening is:

1. Session A **wrote something down** in an agreed place
2. Session B **read it** — at startup, or mid-session when Claude Code's built-in change notices flagged that a file it had open was modified by someone else

That's the whole trick. Anthropic built the mail slot (file loading at startup, change notices mid-session, subagent messaging). **You have to build the paperwork**: the agreed places and the habit of writing to them. Without your layer, the mail slot delivers nothing worth reading. With it, sessions can hand work forward across days and between people.

## The five surfaces

You need surprisingly few files. Each has one job and one reader-moment:

| Surface | One job | Read when |
|---|---|---|
| `active-context.md` (one per setup) | "What's going on across everything right now" | Injected/read at every session start |
| `<project>/handoff.md` (one per project) | "Cold-start this project: state, traps, next action" | When a session picks up that project |
| Dispatch file (written on demand) | The literal first message to paste into a new thread | Once, to start a successor session |
| A ledger (one per long-running job) | Append-only progress log: what's done, what's decided, what's parked | Before resuming or repeating any step |
| Session log (Notion, a wiki, anywhere searchable) | The durable archive: what happened, what was decided, where artifacts live | When someone asks "when did we…?" |

Three design rules that make them work:

- **Newest state on top, and mark the cutoff.** Long files rot into archaeology. Keep a "must-know" block at the top and a marker line below it; everything under the marker is history. A session should get current in one screenful.
- **Replace, don't accumulate.** `handoff.md` holds only the *latest* handoff. History lives in the searchable archive, not the working file.
- **Point, don't duplicate.** The handoff says *where* the checklist lives; it doesn't copy it. Duplicated state is state that will contradict itself by Thursday.

## The three rituals

Surfaces without rituals become graveyards: write-only files nobody reads. (Our project *started* because a weekly report had been auto-filed to an unread folder for three months. Then, mid-build, we found the automation's own log had been silently broken for eleven weeks. Same disease everywhere: a surface with no read-ritual is a place information goes to die.)

**1. Refresh on state change, not on schedule.** When something meaningful shifts (a phase completes, a blocker lands, a decision gets made), update the handoff *then*, mid-session. If the session dies five minutes later, the paperwork already reflects reality. End-of-session wrap-up is the backstop, not the plan.

**2. Wrap every session.** A closing ritual that updates the surfaces and logs the archive entry. Ours checks for same-day entries first so parallel sessions don't file duplicate reports — steal that detail; you'll need it the first day you run two sessions at once.

**3. Dispatch instead of re-explaining.** When work should continue in a fresh session, have the *current* session write the successor's first message: what's done, what to read (paths, in order), the first action to take, and the traps. Human's job shrinks to copy-paste. The written dispatch beats a verbal summary every time, because the session that writes it still has the details you'd forget.

## What the built-in layer does (so you don't rebuild it)

Claude Code natively gives you three things. Don't rebuild them; aim them:

- **Startup loading:** `CLAUDE.md` and memory files load automatically. Your job is keeping what's in them current and small.
- **Mid-session change notices:** if a file the session has touched gets modified externally, the session is shown the diff. This is why shared files beat side channels — edits to them are *pushed* to whoever's active. Your job is making the shared files the place where news happens.
- **Subagent messaging:** agents one session spawns report back to it. This does *not* cross to sibling sessions — siblings coordinate only through the cabinet.

## Failure modes we hit so you don't have to

- **The 2am contractors.** A worker session stalled; a replacement was dispatched; the original woke later and re-did the task in parallel — then read its teammate's legitimate commits as sabotage and filed a security incident. Root cause: nobody *wrote down* that the first worker was off the job. Rule: **record a termination before hiring a replacement.** In any shared workspace, an un-communicated staffing change becomes someone's conspiracy theory.
- **Docs that lie.** A repo's own README-level docs froze at day-one state while six commits changed everything, so any fresh reader got a false picture. Rule: the surface a newcomer reads first is the one that must never go stale — update it in the same breath as the work, and have reviews *check* it.
- **The unread inbox.** Any surface without a read-ritual is a graveyard, no matter how good the writing is. Before adding a surface, name the moment it gets read. Can't name one? Don't create it.
- **Trust, but timestamp.** Two sessions once disagreed about repo state; both were "right" — one's reading was three minutes stale. When sessions conflict, check *when* each looked before deciding *who* is wrong.

## Start small: the two-file version

All of the above scales down. Day one, you need exactly two habits:

1. A `handoff.md` in your project: current state on top, next action, traps. Update it when things change.
2. End sessions by asking Claude to refresh it and — when work continues elsewhere — to write the dispatch message for the next thread.

Everything else (ledgers, archives, wrap rituals, parallel-session dedup) earns its place when the pain shows up. It will. Add the surface *with* its ritual, and your sessions stop being strangers.

## Name tags: telling sessions apart at a glance

All the coordination above assumes you can tell which terminal window is which session — and by the fifth tab, you can't. Claude Code already names every session (it auto-generates a title from your first prompt; override it anytime with `/rename`), and it hands that name to your statusline script on every refresh. The kit's bundled statusline (`examples/statusline.sh`) does two things with it: shows the name at the front of the status bar, and writes it into the terminal tab title. Your tab bar becomes a list of conversations instead of a row of identical windows. One file, no new habits — the names were always there; this just puts them where your eyes are.

## Why this matters beyond one person

Nothing above is actually about Claude. It's information architecture: agreed places, honest state, read-rituals, explicit handoffs. Which means it scales from one person's laptop to a team's shared repos without changing shape — a colleague's session reads the same handoff yours does. The AI was always capable of collaborating; the architecture is what turns capability into a team. Structure first, intelligence second.
