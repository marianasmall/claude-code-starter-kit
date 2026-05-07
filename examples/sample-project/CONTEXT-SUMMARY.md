# blog-post-pipeline — Context Summary

**Status:** 🟡 Active. Drafting works; editor pass needs tone tuning.
**Last touched:** 2026-04-29
**Next action:** Add 5 more reference samples to `voice-samples/` and re-run editor on the last 3 drafts to compare quality.

## What's going on right now

Just finished iterating on `prompts/editor-v3.md`. The pass is removing AI tells but it's also removing some of my voice (em-dash usage, colon-mid-sentence). Current hypothesis: not enough reference voice samples — the tone-matcher needs more signal. Next session: add samples + re-run editor pass on `drafts/2026-04-28-pipeline-thoughts.md` and `drafts/2026-04-29-bone-broth.md` to compare before/after.

## Files in flight

- `prompts/editor-v3.md` — Last edited yesterday. Version-bumped from v2 because the changes were significant. Don't touch v2 — keeping it for comparison.
- `drafts/2026-04-29-bone-broth.md` — Latest draft. Demonstrates the over-correction problem clearly. Use this as the test case for editor improvements.
- `voice-samples/` — Has 3 samples. Need at least 5 more before next editor run.

## Notes for Claude

- The humanizer skill is being invoked through the editor pass — *don't* run humanizer directly on drafts (it'll get applied twice and over-flatten the voice).
- I'm tone-matching against my own writing, not generic "good blog" writing. Style should feel direct, ADHD-rhythm (variable sentence length, frequent em-dashes), occasional informal-formal switching. Avoid: tricolons, hedging openers, "in essence," "delve."
- The Hugo site uses front matter with `date`, `slug`, `draft`, `tags`. Drafts in this repo *don't* have front matter yet — that gets added at the publish step.
