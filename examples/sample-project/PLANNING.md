# blog-post-pipeline — Planning

## What this is

Personal blog automation. Goal: collapse the gap between "I have an idea worth writing about" and "it's published." Currently the gap is ~3 weeks per idea (procrastination + editing fatigue). Target: 24 hours.

The pipeline is for me only — not a product. So I optimize for *my* voice, *my* decision points, not generality.

## Current state

**Working:**
- Inbox watcher (n8n) detects new .md files in `inbox/`
- Drafting prompt produces decent first drafts (~70% of effort)
- Humanizer pass removes most AI tells
- Output lands in `drafts/` reliably

**In progress:**
- Tone-matching against my reference voice samples — drafts feel "Claude-ish" not "me-ish"
- The editor pass sometimes over-corrects and removes my actual voice quirks (em-dashes, colons mid-sentence)

**Not started:**
- Publishing flow — manual right now (I cp drafts to my Hugo site repo and push)
- Topic clustering — I'd like the inbox watcher to flag related ideas so I can write series, not isolated posts

## Active todos

- [ ] Add 5 more reference samples to `voice-samples/` and re-run editor pass — current 3 samples might not be enough for tone-matching
- [ ] Edit the humanizer skill invocation to *preserve* explicit voice markers (em-dash usage, sentence rhythm). Currently it's too aggressive.
- [ ] Wire publishing: drafts/ → cp to ~/Sites/blog/content/posts/ → git commit + push triggers Netlify build
- [ ] Topic clustering — not yet sure how. Maybe semantic similarity via embeddings? Or just simple keyword overlap?

## Decisions made

- **2026-04-15** — Use Claude Code (not API directly) for drafting. *Why:* I already have a tuned setup with hooks, skills, and the humanizer. Building separate API tooling would be redundant.
- **2026-04-19** — Drafts go to `drafts/` not directly to the live site. *Why:* I want a human-review checkpoint before publishing. Auto-publishing felt like it would lower my quality bar fast. Rejected: full automation. Accepted: 30-second-of-friction checkpoint.
- **2026-04-22** — Use n8n for the watcher, not a custom cron script. *Why:* n8n gives me visual debugging and easy retry logic. Slight overkill for a one-watcher use case but it's already running on my home server.
- **2026-04-29** — Editor pass uses Claude (not a fixed rule-based linter). *Why:* AI tells evolve faster than rule lists can catch up. A static linter would be obsolete in 6 months.

## Open questions

- Should I run the editor pass twice with different prompts, then have Claude pick the better version? Adds cost; might add quality.
- Is there a clean way to detect "this draft sounds like Claude wrote it" automatically? Currently I do this by feel.
- Do I want to publish weekly on a schedule, or just whenever a draft is ready? The schedule creates pressure to ship; the "whenever" lets quality lead.

## Pickup notes

If I'm coming back to this after a long break:

1. Check `n8n` is still running on home server (`systemctl status n8n`)
2. Look at `inbox/` for any unprocessed notes (anything dated >24h ago means watcher is broken)
3. Read the most recent few drafts in `drafts/` to recalibrate on what the pipeline produces
4. Read the latest entry in `voice-samples/` to remember what I'm tone-matching against
5. Editor pass currently uses prompt template at `prompts/editor-v3.md` — note the version, I iterate on this
