# Daily morning brief

A short brief waiting for you first thing — today's schedule, the three things that actually matter, and which emails need a reply — instead of opening five tabs and piecing it together yourself.

## What you get

Every morning (or whenever you ask), you get a few short paragraphs: your schedule for the day in order, your top three priorities pulled from that schedule and your inbox, and a list of the emails that actually need a reply from a real person — not newsletters, not automated notices.

Think of it as the few minutes you'd normally spend clicking between your calendar app, your inbox, and maybe a weather site, condensed into one read before you've had coffee.

## What you need

- **Google Calendar and Gmail connected.** In Claude Code, connect both with the `/mcp` command. On claude.ai, turn them on under Settings → Connectors. Either way, this is a one-time setup — once it's done, every recipe that touches your calendar or inbox can use it.
- **A few minutes for that first connection.** The first time you connect Calendar or Gmail, you'll be asked to sign in and approve access in a browser window. After that one-time step, Claude reads what it needs automatically each time you ask.
- **A time zone in mind, if you travel.** Claude uses your calendar's default time zone unless you say otherwise — worth mentioning up front if you're often somewhere else.
- No coding knowledge needed. Once those two are connected, everything below is just a conversation.

## Build it

1. Open Claude Code (or claude.ai) with your calendar and email connected. If either one isn't set up yet, Claude will tell you which is missing rather than quietly skipping that part of the brief — connect it and try again.
2. Paste this prompt as-is, or adjust the bracketed part to fit how you actually want the brief to read:

```
Check my calendar for today and give me a short morning brief:

1. My schedule for today, in order, with times.
2. My top 3 priorities today — pull these from my calendar and from
   anything urgent in my unread email, not just what's on my calendar.
3. Emails that need a reply. Scan my unread email and only flag messages
   from real people I know or am working with — skip newsletters,
   marketing emails, and automated notifications.

Keep it short. I want to be able to read this in under a minute.
```

3. Read what comes back. A good first pass names actual meeting titles and specific senders, not vague counts like "a few meetings" — if it's staying vague, ask it to be concrete. If it includes something that isn't actually a priority, or misses an email you'd expect to see flagged, say so directly — "always include anything from my accountant" or "skip anything from that one recurring newsletter." Claude will remember for next time.
4. Once the brief feels right, decide how you want it to show up each morning — see "Make it stick" below.
5. Ask for it again tomorrow, and the day after. By the third or fourth morning you'll usually know what to tighten — most people end up narrowing the "real people" filter or reordering the three sections to match how they actually think through a day.

## Make it stick

Three ways to make this a daily habit, from least to most automatic:

- **Keep it manual.** Save this file, and each morning open Claude Code and say "run my morning brief." Simple, and you stay in control of exactly when it runs and what's fresh in context when you ask.
- **Turn it into a slash command.** Create a file at `.claude/commands/morning-brief.md` and paste the starter prompt above into it as the file's entire contents. From then on, typing `/morning-brief` in that project runs the whole thing — no copy-pasting required, and no risk of pasting an old version of the prompt by mistake.
- **Schedule it to run automatically.** Use the `/schedule` command to set up a recurring cloud routine — for example, "every weekday at 7am" — so the brief is ready before you sit down, without needing Claude Code open on your computer at all.

## Variations

- **Add weather.** Claude doesn't check the weather by default, so ask it to look one up (or point it at a weather site) and fold the forecast into the brief.
- **Tighten the "real people" filter.** Tell it specific email addresses or domains that should always count as real people, so nothing important slips through, and specific ones that never do, so noise stays out.
- **Send it instead of displaying it.** If you'd rather the brief land somewhere you'll actually see it, ask Claude to email it to you instead of just showing it in the conversation.
- **Pair it with an evening version.** [Recipe 5, the daily evening brief](05-evening-brief.md), is the end-of-day mirror of this one — what got done, what's still open, and what tomorrow looks like.
- **Change the format.** Ask for bullet points instead of paragraphs, or grouped into "must do today" vs. "nice to do."
- **Fold in a task list.** If you keep a separate to-do list somewhere Claude can reach, describe where it lives and ask for a fourth section pulling in anything due today.
- **Weekend version.** Ask for a lighter version on weekends — just the schedule and anything genuinely time-sensitive, skipping the priorities and email sections entirely.
- **A running log.** Ask Claude to save each day's brief to a dated file instead of just displaying it, so you can look back at how a week actually went.
- **Multiple calendars.** If you keep work and personal calendars separate, say which ones to check — Claude checks your primary calendar by default and can miss the rest.
