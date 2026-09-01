# Sales meeting debrief

Turn a messy meeting transcript into the four things you actually need afterward:
what got decided, who owes what, what's still open, and a follow-up ready to send.

## What you get

- **Decisions made** during the meeting, stated plainly.
- **Commitments** — who agreed to do what, and by when, for both sides.
- **Open questions** that didn't get resolved on the call.
- **A drafted follow-up email** pulling the above together, ready for you to
  review and send yourself.

## What you need

- **A transcript or notes from the meeting, saved as a file.** Where it came from
  doesn't matter — an export from a meeting recorder app, notes you typed during
  the call, anything with the substance of the conversation in it. Save it
  somewhere Claude can read it, or have it ready to paste directly into the chat
  if it's short.
- Nothing needs to be connected for this one. Claude isn't reaching out to
  anywhere live — it's working from the file you hand it.

## Build it

1. Get the transcript or notes into a file, or copy the text if you'll paste it
   directly.
2. Hand it to Claude and ask for the debrief. Starting prompt:

```
Here's the transcript/notes from today's meeting: [file path, or paste the
content below]

Give me:
1. Decisions that were made
2. Commitments — who agreed to do what, and by when
3. Open questions that weren't resolved
4. A drafted follow-up email summarizing the above, ready for me to review
   and send

Keep the email short and specific — no filler.
```

3. **Read the draft before anything goes anywhere.** This step is not optional.
   Transcripts — especially auto-generated ones — garble names, dollar figures,
   and dates constantly. Check every number, every spelled name, and every date
   against what you actually remember from the call before the email leaves
   your outbox.
4. Send it yourself, from your own email account. Claude drafts; you send —
   that boundary is deliberate, since this is going to a customer or prospect.

## Make it stick

- **Save it as a slash command.** Put the prompt from step 2 into
  `.claude/commands/debrief.md`:

  ```markdown
  ---
  name: debrief
  description: Turn a meeting transcript into decisions, commitments, and a follow-up draft
  argument-hint: "[path to transcript]"
  ---

  Here's the transcript: $ARGUMENTS

  Give me: decisions made, commitments (who owes what, by when), open
  questions, and a drafted follow-up email. Keep the email short and
  specific.
  ```

  Then `/debrief path/to/transcript.txt` runs it on any meeting.

- **Keep the file and ask, meeting by meeting.** This recipe is triggered by a
  transcript existing, not by the clock — the simplest habit is to keep this
  recipe file and tell Claude "run my sales debrief" as soon as a new transcript
  lands.

- **If it's the same meeting every week, schedule it.** For a recurring call —
  a standing pipeline review, a weekly client sync — use `/schedule` to set up a
  routine that runs shortly after that meeting each week. You'll still need to
  get the transcript to Claude somehow (a shared export folder, a paste, wherever
  your recorder drops it) — `/schedule` handles the timing, not the handoff.

## Variations

- **Multiple stakeholders on your side.** Ask Claude to flag which commitments
  are yours versus a teammate's when more than one person from your team was on
  the call.
- **CRM-shaped output.** Ask for the decisions and commitments as a short
  bulleted list formatted for pasting into your CRM's notes field, instead of
  prose.
- **Track a deal over time.** Feed Claude two or three debriefs from the same
  account in one go and ask what's changed meeting over meeting — that surfaces
  a stall a single transcript won't show.
- **Internal-only mode.** If the meeting was internal rather than customer-facing,
  skip the follow-up email and ask for an action-item list assigned to your team
  instead.
