# blog-post-pipeline

A personal automation that drafts blog posts from rough notes, runs them through an editor pass, and publishes to my static site.

## Why

I have a backlog of "I want to write about this" notes that never become posts because the friction between "rough idea" and "published" is too high. This pipeline closes the gap.

## How it works

1. I dump rough notes into `inbox/<topic-slug>.md` (one file per idea)
2. The pipeline picks up new files in inbox/, drafts a full post via Claude
3. A second Claude pass edits for voice, removes AI tells (humanizer skill), and tightens
4. Output goes to `drafts/` for my review
5. When I approve a draft, it gets moved to `published/` and pushed to my Hugo site

## Stack

- **Drafting + editing:** Claude Code (sonnet, with prompt caching)
- **Orchestration:** n8n workflow watching inbox/
- **Site:** Hugo on Netlify
- **Repo:** This one

## Status

🟡 Active development. Drafting works; editor pass is working but tone-matching needs tuning. Publishing flow is sketched but not wired.

Last meaningful update: 2026-04-29.
