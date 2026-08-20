# Scoped iMessage Access Primer

Give Claude Code access to your work texts without opening your whole message history. The pattern: a group (or account) in the macOS Contacts app becomes the permission. Whoever is in it is visible to Claude; everyone else doesn't exist.

This guide is written to be handed to a Claude Code session directly: paste its URL and say "read this, then build what it describes for my [list/label name] contacts." Everything a fresh session needs — the build spec, the safety rules, the known traps, the verification protocol — is below.

## Prerequisites (the human does these, not Claude)

- **A Mac, signed into Messages.** The message database (`chat.db`) only exists on Apple devices.
- **Full Disk Access for your terminal.** Reading `chat.db` requires it: System Settings > Privacy & Security > Full Disk Access > enable your terminal app, then restart the terminal. This grant is all-or-nothing at the OS level — which is exactly why everything below insists the scoping be structural in the code.
- **Your work contacts gathered in one place** in Contacts (step 1 below).

## The problem

Claude gets much more useful when it can see real context: the thread where a delivery date was confirmed, the text with the address you need. But macOS permissions for Messages are all-or-nothing: Full Disk Access exposes the entire `chat.db`, which holds every conversation on the machine. Family, doctors, everything. That's the wrong trade, so most people never make it.

The OS can't scope this for you. The scoping has to live in how the reader is built.

## The pattern

1. **Put your work contacts in one place.** Any of these works as the permission source: a list in Contacts.app (File > New List; older macOS calls it a group), a [label in your work Google contacts](https://support.google.com/contacts/answer/30970), or — cleanest of all — a separate work account (a work Google account, a company CardDAV account) if your work contacts already live under one. Contacts.app merges iCloud and Google sources, so any of them is visible to a reader on the Mac. Multiple lists work too: the allowlist can be the union of several lists or labels (e.g., two brands' contact lists), as long as each is named explicitly.

2. **Have Claude Code build a read-only reader that derives its allowlist from that group.** The prompt that matters:

   > Build a read-only iMessage reader. Derive the allowlist from my [group/account name] in Contacts, and build it so it *cannot* return anything outside that list. Work from a copy of chat.db — the live file is locked while Messages is open. Include a self-test.

3. **One hard rule, stated up front: it never sends.** No send capability exists in the code at all — not "doesn't send" but *can't send*. Drafting, by contrast, is fine by default: the tool may open Messages with recipient and text prefilled, and you press send. There are three ways to put text into Messages and only one is safe: AppleScript genuinely *sends* — it has no draft concept, `send` is its only verb and it delivers instantly (disqualified outright); GUI keystroke scripting is one stray Return away from sending; the `imessage:`/`sms:` URL scheme with a `body` parameter opens a compose window prefilled, with no automation permissions and no send verb anywhere in the chain. Use the URL scheme — there is no code path in it that *can* deliver, even if called wrongly — and test it against a deliberately fake number so nothing can reach a real person.

4. **Verify before trusting it.** Ask for a thread with someone in the group; it should come back. Ask for a **real** personal contact; it should come back empty. A test only proves what it was written to prove, so use a real personal contact, not a made-up name.

## Why a Contacts list instead of a hardcoded allowlist

The list *is* the permission. Add someone and Claude can see that conversation; remove them and access is gone. No config file to edit, no list maintained in two places, no code change when the team changes.

The deeper principle: **make the scope structural, not a filter.** Personal messages shouldn't be filtered out of results — they should live in data the tool never opens. A filter can have a bug; a query that never selects the column, a file that never gets opened, cannot. There's no filter to get wrong.

## Not on a Mac?

The texts part requires one: iMessage's database only exists on Apple devices, so on Windows there is nothing to read. The pattern itself isn't Mac-bound — the same work-contacts label can scope a reader for email or calendar instead. Same prompt shape, same structural-scope requirement, same verification step.

## Traps a real build hit

These came out of an actual build of this pattern. Expect your own build to meet them:

- **Contact-store discovery can pick the wrong source.** If work colleagues also exist in your personal iCloud contacts, ranking candidate stores by raw match count can tie-break wrong. Rank by *density* (work-domain matches as a share of the store) and refuse to pin a store below a clear threshold.
- **A passing scope test doesn't mean the reader works.** In one build, all boundary checks passed while every message body came back empty: the text lived in `attributedBody`, an old NeXT-era serialization, not the plain `text` column. Containing nothing is trivially "in scope" — scope tests prove the boundary and say nothing about whether the data is real. Make every self-test fail loudly on an empty result.
- **The live `chat.db` locks while Messages is open.** Work from a copy.
- **macOS TCC permission is per-application, not per-profile.** If you run multiple Claude Code profiles (work/personal) from the same binary, an OS-level grant made on one side applies to both. The separation is a convention honored in the code, not an OS sandbox, which is exactly why the reader must be structurally unable to return out-of-scope results.

## Scale of the win

In the build that produced this primer, the reader could see 26 of 3,425 conversations on the machine: the work threads. Personal messages sit in data the tool never opens.
