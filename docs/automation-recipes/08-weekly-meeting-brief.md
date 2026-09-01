# Weekly meeting brief

Turn next week's calendar into one brief you can read in two minutes — instead of
clicking through ten separate events trying to remember why each one is on there.

## What you get

A single write-up, generated whenever you ask for it (Friday afternoon or Sunday
evening both work well), that walks through every meeting on your calendar for the
coming week:

- **What it's for.** Claude reads the title, the attendees, and any description,
  and infers the purpose. If a title is too cryptic to interpret ("Sync w/ J.T."
  tells nobody anything), it asks you rather than guessing.
- **What to prepare:** a short note per meeting — what to review beforehand, what
  decision you're expected to bring, who else will be in the room.
- **What looks skippable.** Meetings with no clear agenda, meetings you're only
  copied on, anything that looks like it could have been an email.
- **What's double-booked.** Any two meetings at the same time, flagged so you can
  resolve it before Monday instead of during it.

One document instead of fifteen calendar pop-ups.

## What you need

- **Your calendar connected to Claude Code.** Google Calendar or Outlook both
  work — Claude needs read access to see next week's events. If you haven't
  connected a calendar yet, do that first; check Claude Code's connector settings
  for your provider before starting this recipe.
- Nothing else. No transcripts, no other accounts.

## Build it

1. Pick your moment — Friday afternoon looking ahead, or Sunday evening before the
   week starts. Either works; consistency matters more than which one you pick.
2. Ask Claude for the brief. Starting prompt:

```
Look at my calendar for next week (Monday through Friday). For every meeting,
tell me:
- What it's likely about, based on the title, attendees, and any description —
  if a title is too vague to tell, ask me instead of guessing
- What I should prepare or review beforehand
- Whether it looks skippable (no clear agenda, I'm just cc'd, could be an
  email) — and why
- Whether it's double-booked against anything else that week

Group the output by day. Keep each meeting's write-up short — a few lines, not
a paragraph.
```

3. Answer any questions Claude asks about cryptic titles. It's built to ask
   rather than invent a purpose for a meeting it can't identify.
4. Skim the result. For anything that looks genuinely important — a pitch, a
   negotiation, a first meeting with someone new — that's your cue to go deeper.
   [Recipe 7, the meeting auto-researcher](07-meeting-auto-researcher.md), is
   built for exactly that: attendee backgrounds, company context, and talking
   points for the meetings that earn the extra ten minutes.

## Make it stick

- **Save it as a slash command.** Create `.claude/commands/weekly-brief.md`
  (project-level) or `~/.claude/commands/weekly-brief.md` (to use it anywhere)
  with the prompt from step 2 inside it:

  ```markdown
  ---
  name: weekly-brief
  description: Brief me on next week's meetings
  ---

  Look at my calendar for next week (Monday through Friday). For every
  meeting, tell me what it's about, what to prepare, whether it looks
  skippable, and whether it's double-booked. Ask me about any title that's
  too vague to interpret.
  ```

  Then typing `/weekly-brief` runs the whole thing.

- **Put it on a schedule.** Use Claude Code's `/schedule` command to set this up
  as a recurring cloud routine — tell it you want the brief to run every Friday
  afternoon (or Sunday evening) and it handles the recurrence.

- **Or just ask.** No setup at all: keep this recipe file, and next Friday tell
  Claude "run my weekly meeting brief."

## Variations

- **Different lookahead window.** Ask for "the next two weeks" instead of just
  next week if your calendar fills up further out than that.
- **Multiple calendars.** If you have more than one calendar connected, ask
  Claude to check both and merge the results into one brief.
- **Priority ranking, not just a list.** On an unusually packed week, ask Claude
  to rank the meetings by importance instead of listing them in date order.
- **Send it somewhere else.** If you'd rather read this in your email or notes
  app than in Claude Code, ask Claude to draft it there instead of just printing
  it to the chat.
