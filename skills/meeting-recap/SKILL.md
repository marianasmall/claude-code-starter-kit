---
name: meeting-recap
description: "Use when a meeting, call, or voice memo needs to become a recap someone will act on. Triggers on 'recap that call', 'write up the meeting', 'send notes from this morning', 'what did we agree with X', 'turn this Plaud/Granola/Fireflies/Wispr recording into an email', or a transcript pasted with 'summarize this'. Not for your own end-of-session summaries."
metadata:
  version: "1.0.0"
---

# Meeting Recap

The output is a draft in the tool it will be sent or kept from, either an email draft or a page in your notes app. Chat gets the three-line TL;DR and where the draft lives, not the full recap.

## Knowledge

- **Sources and their traps.** Use whichever meeting tool you have connected (Fireflies, Granola, Plaud, Wispr Flow, Otter) or a pasted transcript. These traps apply to nearly all of them:
  - **AI-cleaned text is not verbatim.** Many tools tidy the transcript before you see it. Mark any quote taken from cleaned text `(paraphrase)`.
  - **Timestamps are often UTC.** Convert to the user's own time zone before writing any time. Ask once if you do not know it.
  - **Speaker labels and proper nouns can be wrong.** Names get swapped or mangled. Check them against the calendar invite when one is available.
  - **An empty search is not a missing meeting.** If a search returns nothing, try fetching by the meeting ID or link before concluding anything.
  - Pasted text is the sender's version. Attribute it ("per the notes you pasted").
- **Destinations.** A draft in your email tool, a page in your notes app, or a file in the project. Never a sent message. Default when the user does not say: an unsent email draft to the attendees.
- **Format.** Follow whatever email style the user has already told you to use. If they have none, use light formatting: short headers and bullets.
- **Recap shape:** `references/recap-template.md` (eight sections, exact headings).

## Examples

- "Recap this morning's ops call and draft it to the team" → fetch the transcript from the connected tool, fill the recap template, create one email draft with each ask numbered once.
- "Turn my voice memo from the drive home into a note" → transcript, sections 1–3 and 7 only (a memo has no attendees), saved as a page in the notes app, quotes marked paraphrase.
- "What did we agree with the supplier on Tuesday?" → find the meeting for that date, sections 2–3 in chat, and an offer to draft the confirmation email.

## Procedure

1. Identify the source. Ask only if two tools could hold it. Fetch the transcript and the attendee list. Record the tool, the meeting ID, and the date.
2. Name the audience and the destination before writing: who reads this, which account sends it, where it is kept.
3. Write the eight sections into the template. Every action item has a person. Every time is in the user's time zone. Every quote from cleaned text is marked.
4. If any name looks odd, cross-check it against the calendar invite for that date.
5. Produce the artifact: create the email draft once and do not edit it afterward, since editing can break the reply thread in some tools. Or create the page in your notes app. Never call anything that sends mail or messages.
6. Reply in chat with the TL;DR and where the draft is. If anything was unclear in the recording (a decision that sounded tentative, a name that might be wrong), list it under "check before sending".

## Tools

- Transcripts: your meeting tool's connector or export, or text the user pastes.
- Drafts: your email tool's create-draft function, or your notes app's create-page function.
- Calendar cross-check: your calendar's search function, if connected.

If no tool is connected, ask for a pasted transcript and write the recap to a markdown file in the project.

## What this is NOT

- Not a sender. The word "draft" is in every output.
- Not a strategic read: what the user should do about the meeting is a separate ask.
- Not a session summary; those have their own routine.
