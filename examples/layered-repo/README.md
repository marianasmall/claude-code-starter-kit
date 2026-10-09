# Example: a layered repo

A small imaginary repo (a community events website plus a weekly email) showing how context files stack. Each file holds only what its scope needs, so Claude pays for detail only when it's working where that detail applies.

```
layered-repo/
├── CLAUDE.md                       # Root: loads every session in this repo
├── CLAUDE.local.md.example         # Personal notes; rename to CLAUDE.local.md (gitignored)
├── .gitignore                      # Keeps CLAUDE.local.md out of git
├── .claude/
│   └── rules/
│       └── event-times.md          # Path-scoped: loads only when matching files are opened
└── site/
    └── CLAUDE.md                   # App note: loads when Claude works inside site/
```

## What loads when

| File | Loads | Holds | Doesn't hold |
|---|---|---|---|
| `~/.claude/CLAUDE.md` (yours) | Every session, every repo | How you like to work | Anything about this repo |
| `CLAUDE.md` | Every session in this repo | What this is, where things live, how work ships | Rules true in only one folder |
| `site/CLAUDE.md` | When Claude reads or edits files in `site/` | How to run the site, its conventions | Directory listings, dependency lists |
| `.claude/rules/event-times.md` | When Claude opens a file matching its `paths:` | One narrow rule, with the failure it prevents | Anything needed every session |
| `CLAUDE.local.md` | Every session in this repo, on your machine only | Your personal shortcuts for this repo | Anything teammates need |

## Three tests for where a line goes

1. **Is it true everywhere I work?** User file. Otherwise, keep going.
2. **Is it true only inside one folder?** That folder's CLAUDE.md, not the root.
3. **Does it matter only when a certain kind of file is open?** A rule with `paths:`. A rule *without* `paths:` loads every session, which is rarely what you want.

## Write what Claude can't work out for itself

Claude can read your folders and your `package.json`. It can't read the decision behind them. Spend your lines on decisions, constraints and traps, written specifically enough to check in a diff. "Event times are stored in UTC" can be checked; "be careful with times" can't.

## Check it worked

Start a session in the repo and run `/context`. The **Memory files** list shows what actually loaded. Open a file under `site/src/events/` and run it again: the rule should now appear. If a file isn't listed, Claude can't see it.
