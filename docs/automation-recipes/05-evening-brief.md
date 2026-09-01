# Daily evening brief

Close the day the way you might close a legal pad. A quick look back at what got done, what's still hanging open, and what to hit first tomorrow. This recipe gives you that in under a minute, reusing the connections you likely already set up for your morning brief.

## What you get

A short end-of-day summary, always in the same three parts. Something like:

> **Done today:** Client call about the Q3 renewal, sent the revised proposal, cleared the invoice backlog.
> **Still open:** Waiting on legal's sign-off on the contract; haven't replied to the vendor about pricing.
> **Tomorrow's top 3:** 1) Follow up with legal, 2) Prep for the 10am review call, 3) Reply to the vendor.

Short enough to read in the time it takes to close your laptop.

It only covers what it can see through the connections below: your calendar and your sent mail, plus the task list you point it to. It won't know about a conversation that happened over text, or a decision made in a hallway.

## What you need

Calendar and email connections are the first piece. If you've already built [recipe 1, the daily morning brief](01-morning-brief.md), you have these. This recipe reuses the exact same connections, just looking back over today instead of forward into tomorrow. If you haven't built that one yet, start there. The setup is identical, so there's nothing new to configure here.

The second piece is a task list Claude can read. This can be as simple as a single notes file or text document where you jot down what you're working on. It doesn't need structure or special formatting. Claude just needs to know where it lives, so it can check what you marked done and what's still sitting open.

## Build it

1. **Tell Claude where your task list lives.** The first time you run this, say something like "my task list is at [wherever you keep it]." If you want that remembered without repeating yourself, ask Claude to save the location to your project notes. Otherwise just mention it again each time. It takes a few seconds either way.
2. **Run the starter prompt below**, filling in the bracketed part with the actual location of your task list.
3. **Skim the result.** If something's missing, a task you finished that isn't showing as done, or a meeting Claude didn't catch, say so. It'll factor that in going forward.
4. **Adjust the phrasing if it comes back too long or too short.** The prompt below asks for a few bullets per section. If Claude drifts toward paragraphs, just say "shorter, bullets only" and it'll stay that way from then on.

```
Look at my calendar for today and my sent email. Based on what actually
happened:

1. List what got done — meetings that happened, emails I sent, tasks I
   marked complete in [path to your task list].
2. List what's still open — tasks that didn't get finished, anything I
   owe someone a reply on.
3. Propose my top 3 priorities for tomorrow, based on what's open and
   what's already on tomorrow's calendar.

Keep each section to a few bullet points. I want something I can read
in ten seconds, not a report.
```

## Make it stick

Pick whichever of these fits how you actually work.

- **Set it on a schedule.** Ask Claude to `/schedule` this to run automatically every evening. Tell it the time you want, and it runs as a routine in the cloud, even if your computer's off.
- **Save it as a slash command.** Create a file at `.claude/commands/evening-brief.md` (or `~/.claude/commands/evening-brief.md` to use it in every project) and paste the starter prompt in as the file's contents. From then on, typing `/evening-brief` runs the whole thing.
- **Just keep this file.** No setup at all. Open this recipe when you want it, and ask Claude to "run my evening brief." That's a complete, valid way to use every recipe in this series.

## Variations

- **Pair it with the morning brief.** Run [recipe 1](01-morning-brief.md) first thing and this one last thing, and you've got both ends of the day covered with the same two connections.
- **Fold in Slack.** If you're also using [recipe 6, the Slack thread answerer](06-slack-thread-answerer.md), ask Claude to check for anything left unanswered there too, and add it to your "still open" list.
- **Change the count.** "Top 3" is just a default. Ask for your top 1 if you want to force real prioritization, or top 5 on a heavier week.
- **Make it a weekly rollup too.** On Fridays, ask for the same brief but looking back over the whole week instead of just the day. It's a useful Monday-morning refresher on what actually happened.
- **Split done from sent.** If "done" and "sent emails" start blurring together in a busy week, ask Claude to break them into two separate lines instead of one bullet each. Small tweak, easier scan.
- **Add a mood line.** Some people like one extra line at the bottom: "how the day actually felt, in a sentence." Not everyone wants this. Ask for it if you do.
