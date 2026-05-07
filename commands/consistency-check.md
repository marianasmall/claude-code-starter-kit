---
name: consistency-check
description: Audit a doc bundle for cross-reference integrity, count drift, pronoun ambiguity, audience assumptions, and other issues that erode reader trust. Pre-ship discipline for user-facing docs.
argument-hint: "[path-to-bundle | default: current directory]"
---

# /consistency-check — Pre-Ship Doc Audit

Run a structured cold-read audit on a documentation bundle before it ships. Catches the categories of issues that erode reader trust without being obvious to the author.

## When to use this

- Before merging changes to a public README
- Before delivering a client report or proposal
- Before publishing course material
- Before sharing a starter kit / plugin / tutorial with someone outside the conversation
- After a major restructuring where things may have drifted between sections

**Don't use for:** Quick edits to a single file, work-in-progress drafts, internal notes.

## Workflow

### 1. Determine target

If `$ARGUMENTS` is provided, treat it as the path to the doc bundle (directory or single file).

If empty, use the current working directory.

Find all `.md` files within. Common targets: `README.md`, `INSTALL.md`, `docs/*.md`, `CLAUDE.md`, anything ending in `.md`.

### 2. Build cross-reference map

Scan all `.md` files in scope. For each, extract:

- **Anchor links** — `[text](#anchor-slug)` references
- **File links** — `[text](relative/path.md)` references
- **Heading slugs** — `## Section Name` → `section-name` (GitHub anchor convention: lowercase, alphanumeric + hyphens, special chars dropped)
- **Numeric counts** — phrases like "16 hooks", "12 slash commands", "5 agents" (numbers followed by repeated nouns across files)
- **Section references** — phrases like "see X above" / "see X below" / "see [Y]"

### 3. Run the checks

Run each of the following in parallel and aggregate findings:

#### A. Broken anchor links 🚨

For every `[text](#anchor)` link, verify the anchor matches a heading slug in the same file. Flag mismatches.

**Common cause:** Heading was renamed; link wasn't updated. Or anchor was hand-written without verifying GitHub's slug rules.

#### B. Broken file links 🚨

For every `[text](relative/path)` link, verify the file exists at the path. Flag missing files.

**Common cause:** File was renamed/deleted; reference wasn't updated.

#### C. Count drift 🚨

For each numeric count phrase (e.g., "16 hooks", "12 commands"), check if the same noun is referenced elsewhere with a different number. Flag inconsistencies.

**Common cause:** A new item was added; the count in one section was updated but not all sections that reference it.

**Special case:** verify counts against actual file counts where possible (e.g., "12 slash commands" vs `ls commands/*.md | wc -l`).

#### D. Ambiguous pronouns ⚠️

Scan for pronouns ("them", "this", "it", "those", "these") in context. For each, check if the antecedent is within ~30 characters and unambiguous. Flag cases where a fresh reader would have to backtrack to figure out what the pronoun refers to.

**Common cause:** Author has clear mental model; pronoun is obvious to them but not to the reader.

#### E. Audience baseline assumptions ⚠️

Scan for phrases that assume the reader knows the *before* state:

- "what you'll feel after [doing X]"
- "the difference is..."
- "compared to before"
- "now you'll be able to..."
- "no more [old way]"

Flag for review. These phrases land for someone with the prior context but bounce off a fresh reader.

#### F. Jargon flags ⚠️

Scan for in-group terminology that may be invisible to the author. Default list (extend per project):

- "daily-driver" (car-enthusiast jargon for "everyday tool")
- "wire it" / "wire up" (developer jargon for "connect/configure")
- "out of the box" (IT jargon for "default configuration")
- "tap into" / "leverage" / "enable" (corporate-speak)
- "ergonomic" (UX jargon for "easy/comfortable to use")
- "first-class" (programming jargon for "natively supported")
- "lift and shift" (cloud-migration jargon)

If the doc has its own glossary, allow terms defined there.

#### G. Sequencing inconsistencies 🟢

For phrases like "see X above" / "see X below", verify X is actually above/below the reference. Flag mismatches.

**Common cause:** Sections were reordered but cross-references weren't updated.

#### H. Stale references 🟢

For mentioned features/files/commands, verify they still exist in the actual codebase or referenced repo. Flag references to things that have been removed or renamed.

### 4. Present findings

Format as a structured report:

```
━━━━ CONSISTENCY CHECK: <bundle-name> ━━━━

Files scanned:        N
Issues found:         X critical · Y important · Z polish

🚨 CRITICAL
─────────
  [file:line] Broken anchor: #install (no heading "Install" in this file; did you mean #installation?)
  [file:line] Count drift: "16 hooks" in README, "12 hooks" in INSTALL.md (which is right?)
  [file:line] Broken file link: docs/output-styles.md (file doesn't exist; did you mean docs/output-styles-primer.md?)

⚠️  IMPORTANT
─────────
  [file:line] Ambiguous "them": "rename them to .backup" — antecedent is 4 lines back
  [file:line] Audience baseline: "what you'll feel after installing" assumes reader knows pre-install state
  [file:line] Jargon flag: "daily-driver" — consider "real working setup" or define
  
🟢 POLISH
─────────
  [file:line] "see Quick glossary above" — but Quick glossary is below this line
  [file:line] Stale reference: "scope-creep-detector hook" — exists in repo but is opt-in (mention?)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 5. Offer to act

End with: *"Want me to fix the safe ones automatically (broken anchors with clear correct targets, count drift where one number is verifiably right), or just leave the report for review?"*

If the user says yes:
- Fix broken anchor links where there's an unambiguous correct heading
- Fix count drift where one number can be verified against the actual filesystem (e.g., `ls commands/*.md | wc -l`)
- Fix broken file links where there's an unambiguous correct file (typo in path)
- **Don't auto-fix:** anything in IMPORTANT or POLISH categories. Those need human judgment.

For the items not auto-fixed, write a `_consistency-todo.md` in the target directory with the remaining items.

### 6. Re-run after fixes

If auto-fixes were applied, re-run the audit and confirm the issues are gone. Report any unexpected new issues introduced by the fixes.

## What this CAN'T catch

- **Semantic drift** — the doc describes old behavior accurately, but the kit changed. (Requires checking docs against actual kit behavior.)
- **Tone issues** — the jargon list is finite. New jargon emerges constantly.
- **Missing audiences** — the audit can't know who's missing from the doc.
- **Voice inconsistency** — different sections written by different people/passes may have different rhythm.
- **Wrong-but-internally-consistent content** — if every section says the same thing wrongly, the audit passes.

For those, you still need a human cold-read pass. This command catches the **mechanical** drift; you still catch the **judgment** drift.

## When you can't run this command

If for some reason the command doesn't apply (single short doc, draft-in-progress, etc.), the lightweight manual version:

1. Search for all `[text](#)` and `[text](file)` links — verify each
2. Search for any number followed by a noun — check the count appears the same way elsewhere
3. Read the doc top-down replacing every pronoun with its antecedent — does it still make sense?
4. Read the doc as if you'd never seen the project — what's confusing?

That's the spirit of the command. The command just automates it.

---

*This command was extracted from a 2026-05-06 cold-read review session that caught 12+ issues in the claude-code-starter-kit docs that the author shipped without seeing. The patterns surfaced — count drift, pronoun ambiguity, audience baseline assumption, jargon — became this command's checklist.*
