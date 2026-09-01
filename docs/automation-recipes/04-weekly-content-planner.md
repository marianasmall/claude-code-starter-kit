# Weekly content planner

Seven days of content mapped out — topic, format, a caption or hook draft, and the best time to post for each day — plus practice refining a first draft instead of just accepting it.

## What you get

A table with one row per day: what to post about, what format it should take, an actual opening line or hook (not just a description of one), and a suggested posting time. You also walk away having sharpened two of the seven entries, which is the real habit this recipe is teaching — the first draft is a starting point, not the plan.

It replaces the Sunday-night scramble of staring at a blank notes app trying to remember what you posted last week.

## What you need

- Nothing connected. This one only needs a description of your audience and the platforms you post to — everything happens in the conversation.
- **A sense of what's coming up.** Any launch, event, or seasonal moment worth building the week around — mention it, or Claude will default to a general mix.
- No coding knowledge needed. The only "setup" is knowing your own niche and audience well enough to describe them in a sentence or two.

## Build it

1. Open Claude Code or claude.ai — no setup required.
2. Paste this prompt, filling in your own details:

```
I need a 7-day content plan for [describe your niche/business, e.g. "a
small-batch coffee roaster" or "a freelance marketing consultant"].

I post on [platforms, e.g. "Instagram and LinkedIn"]. My audience is
[describe them briefly — who they are, what they care about].

For each of the next 7 days, give me:
- The topic or theme
- The format (a Reel, a carousel, a short post, a photo, etc.)
- A hook or caption draft — the actual first line or opening, not just
  a description of what it should say
- A suggested best time to post

Lay it out as a table, one row per day. Save it as
content-plan-week-of-[date].md so I can find it again.
```

3. Read through the week, then pick two entries and get specific about what's wrong with them — "make Wednesday's hook punchier" or "Friday should be a carousel, not a photo — walk me through the slides." This back-and-forth is the part worth practicing.
4. Ask for one more pass on those two entries after your first round of notes, so you can see the difference between a vague note and a specific one — "punchier" versus "open with a question instead of a statement" tend to produce very different rewrites.
5. Once you're happy with it, the saved file is your working plan for the week.
6. Next week, ask Claude to read this file before drafting the new one, so it knows what you already covered and doesn't repeat a topic two weeks in a row.

## Make it stick

- **Keep it manual.** Each week, say "run my weekly content planner" and ask Claude to read last week's saved file first, so it doesn't repeat itself.
- **Turn it into a slash command.** Save the prompt above as `.claude/commands/content-plan.md`, and trigger next week's plan with `/content-plan`.
- **Schedule it.** Use `/schedule` to have a draft plan generated automatically every Sunday evening, ready for you to refine Monday morning instead of starting from a blank page.

## Variations

- **Theme the week.** Center it on a launch, an event, or a seasonal moment instead of your usual mix.
- **Platform-specific versions.** Ask for the same idea written twice — a LinkedIn post and an Instagram caption, each in that platform's voice.
- **Build on last week.** If you tell Claude which posts performed well, ask it to read last week's plan and lean into what worked when drafting the next one.
- **Batch-record day.** Instead of a plan to post from daily, ask for a single script covering all seven pieces so you can record them in one sitting.
- **Longer horizon.** Once the weekly version feels easy, ask for a 30-day version instead, broken into four weekly blocks so it's still easy to scan.
- **A backup list.** Ask for two or three extra topic ideas beyond the seven, so you have something ready if one day's plan falls through.
- **Repurposing.** Once the week is posted, ask Claude to suggest which entries could be reworked into a different format for a platform you don't usually post on.
