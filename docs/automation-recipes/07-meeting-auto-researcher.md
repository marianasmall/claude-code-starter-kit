# Meeting auto-researcher

Walk into your next external meeting already knowing who's in the room. This recipe finds the meeting on your calendar, researches the people and companies attending, and hands you a one-page prep sheet before you sit down.

## What you get

A one-pager covering who each attendee is, what their company does, any recent news, a likely agenda, three talking points, and three questions worth asking.

> **Attendee:** VP of Marketing at the company you're meeting. Their company just raised a Series B and is expanding into retail.
> **Likely agenda:** Scoping a Q4 partnership.
> **Talking points:** Reference their retail expansion; mention a comparable case study of your own; ask about timeline pressure from the raise.
> **Questions:** What does success look like for them by year-end? Who else is involved in the decision? What's the budget range?

## What you need

Calendar connected is the main requirement, so Claude can find your next external meeting and see who's on it. This is the same connection used in [recipe 1, the daily morning brief](01-morning-brief.md). If that's set up, you're covered here too.

Nothing else needs connecting. Web search is built in, so there's no separate setup for the research part.

Claude decides "external" by comparing attendee email domains to your own. If your calendar entries don't include attendee emails, or the meeting has no attendee list at all, just describe who's coming and skip straight to the starter prompt below.

## Build it

1. **Ask Claude to find the meeting.** Say something like "find my next external meeting." Claude checks your calendar and identifies the next one that isn't just an internal team meeting.
2. **Run the starter prompt**, confirming the meeting if Claude asks which one you meant.
3. **Read the prep sheet before the meeting, and verify anything you plan to actually rely on.** See the caution below before you walk in and repeat something wrong.
4. **Ask follow-up questions if a detail matters.** "Dig deeper on their funding round" or "what's their competitor doing" both work as quick add-ons once you've seen the first pass.

```
Look at my calendar and find my next external meeting — one with people
outside my own company or team.

For each attendee:
- Who they are and what they do
- What their company does, and any recent news about it
- Anything relevant they've said or posted publicly, if you can find it

Then give me:
- A likely agenda for the meeting
- 3 talking points I could bring up
- 3 questions worth asking

Keep it to one page — I want a quick prep read, not a dossier.
```

**A caution worth taking seriously:** this is a starting point, not a fact sheet. Web research can be wrong or out of date, and it's especially easy for it to mix up your attendee with someone else who happens to share their name. The "recent news" it finds might be about a different person entirely, at a different company. Skim for anything specific enough to matter, a title, a number, a deal, a quote, and check it before you repeat it out loud in the room.

## Make it stick

- **Set it on a schedule.** `/schedule` this to run every morning, checking for any external meetings that day and sending you prep ahead of time. Tell Claude the time you want it to check.
- **Save it as a slash command.** Create `.claude/commands/meeting-prep.md` with the starter prompt as its contents. Before any external meeting, type `/meeting-prep` for a fresh sheet.
- **Just keep this file.** Ask Claude to "run my meeting researcher" before a call. No setup needed.

## Variations

- **Internal meetings too.** Drop "external" from the prompt if you want prep before any meeting, including ones with your own team. Useful before a big internal review.
- **Company-only version.** If you don't need attendee bios, just want the company context, ask for "just the company research, skip individual bios."
- **Shorter or longer.** Ask for "just the 3 questions, nothing else" when you're short on time, or "go deeper on the company's recent funding and competitors" when the meeting really matters.
- **Pair with the evening brief.** Ask [recipe 5, the daily evening brief](05-evening-brief.md) to flag tomorrow's external meetings as part of your top 3, so meeting prep doesn't sneak up on you.
- **Save it to a file instead of just reading it.** If you want the prep sheet somewhere you can pull up on your phone in the elevator, ask Claude to save it to a file as well as showing it to you.
