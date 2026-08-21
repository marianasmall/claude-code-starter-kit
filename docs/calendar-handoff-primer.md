# Calendar handoff primer

**What this gives you:** your AI assistant stops ending sessions with "here's what you need to do next" written in a chat you'll never scroll back to, and starts putting those things on your calendar instead — with every link, path, and login you'd need, plus a block you can paste into a fresh chat to pick the work straight back up.

**Time to set up:** about five minutes. You paste one rule into your assistant's instructions.

---

## The problem it solves

Every working session ends with a residue of things only *you* can do. A login-gated edit. An email to send. An approval. A click path in an app your assistant can't reach. Those get written into the conversation as a tidy summary, and then the conversation scrolls away and they are functionally deleted.

Chat is a **pull** surface: it only helps if you remember to go back and look. A calendar is a **push** surface: it comes and finds you. Moving that residue from one to the other is the whole idea.

The second half matters just as much and is easier to miss. When the next action is "keep going on this," a title like "continue the website work" is a mystery in three days. Putting a **paste-ready handoff block inside the calendar event** means your phone is enough to restart the work: open the event, copy the block, paste it into a new chat, and you're back in.

---

## Set it up — pick your surface

The rule is identical on both. Only two things differ: where you paste it, and how your assistant reaches your calendar. Do whichever applies to you, or both.

**Pasting the rule into a single chat will not work.** It has to live somewhere the assistant reads every time, or it applies once and then evaporates.

### On claude.ai (the website)

1. Enable the **Google Calendar connector**: Settings → Connectors. Without it your assistant cannot create anything, and it should say so rather than silently skipping.
2. Paste the rule into **Settings → Profile → custom instructions** so it applies to every chat. To scope it to one body of work instead, paste it into a **Project's** instructions.

### In Claude Code (the terminal app)

1. You need a calendar MCP server connected. If you already have one for Google Calendar or Outlook, you are set. If you have none, your assistant can create events only once one is connected, so start there.
2. Paste the rule into your **`CLAUDE.md`** — the user-level one at `~/.claude/CLAUDE.md` for every project, or a project-level `CLAUDE.md` to scope it to one repo.
3. If you use a session-wrap command, add the sweep to it as well. A skill cannot detect "the session is ending" on its own, so a command you actually run is the only reliable place for the end-of-session sweep. See the note on triggering below.

### A note on triggering, which is the part people get wrong

Per-item capture is the mechanism: the assistant creates an event **the moment** it hits something only you can do. That is reliable, because it is anchored to an event in the conversation.

The end-of-session sweep is only a net, and it is unreliable on its own, because there is no "session ended" signal an assistant can detect. If you want the sweep, hook it to something deterministic: a wrap-up command you run yourself, or a phrase you actually say. Do not rely on "before we finish, sweep back" as the only mechanism, or it will quietly never run.

---

## The rule to install

Paste this into your assistant's persistent instructions.

```
Schedule anything I need to do later.

When we finish something and it ends with an action only I can take (a
login-gated edit, an email to send, an approval, a decision, a click path
in an app you cannot reach), create a calendar event for it right then.
Do not end with "here's what you need to do" in the chat and trust me to
remember it. Chat scrolls away. My calendar comes and finds me.

Before we finish a substantial working session, sweep back through it and
ask: what did we agree I would do that never got an event? Catch the leaks
then.

Every event description must carry the locations. Full file paths, repo
name AND branch, URLs, database or table identifiers, folder names, which
account to sign in as, and where a credential lives (never the credential
itself). Plus the exact change, why it matters, and what it is blocking.

The test: I can act on that event alone, on my phone, weeks later, without
coming back to ask you where anything is.

Three shapes, depending on the kind of action:

- A manual task: literal steps, in order, with every location spelled out.
- Something to send or decide: the actual content, the context I need, and
  the real options to choose between. Never "decide about X" with no
  choices attached.
- Work to pick back up: a paste-ready block, placed LAST in the description
  under a line reading --- PASTE BELOW --- so the copy boundary is obvious
  on a phone. Write it addressed to the next assistant session: what the
  work is, where everything lives, what is done, what is next, what NOT to
  touch, and what it should read first.

Mechanics: check my existing calendar first for collisions and for events
that already cover it. Group related items into one slot rather than
creating six. Default to 15 minutes unless the work genuinely needs longer.
Never send invitations to other people.
```

---

## Why each part is there

**"Right then," not at the end.** Deferring the scheduling to session end means it competes with wrap-up work and gets dropped. The end-of-session sweep is a backstop for leaks, not the primary mechanism.

**Locations are the difference between a reminder and a working instruction.** An event that says "send the deck" without saying where the deck lives is a reminder to go ask your assistant where the deck lives, which is exactly the interruption the calendar event was supposed to replace. Repo *and branch* specifically: work that lives on a feature branch is invisible to someone who opens the repo and sees the default branch.

**Never the credential itself.** Calendar events sync to phones, sometimes to shared devices, occasionally to third-party apps. Say "the password is in 1Password under X." Never paste the password.

**The `--- PASTE BELOW ---` marker.** On a phone, selecting exactly the right block out of a long description is fiddly. An explicit boundary line makes it a single gesture.

**Group, don't spam.** Four events reads as a plan for the morning. Eight reads as noise and gets declined as a batch, taking the important one with it.

---

## Verify it works

Do this once, deliberately, rather than assuming.

1. End a real working session with something genuinely blocked on you.
2. Check that an event appeared, at a sensible time, with no invitations sent.
3. **Open the event on your phone.** This is the actual test. Can you do the thing from what is written there, without opening your laptop and without asking a follow-up question?
4. If it was a resume-work item, copy the paste block into a fresh chat and confirm the assistant picks the thread up without needing to be re-briefed.

If step 3 fails, the rule is installed but the descriptions are too thin. Tell your assistant which specific thing was missing. It will calibrate, and that correction is worth more than any wording you could have specified upfront.

---

## Known traps

- **Duplicate events.** If your assistant schedules during the session *and* sweeps at the end, the same item can land twice. The rule tells it to check existing events first; if duplicates still appear, say so once and it will dedupe against your existing task list as well.
- **The wrong calendar.** If you keep work and personal calendars separate, say which is which in your instructions. Assistants default to your primary calendar.
- **Calendars your assistant cannot see.** Subscribed or shared calendars are sometimes invisible to the connector, so collision checks can miss real conflicts. If you live across several calendars, ask it to check the ones it *can* see and say plainly which it could not.
- **Over-scheduling.** If everything becomes an event, the calendar stops meaning anything. Only things genuinely blocked on you belong there. Work the assistant can do itself should just get done.

---

## Make it yours

The wording above is a starting point, not a specification. Tell your assistant what to change: different time blocks, a different level of detail, a different definition of what deserves an event at all. It will rebuild the rule to fit how you actually work.
