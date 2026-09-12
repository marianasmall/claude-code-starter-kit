# Plaud Recordings Primer

Let Claude read what your Plaud voice recorder captured. Two minutes of clicking gives claude.ai (and Claude Code, on the same account) every recording, transcript and AI note in your Plaud account. An optional second part turns that into a permanent, searchable archive in your Drive.

This guide is written to be handed to a Claude session directly: paste its URL and say "read this, then set it up for me." Part 1 is clicks only, no code. Part 2 is a build spec for Claude Code.

## Prerequisites (the human does these, not Claude)

- **A Plaud account with the device paired to it.** Recordings land in whichever account the device is claimed by. If you inherited a device from someone else, they unpair it from their account first (Plaud refuses to pair a device to a second account while the first still claims it), then you pair it fresh. Confirm with a ten-second test recording that shows up under your login, not theirs.
- **Cloud Sync on** in the Plaud app. The connector reads the cloud, not the device.
- **A Claude account.** Free, Pro and Max users add the connector themselves. On **Team and Enterprise plans an Owner has to enable Plaud first** (Organization settings > Connectors), after which each member connects with their own Plaud login. Nothing happens for members until the Owner step is done.

## Part 1: connect Plaud to claude.ai (about two minutes)

Plaud has been an official connector in Claude's directory since September 2026, so there is no server URL to type.

1. In claude.ai, open the left sidebar and go to **Customize > Connectors**.
2. Search for **Plaud** (listed as "Plaud Web MCP") and click **Connect**.
3. A Plaud authorization page opens. Sign in with the Plaud account the device is paired to.
4. Verify, non-optional: ask Claude **"List my recent Plaud recordings."** You should see your newest recordings by name and date. An empty list means the device is paired to a different Plaud account or Cloud Sync is off.

The connection follows your Claude account: it works in the desktop app, on your phone, and in Claude Code with nothing extra to install. In Claude Code, `/mcp` shows Plaud with a check mark once it has carried over.

## What Claude can do once it is connected

The connector exposes a small read-only toolkit. In plain language, Claude can:

- **Find recordings** by name, keyword or date range.
- **Read the full transcript**, with speaker labels and timestamps.
- **Read Plaud's AI note**: summary, action items, key topics.
- **Hand you the audio** as a download link that lasts 24 hours.

It cannot delete, rename or record anything. What that unlocks is the questions you actually have:

- "Summarize yesterday's meeting and list who owes what."
- "Which recordings this month mention the renovation budget?"
- "What did I promise Alex on Tuesday? Quote the timestamp."
- "Draft a follow-up email to everyone in Thursday's call."
- Cross-reference with other connectors you already have: "check my calendar for the date we agreed on in that recording."

**The habit that makes this pay: talk to the assistant while you record.** Say instructions out loud with a consistent prefix, "for Claude: remind me to send the deck," "note to the bots: the supplier's name was Ortega." Later, ask Claude to find everything you said with that prefix. These are the highest-value lines in any recording because they are explicit instructions rather than inferences, and they are usually twenty words long, so nothing that ranks by length will find them. A consistent prefix does.

## Part 2 (optional): a permanent archive with Claude Code

The connector answers questions; it does not keep anything. If you want every recording as a text file in your own Drive, searchable forever and safe from a lapsed Plaud subscription, have Claude Code build an exporter.

### Tools

Two official packages from Plaud (maintainer on the plaud.ai domain; check `npm view @plaud-ai/cli maintainers` yourself if you like):

```bash
npm install -g @plaud-ai/cli        # bulk access: `plaud login`, `plaud files`, transcript fetches
npx -y @plaud-ai/mcp@latest install   # only if you want a LOCAL MCP server instead of the claude.ai connector
```

The CLI keeps its own login token, separate from the connector's. Remember that: it matters below.

### The build spec (paste this to Claude Code)

> Build a read-only exporter for my Plaud recordings. For every recording, write the transcript and the AI note to `<my synced Drive folder>/Plaud/`, one file per recording named `<date> <title>`, and keep a `manifest.json` as the source of truth for what has been exported. Rules: idempotent (an existing non-empty file is never re-fetched, and nothing is ever deleted or overwritten); write to the Drive-for-desktop folder on disk, not through the Drive API; group recordings by `serial_number`, because the API exposes no device or model field; stamp each file with a provenance header saying which transcript variant it holds. Then schedule it weekly with a failure alarm that reports the gap between the newest recording in Plaud and the newest file archived, not just the script's own exit code.

### Known traps (each one has cost someone weeks)

- **The CLI token expires silently, and the connector's token is separate.** Reading Plaud fine in Claude proves nothing about whether the export can run. The only honest health check is "newest recording in Plaud vs. newest file in the archive."
- **Schedulers do not run like your terminal.** A launchd or cron job starts with a minimal PATH (Homebrew is not on it) and without your terminal's file permissions (on macOS, a scheduled shell cannot touch the synced Drive folder under `~/Library/CloudStorage` until that binary has Full Disk Access). The job "succeeds" with zero new files and the alarm, which reads the same folder, has nothing to compare. Use full paths to the CLI, grant the permission, and make a run that archives nothing for two weeks page you.
- **Two transcript variants.** Plaud's "polished" transcript is the only one carrying the speaker names you assign in the app, but it is AI-cleaned and paraphrased. Export polished for reading; fetch the raw variant when exact wording matters; never quote polished text as verbatim.
- **Proper nouns get mangled** in noisy rooms (a real example: a bar called Death & Company came out as "definitelycompany"). Keep a corrections list and re-apply it after every export, because Plaud freezes names into a transcript at generation time.
- **Folders and tags you build in the Plaud app are invisible to the API.** They cannot drive routing. Route by recording id.
- **A wearable records everything**: medical appointments, legal calls, salary conversations, family. If any of the archive is shared (a company Drive), route by recording id with an allow-list for the shared destination, never by title (titles change), and decide the ambiguous cases by hand. A sensitive file on a shared drive is not retractable.

### Handing a device to someone else

Unpair it from your Plaud account first, have them pair it to theirs, and have them make a test recording to confirm which account it lands in. Anything the device recorded but had not yet synced will upload to whichever account it is paired to at the moment it syncs, so do the unpair after the device has finished syncing, not before.

## Verification checklist

- [ ] "List my recent Plaud recordings" returns your newest recordings under your own login.
- [ ] A transcript request returns speaker labels and timestamps.
- [ ] (Part 2) The archive folder holds one file per recording and a manifest; running the exporter twice adds nothing the second time.
- [ ] (Part 2) The scheduled run has produced at least one new file on its own, from the scheduler, not from your terminal.

## Make it yours

Everything above is one way to run it. Tell your Claude what to change, whether that is the file layout or the prefix you use for spoken instructions, and it will rebuild any of this to fit how you work.
