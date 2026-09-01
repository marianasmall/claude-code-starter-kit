# Explain this letter

Drop any intimidating document on Claude — an insurance explanation of benefits, a rate-change notice from your utility, a clause in a lease, a letter from a government agency — and get back what it actually says in plain language, instead of rereading paragraph three for the fourth time trying to figure out if you owe money.

## What you get

- **What it actually says.** The plain-language version: no insurance-speak, no legal boilerplate, no jargon you have to look up.
- **What it means for you.** Does this cost you money? Change something? Or is it routine, nothing you need to act on?
- **What you need to do, and by when.** Any deadline gets spelled out as an actual date, not "within 30 days of receipt."
- **What's safe to ignore.** The standard disclosure language every document like this includes, separate from anything specific to your situation.

## What you need

- Nothing connected. Claude Code reads PDFs and photos of letters natively, so there's no email setup, scanner integration, or upload portal to configure.
- The document itself, saved somewhere Claude can reach it: a downloaded PDF, a clear photo of a paper letter, or a scan from a home printer. Any of those works.
- No coding knowledge needed.

## Build it

1. Get the document into a file Claude can read: save the PDF, or take a clear photo of a paper letter (good lighting, the whole page in frame, held flat so nothing's cut off).
2. Tell Claude where it is, or paste the text directly if it's short. Starter prompt:

```
Here's a document I need help understanding: [file path, or paste the
text below]

Explain it in plain language:
1. What does this actually say?
2. What does it mean for me? Does it cost me anything, change
   anything, or require anything from me?
3. What do I need to do, and by when? Give me actual dates, not
   "within 30 days."
4. What's boilerplate I can safely ignore?

Keep it plain-language, and assume I don't know this industry's jargon.
```

3. **Read the explanation, but verify anything that matters before you act. Claude's explanation is orientation, not professional advice.** For anything with real legal, medical, or financial stakes, check the deadline and the dollar amounts against the document itself, and loop in a professional (your agent, a lawyer, your accountant) before deciding anything based on the summary alone. And if the document contains someone else's private information, like a family member on your policy or a co-signer on a lease, don't paste it anywhere you wouldn't want that information stored.
4. If something still doesn't make sense, ask a follow-up right in the same conversation: "why would they deny this claim" or "what happens if I miss this deadline." Claude still has the document in context, so it doesn't need to be re-explained.
5. Decide what to do with the explanation: act on the deadline, file it away, or draft a reply (see Variations below).

## Make it stick

- **Keep it manual.** Save this file, and when a letter or notice like this lands, say "decode this document" and hand it the file or a photo.
- **Turn it into a slash command.** Create `.claude/commands/decode.md`:

  ```markdown
  ---
  name: decode
  description: Explain an intimidating document in plain language, what it says, what it means, what to do, what to ignore
  argument-hint: "[path to document]"
  ---

  Here's a document I need help understanding: $ARGUMENTS

  Explain it in plain language: what it actually says, what it means
  for me, what I need to do and by when (actual dates, not "within
  30 days"), and what's boilerplate I can ignore.
  ```

  Then `/decode ~/Documents/letters/insurance-eob-sept.pdf` runs the whole thing on any document.
- **If the same kind of document shows up on a predictable schedule** (a quarterly HOA notice, open enrollment paperwork every fall), use `/schedule` to set yourself a reminder around when it usually arrives. Claude still needs the actual file handed to it each time; this just makes sure you don't forget to ask.

## Variations

- **Recurring bills comparison.** Save last month's version of a bill next to this month's and ask "is this higher than last time, and why?" Utilities and insurers both like to bury increases in a document that otherwise looks identical.
- **Translate it.** If the document, or your preferred language, isn't English, ask Claude to translate the explanation rather than just the document. A plain-language translation is more useful than a literal one.
- **Draft the reply.** If the letter wants a response (disputing a charge, appealing a decision, confirming a benefits election), ask Claude to draft the reply letter or email, then review and send it yourself.
- **Keep a decoded-documents folder.** Ask Claude to save each explanation alongside the original, so six months from now you, an accountant, or a lawyer can find both the document and what it meant without rereading the original cold.
