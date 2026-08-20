# Scoped iMessage Access Primer

Give Claude Code access to your work texts without opening your whole message history. The pattern: a group (or account) in the macOS Contacts app becomes the permission. Whoever is in it is visible to Claude; everyone else doesn't exist.

## The problem

Claude gets much more useful when it can see real context: the thread where a delivery date was confirmed, the text with the address you need. But macOS permissions for Messages are all-or-nothing: Full Disk Access exposes the entire `chat.db`, which holds every conversation on the machine. Family, doctors, everything. That's the wrong trade, so most people never make it.

The OS can't scope this for you. The scoping has to live in how the reader is built.

## The pattern

1. **Put your work contacts in one place in Contacts.app.** A group (File > New Group, drag people in) works; if your work contacts already live under a separate account (a work Google account, a company CardDAV account), that account is an even cleaner boundary. Contacts merges iCloud and Google sources, so one group can cover both.

2. **Have Claude Code build a read-only reader that derives its allowlist from that group.** The prompt that matters:

   > Build a read-only iMessage reader. Derive the allowlist from my [group/account name] in Contacts, and build it so it *cannot* return anything outside that list. Work from a copy of chat.db — the live file is locked while Messages is open. Include a self-test.

3. **Two ground rules**, stated up front:
   - **Read-only**: no send capability exists in the code at all. Not "doesn't send" but *can't send*.
   - **Draft-only replies** (if you want replies): the tool may open Messages with recipient and text prefilled, but you press send.

4. **Verify before trusting it.** Ask for a thread with someone in the group; it should come back. Ask for a **real** personal contact; it should come back empty. A test only proves what it was written to prove, so use a real personal contact, not a made-up name.

## Why a Contacts group instead of a hardcoded list

The group *is* the permission. Add someone and Claude can see that conversation; remove them and access is gone. No config file to edit, no list maintained in two places, no code change when the team changes.

## Traps a real build hit

These came out of an actual build of this pattern. Expect your own build to meet them:

- **Contact-store discovery can pick the wrong source.** If work colleagues also exist in your personal iCloud contacts, ranking candidate stores by raw match count can tie-break wrong. Rank by *density* (work-domain matches as a share of the store) and refuse to pin a store below a clear threshold.
- **A passing scope test doesn't mean the reader works.** In one build, all boundary checks passed while every message body came back empty: the text lived in `attributedBody`, an old NeXT-era serialization, not the plain `text` column. Test that you get actual message text, not just the right thread list.
- **The live `chat.db` locks while Messages is open.** Work from a copy.
- **macOS TCC permission is per-application, not per-profile.** If you run multiple Claude Code profiles (work/personal) from the same binary, an OS-level grant made on one side applies to both. The separation is a convention honored in the code, not an OS sandbox, which is exactly why the reader must be structurally unable to return out-of-scope results.

## Scale of the win

In the build that produced this primer, the reader could see 26 of 3,425 conversations on the machine: the work threads. Personal messages sit in data the tool never opens.
