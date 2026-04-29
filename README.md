# Claude Code Starter Kit

An interactive onboarding guide to Claude Code, written for marketing executives and senior operators who want to use AI in their work but haven't installed a CLI tool before.

**Live site:** [claude-code-starter-kit.netlify.app](https://claude-code-starter-kit.netlify.app)

## Who this is for

Marketing leaders, senior operators, and adjacent professionals who:

- Already understand the value of AI and want to go beyond the chat window
- Have not installed a CLI tool before
- Are evaluating Claude Code or just got started with it
- Need a guided first hour, not a reference manual

If you're a developer, the [official Claude Code documentation](https://code.claude.com/docs/en/overview) is the better starting point.

## Stack

- **React 19** + **TypeScript** for the UI
- **Vite 7** for build and dev tooling
- **Tailwind 4** (Vite plugin) for styling
- **Netlify** for hosting
- Single-component SPA — content lives in `src/App.tsx`
- Build output is a single self-contained HTML file (assets inlined via Vite's `assetsInlineLimit`)

## Local development

```bash
npm install
npm run dev      # starts the Vite dev server with HMR
npm run build    # produces the production build in dist/
npm run preview  # serves the production build locally
```

## Deploy

Production deploys go to the `claude-code-starter-kit` Netlify site (ID `412b4e1c-b4d2-4377-859f-133e3dd2633e`). Direct deploy via Netlify CLI:

```bash
npm run build
netlify deploy --prod --dir dist --site 412b4e1c-b4d2-4377-859f-133e3dd2633e --message "<change summary>"
```

For draft preview deploys (recommended before any production deploy), drop the `--prod` flag.

## What changes, and what doesn't

This site is in maintenance mode, not active development. **Before editing anything, read [`MAINTENANCE.md`](./MAINTENANCE.md).** It defines:

- Who the site is for (and explicitly who it's *not* for)
- Which Anthropic releases trigger an update, and which don't
- Voice register guardrails (tutorial, not platform commentary)
- Verification protocol (Claude Code changelog is Tier 1 source)

If a proposed change doesn't pass the audience filter or the trigger taxonomy, it doesn't ship.

## Repository

- **GitHub:** [marianasmall/site-claude-starter-kit](https://github.com/marianasmall/site-claude-starter-kit)
- **Netlify site name:** `claude-code-starter-kit` (unchanged from original repo name)

## Author

Built by [Mariana Small](https://resonantgrowth.com) ([ResonantGrowth Consulting](https://resonantgrowth.com)). Built in collaboration with Claude (Anthropic).

## License

ISC.
