# Inbox unsubscribe sweep

A scan through your inbox for the newsletters and promotional senders piling up unread, ranked by how often they email you and how little you ever open them. You get the hit list; you decide what to unsubscribe from.

## What you get

A ranked hit list: sender name, how often they email you, and a quick read on why they look ignorable. Something like "14 emails in the last 2 months, none opened" or "weekly newsletter, last one you opened was in June." You work down the list and unsubscribe from whichever ones you agree with. Nothing gets deleted, unsubscribed, or touched until you do it.

**Claude makes the list; the reader clicks unsubscribe themselves.** This one doesn't take bulk action on your mailbox in any form. No mass-deleting, no automated unsubscribe clicking, nothing sent on your behalf. Unsubscribe links inside promotional and spam emails can be malicious — some exist just to confirm your address is active and worth targeting more — so when you do unsubscribe, use Gmail's own **Unsubscribe** button next to the sender name at the top of the message. That one's safe. A link buried in the body of the email itself is the one to skip, even if it also says "unsubscribe."

## What you need

- **Gmail connected to Claude.** If you haven't set this up yet, look for Gmail among your connector or integration settings. Connecting it prompts you to sign in the same way you would on a new device. [Recipe 1, the morning brief](01-morning-brief.md), walks through this same connection if you want the fuller setup.
- Nothing else required. No calendar, no other accounts, no extra setup once Gmail is connected.
- One limit worth knowing: Claude can only see what your Gmail account can see. It won't find anything already filtered out of your inbox or living in a folder you don't have access to.
- A sense of how far back to look. A month or two is enough for a first pass. If your inbox has years of buildup, a wider window catches patterns a single month would miss.

## Build it

1. **Ask for the scan**, using the starter prompt below. Give it a time window — the last month or two is usually enough to see a real pattern.
2. **Read the ranked list.** For each sender, Claude will show how often they email and a quick reason it looks skippable: high volume with no signs you've opened them, or a steady drip you've clearly stopped reading.
3. **Decide sender by sender.** Some of these you'll agree with instantly. Others might be worth keeping even if you rarely open them. Say so, and ask Claude to leave a note not to flag that sender again.
4. **If a sender doesn't ring a bell at all**, don't unsubscribe blind. Ask Claude to pull the subject lines and sender address first — occasionally something that looks like a random newsletter is actually a service tied to an old account you'd rather not lose access to.
5. **Unsubscribe yourself, using Gmail's own Unsubscribe button** next to the sender's name at the top of the email, not a link inside the email body. That's the one Gmail has already vetted as safe. Links inside the message itself, especially from unfamiliar senders, aren't something to click on Claude's say-so or your own.

```
Look through my inbox for the last [1-2 months] and find senders
who email frequently — newsletters, promotions, marketing lists —
where I don't seem to be engaging with what they send.

For each one, give me:
1. Sender name
2. How often they email me
3. A quick read on why they look ignorable (never opened, opened
   once a while ago and not since, etc.)

Rank the list by how confident you are that I don't want these
anymore. Don't unsubscribe, delete, or take any action — just give
me the list so I can go through it myself.
```

6. If the list comes back too broad, narrow it: "just the ones emailing more than twice a week" or "skip anything I've opened at least once in the last month."
7. If you're unsure about a sender, ask Claude to pull up the subject lines of their last few emails. That's usually enough to jog your memory on whether you actually want them gone.

## Make it stick

- **Keep it manual.** Ask Claude to "run my inbox sweep" whenever your inbox starts feeling cluttered again.
- **Turn it into a slash command.** Save the prompt above as `.claude/commands/inbox-sweep.md`. Typing `/inbox-sweep` gets you a fresh list without retyping anything.
- **Schedule a recurring reminder.** Inboxes don't clean themselves — use `/schedule` to set up a quarterly cloud reminder nudging you to run the sweep again, since new newsletters and promotional lists tend to creep back in over a few months.

## Variations

- **Paper trail version.** If a sender might matter later (a receipt-heavy retailer, a service you use occasionally), ask Claude to suggest archiving instead of unsubscribing — the emails stop cluttering your inbox but you can still search for them if you need one.
- **Quarterly re-run habit.** Ask Claude to note which senders you kept last time, so a repeat sweep skips re-flagging the ones you already decided to keep.
- **Filter suggestions for keepers.** For senders you want to keep receiving but don't want cluttering your inbox, ask Claude to draft Gmail filter suggestions — for example, skip the inbox and apply a label — that you can create yourself in Gmail's filter settings. Claude drafts the suggestion; you create the filter.
- **Narrower sweep.** If the full inbox feels like too much at once, ask Claude to start with just one category — "just newsletters" or "just retail promotions" — and expand from there.
- **Cross-check with the subscription audit.** If you're also using [recipe 12, the subscription audit](12-subscription-audit.md), ask Claude to flag any inbox sender that matches a paid subscription on that list — a signal you're paying for something you're not even opening the emails for.
- **One-time deep clean.** First time doing this and your inbox goes back years? Widen the window to 6-12 months so the ranking reflects a real long-term pattern, not just a quiet month.
- **Two inboxes.** If you keep separate personal and work accounts, run the sweep on each one separately. The senders and patterns look different enough between them that combining the two just muddies the ranking.
