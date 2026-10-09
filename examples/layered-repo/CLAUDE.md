# CLAUDE.md — community-events

## What this is
The public website and weekly email for a volunteer-run events group. One maintainer, a few occasional contributors. Readers are non-technical; clarity beats cleverness.

## Where things live
| Path | What | Context file |
|---|---|---|
| `site/` | The website (static site generator) | `site/CLAUDE.md` |
| `newsletter/issues/` | One Markdown file per weekly email | none needed |
| `references/` | Sourced facts: venue details, sponsor wording, past attendance | none needed |
| `.claude/rules/` | Narrow rules that load only for matching files | read the rule's `paths:` |

Read the narrowest context file that applies before you change anything.

## How work ships
- Branch per change: `<type>/<short-slug>` (e.g. `event/autumn-picnic`, `fix/broken-map-link`). Never commit to `main`.
- Commit subjects start with a verb and say what changed: "Add autumn picnic page".
- Open a pull request; the hosting service builds a preview link. A human checks the preview before merge.
- A newsletter issue ships only after the maintainer reads the rendered preview. Never send from a branch.

## Don't touch
- `references/sponsors.md` wording is contractual. Quote it exactly or ask.
