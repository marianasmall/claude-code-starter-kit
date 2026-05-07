# CLAUDE.md — blog-post-pipeline

> Project-specific instructions. Overrides apply only when working in this directory.

## What this project is

A personal blog automation. Drafts blog posts from rough notes, runs an editor pass, outputs to drafts/ for my review, then publishes to a Hugo + Netlify site.

The pipeline is for one user (me). Don't generalize. Don't add config flags for hypothetical other users.

## Conventions specific to this project

- **All drafts** live in `drafts/` until I move them to `published/` manually
- **Inbox files** are .md with no front matter — front matter gets added at the publish step
- **Prompts** are versioned (`editor-v1.md`, `editor-v2.md`, etc.) — never edit a previous version, always bump and create a new one
- **Voice samples** in `voice-samples/` are reference material for tone-matching — never auto-edit them, they're ground truth
- **`inbox/`** is the only directory the n8n watcher should touch. Don't write there from Claude Code.

## Don't do

- Don't run the humanizer skill directly on drafts — the editor pass already invokes it. Running both = over-flattens voice.
- Don't add publishing automation that bypasses the `drafts/` review step. The 30-second human checkpoint is a feature, not a bottleneck.
- Don't suggest "let me add tests" for prompts — prompts aren't tested with code, they're tested by reading the output. Suggest reading three recent drafts instead.
- Don't reformat my existing drafts when I open them. They're in flight; the formatting is intentional.

## When stuck

- Read `PLANNING.md` for current state and decisions made
- Read `CONTEXT-SUMMARY.md` for the immediate next action
- Read `prompts/editor-v3.md` to see the current editor pass logic
- Read `voice-samples/` to understand what tone we're matching
- The Hugo site lives at `~/Sites/blog/` (not in this repo) — only relevant for the publish step
