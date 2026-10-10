---
name: verify
description: Fire drill for the kit's hooks — proves every hook is alive and the safety hooks actually block. Dry-run, changes nothing.
---

# /verify — Is the hook layer actually alive?

Hooks fail silently: when one dies, nothing announces it. This command stages a fake
scenario at each hook and watches the reaction — including confirming the safety hooks
really BLOCK dangerous input. It changes nothing and is safe to run any time.

## Workflow

### 1. Locate the kit and run the drill

Use `$CLAUDE_PLUGIN_ROOT` if it's set in your environment. If it isn't (common when
running via the Bash tool), find the installed kit yourself. Plugins install to
`~/.claude/plugins/cache/<marketplace>/<plugin>/<version>/`, so for this kit that's
`~/.claude/plugins/cache/claude-code-starter-kit/kit/0.2.1/`. Look for the drill
script itself rather than a folder name, so a renamed marketplace still resolves:

```
VERIFY="${CLAUDE_PLUGIN_ROOT:+$CLAUDE_PLUGIN_ROOT/scripts/verify-hooks.sh}"
[ -f "$VERIFY" ] || VERIFY="$(ls -t ~/.claude/plugins/cache/*/kit/*/scripts/verify-hooks.sh 2>/dev/null | head -1)"
bash "$VERIFY"
```

If neither resolves, ask the user whether they're running from a repo checkout and use
`scripts/verify-hooks.sh` relative to it.

### 2. Interpret for the user, in plain language

- **All PASS** → "All N hooks verified alive — backups, safety blocks, and coaching are all working." Done.
- **Any FAIL** → For each failing line, explain what protection is currently OFF in plain terms (e.g., "backup-before-edit failing means your files are NOT being backed up before edits right now"), then diagnose and fix:
  - `prereq` failures → offer to install python3/jq (brew on macOS)
  - `NOT executable` → offer to run the chmod
  - `syntax` / `wiring` failures → the install may be corrupted; offer `/plugin update kit` or reinstall
  - Functional failures (safety-net, self-guard, backup) → read the failing script, find the cause, fix it — these are the kit's safety spine, don't leave them red
- **WARNs** → mention briefly; they're degradations, not dead protections.

### 3. Re-run after any fix

Repeat until FAIL count is 0. Suggest re-running `/kit:verify` after Claude Code updates
and after editing any hook — that's when silent breakage happens.

## When to run

- Right after installing the kit (the getting-started checklist ends here)
- After a Claude Code update
- After editing anything in `hooks/`
- Any time something feels off ("did my backup hook stop working?")

## Related

`/kit:maintain quick` is the broader health check (Claude Code version, packages);
`/kit:verify` is the deterministic hook fire drill. Run verify when you want proof,
not a checkup.
