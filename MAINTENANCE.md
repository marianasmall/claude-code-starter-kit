# MAINTENANCE.md — Claude Code Starter Kit

**Site:** [claude-code-starter-kit.netlify.app](https://claude-code-starter-kit.netlify.app)
**Stack:** React 19 + Vite 7 + Tailwind 4 + TypeScript
**Source of truth:** `src/App.tsx` (single-component SPA — `src/index.css` + `src/main.tsx` for shell)
**Status:** Public-facing, indexed. Used as a Claude Code onboarding entry point for marketing executives, prospects, and Mariana's consulting referrals.

> Pattern replicated from the Anthropic Stack site MAINTENANCE.md (2026-04-28). Same five-section structure, adapted for this audience and stack.

---

## 1. Audience boundary

**Built for:** marketing executives, marketing leaders, and adjacent senior operators who are evaluating Claude Code or just starting with it. People who already know they want to use AI in their work, but haven't installed a CLI tool before. The title bar says it explicitly: *"Claude Code Starter Kit — For Marketing Executives."*

**Not built for:**
- Developers / engineers (they have the official Claude Code docs)
- Power users (hooks, plugins, MCP server authoring belong in deeper material)
- AI-curious general audiences with no specific use case
- Consumers who only need Claude.ai chat, not the CLI

**The audience filter for every proposed update:** *Would a marketing executive who hasn't installed Claude Code yet, or just installed it last week, need this to take their next step?* If no, skip.

---

## 2. Update triggers — what touches this site, what doesn't

**Triggers an update:**
- Claude Code install/setup flow changes (sign-in URL, command name, package manager, OS-level requirements)
- New foundational features a starter user *needs* to know (initial slash commands, what `/init` does, basic CLAUDE.md patterns, simple hooks)
- Pricing or plan-tier changes that affect who can start (Pro/Max requirements, Team gates, free-tier eligibility)
- URL changes for canonical Anthropic resources linked from the kit (docs, signup, support, GitHub repo)
- Major UI changes in Claude Code that would mismatch screenshots or instructions, if any

**Does NOT trigger an update:**
- Power-user features (custom hooks beyond examples, plugin authoring, MCP server building, agent-team patterns)
- Model bumps that don't change behavior for starters (Opus 4.7 → 4.8 unless onboarding flow shifts)
- Niche or edge-case capabilities
- Anthropic platform releases unrelated to Claude Code (Managed Agents, Cowork, Labs releases that don't change the CLI experience)
- New connectors and integrations unless they're prominently surfaced in the onboarding flow
- Internal infrastructure changes, deprecations of obscure features

**When in doubt, ask:** *Does this change what a brand-new user does in their first hour with Claude Code?* If no, skip.

---

## 3. Voice register guardrail

**Register:** Onboarding / tutorial. Action-led, not commentary. "You can do X" / "Try this next" / "Here's what to expect" — *not* "Anthropic shipped X" or "the platform now supports Y."

**Test before any addition:**
- Does it tell the reader what to do, or what Anthropic did?
- Would a busy marketing executive who's about to close the tab read this and feel they got value?
- Does it match the existing tutorial cadence in `App.tsx`, or does it sound like release notes pasted in?

If it reads like an announcement, rewrite or skip. The site exists to help someone start — keep the verbs in the second person.

---

## 4. Calendar-as-checkpoint

**Use case:** This site is a referral surface. Mariana sends prospects, course participants, and curious LinkedIn contacts to it.

**Pre-referral window (anytime you're about to point a prospect or audience at the URL):** open the live site, click through the full flow once, verify nothing is stale before the link goes out. No new content without a need.

**Post-referral window (after a wave of new traffic, e.g., a LinkedIn post links it, or Amy's group sees it):** open for reasoned changes. Roll in feedback, tighten any passages that confused readers, fix anything that aged badly.

**Track high-traffic moments:** if a new wave is coming (a podcast mention, a post, a teaching session), refresh proactively. The site's value is "first impression for marketing executives," and stale content during a wave loses prospects.

---

## 5. Notion ↔ Code canonical direction

**`src/App.tsx` is canonical.** Edits land here first. The deployed site is built from this file via Vite. There is no working-source version of the content elsewhere.

**Known mirror:** Google Drive `Claude Outputs/Website - Claude Code Starter Kit.html` — historical export. Not a working source. **Drift exists** between the Drive copy and the live site (per project memory). Either re-export from `App.tsx` after meaningful changes, or stop maintaining the Drive copy and remove it from circulation. Pick one.

**No Notion source.** Unlike the Stack site, this content originated in code, not in Notion. If draft text is ever needed, draft it in a scratch markdown file in the repo, not in Notion — keep the source of truth singular.

---

## 6. Verification protocol — primary sources

Before any factual claim ships, verify against the source list below. Order is reweighted vs. the Stack site because this site is Claude Code-specific.

**Primary sources (use first, in this order):**
1. **Claude Code changelog** — [github.com/anthropics/claude-code/blob/main/CHANGELOG.md](https://github.com/anthropics/claude-code/blob/main/CHANGELOG.md) — *the* authoritative source for Claude Code releases, behavior changes, new flags, retired commands
2. **Claude Code docs** — [code.claude.com/docs/en/overview](https://code.claude.com/docs/en/overview) — feature documentation, install paths, command reference
3. **Anthropic news index** — [anthropic.com/news](https://www.anthropic.com/news) — top-line product announcements that may affect onboarding
4. **Claude support / help center** — [support.claude.com](https://support.claude.com) — consumer-facing details, plan tiers, billing
5. **Platform release notes** — [platform.claude.com/docs/en/release-notes/overview](https://platform.claude.com/docs/en/release-notes/overview) — broader Anthropic platform context if a release crosses CLI and platform
6. **Anthropic engineering blog** — [anthropic.com/engineering](https://www.anthropic.com/engineering) — architectural posts, useful for design context (rare for starter audience)

**If a fact can't be verified in primary sources:** drop it. No customer metrics or anecdotes without traceable sources.

---

## How to use this file when refreshing the site

1. Read this file top-to-bottom.
2. Re-read the audience boundary (Section 1) with the proposed change in mind. Pass or skip.
3. Check the trigger taxonomy (Section 2). Pass or skip.
4. Check the calendar (Section 4). Are we in a referral window?
5. Verify against primary sources (Section 6). No claim ships unverified.
6. Edit `src/App.tsx`. Match existing component patterns and Tailwind utility classes; do not introduce new design language or component structure.
7. `npm run build` locally and spot-check the production build before deploy.
8. Deploy via Netlify CLI: `netlify deploy --prod --dir dist --site 412b4e1c-b4d2-4377-859f-133e3dd2633e --message "<change summary>"`.
9. Optional: re-export to the Drive HTML mirror if keeping that copy live.

---

## Known gaps to address (not blocking)

- **No README.md** at repo root. A short one (what this is, who it's for, how to deploy) would help future maintainers.
- **`package.json` metadata thin:** no description, no keywords, no author. Cosmetic but worth populating.
- **Drive HTML mirror drift** — see Section 5. Decide whether to keep that mirror or retire it.

---

## Change log

- **2026-04-28** — File created. Pattern replicated from `phase-1/preview/MAINTENANCE.md` in the `ia-before-ai` repo (created the same day during the Anthropic Stack site freshness pass). Adapted for marketing-executive audience, React/Vite/Tailwind stack, and Claude Code-first verification hierarchy.
