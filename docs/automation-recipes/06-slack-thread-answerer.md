# Slack thread answerer

Some threads spiral. Forty messages, three side conversations, and you still don't know what anyone actually needs from you. This recipe reads the whole thing and hands you a summary plus a drafted reply, so you can catch up in a minute instead of scrolling for ten.

## What you get

Two things: a summary of the thread (who wants what, what's already decided, what's still blocked) and a drafted reply in your own voice that responds to it. You read both, edit the reply if it doesn't sound like you, and send it yourself.

> **Summary:** One teammate is asking whether the launch date moves to the 15th. A second already agreed, as long as design signs off. Design hasn't weighed in yet, so that's the blocker.
> **Drafted reply:** "I'm good with the 15th once design confirms. Can whoever owns that give a thumbs up by Thursday?"

That's it. No auto-send, no posting on your behalf. Claude reads and drafts; the send button stays yours.

## What you need

The Slack connection is the only thing to set up. Claude needs to be connected to your Slack workspace before it can read anything there. If you haven't done this yet, look for Slack among your connector or integration settings. Connecting it will prompt you to sign into your workspace, the same way you'd sign into Slack on a new device.

Nothing else is required. No calendar, no email, no extra setup once Slack is connected.

One limit worth knowing: Claude can only read channels and threads you already have access to yourself. It isn't a way to see into a private channel you're not a member of, and it won't get around any permissions your workspace admin has set.

## Build it

1. **Point Claude at the thread.** Paste the Slack link to it, or describe it clearly enough to find. The channel name and roughly what it's about is usually enough.
2. **Ask for the summary first**, using the starter prompt below.
3. **Ask for the drafted reply**, either in the same message or as a follow-up once you've read the summary.
4. **Read it, edit it if it doesn't sound like you, and send it yourself.** Claude drafts; you send, always. Don't wire this up to send automatically, even later, even once you trust it. A reply going out under your name should have your eyes on it first.
5. **If the thread is genuinely huge**, tell Claude how far back to go. "Just the last two days" keeps it from re-summarizing context you've already dealt with.
6. **If the reply needs to cover more than one open question**, say so up front. "This needs to answer both the scheduling question and the one buried further up about budget" gets you a reply that actually covers both, instead of just the most recent message.

```
Read this Slack thread: [paste the link, or describe the channel and
what the thread is about].

Give me:
1. A summary — who wants what, what's already been decided, and what's
   still blocked or unanswered.
2. A drafted reply, in my normal tone, that addresses whatever I still
   need to respond to.

Keep the summary to a few bullets. I'll edit and send the reply myself.
```

## Make it stick

This one's less of a daily habit and more of a "pull it out when a thread gets long" tool, so the mechanisms that fit best are:

- **Save it as a slash command.** Create `.claude/commands/thread-answer.md` and paste the starter prompt in as the contents. Typing `/thread-answer` and pasting a link is faster than retyping the prompt each time.
- **Just keep this file.** Open it when a thread needs untangling and ask Claude to "run my thread answerer" on the link. No setup required.
- A recurring `/schedule` routine doesn't really fit this one. You don't want Claude summarizing threads on a timer; you want it on demand, right when a thread gets out of hand.

## Variations

- **Multiple threads at once.** If you're behind on a few, list all the links in one message and ask for a summary of each, plus one combined list of what still needs a reply from you.
- **Action items only.** If you don't need a drafted reply, just want to know what's expected of you, ask for "just the action items, skip the draft."
- **Different tone for different threads.** Tell Claude to match a more formal tone for a client channel and a looser one for an internal team channel. The draft adjusts accordingly.
- **Combine with the evening brief.** If you're using [recipe 5, the daily evening brief](05-evening-brief.md), ask it to fold in any Slack threads still sitting unanswered as part of your "still open" list.
- **Long-running channels.** For a channel you check often, ask for a standing rule: "always tell me if someone's waiting on me specifically," so a reply aimed at you never slips past the summary.
- **Shorter drafts.** If the reply comes back longer than you'd actually type, say "one or two sentences, no more" and it'll match how you actually write in Slack.
- **A reaction instead of a reply.** Sometimes a thread just needs an acknowledgment, not a message. Ask "should I just react to this instead of replying?" and let Claude make the call.
