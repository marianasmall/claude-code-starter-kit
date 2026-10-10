#!/bin/bash
# install-test.sh — install the kit the way a user does, then run /kit:verify
# from the installed copy.
#
# Why this exists: in 0.2.0 both shipped bugs were invisible from a repo
# checkout. hooks.json had the wrong shape (Claude Code refused to load it) and
# /kit:verify searched for the kit in a folder that doesn't exist after a real
# install. This test installs into a throwaway Claude config, so it sees what a
# user sees. No login needed; your real ~/.claude is never touched.
#
# Usage:  bash scripts/install-test.sh        (needs the `claude` CLI on PATH)
# Exit:   0 = installed, found, and drill passed · 1 = something failed

set -u
REPO="$(cd "$(dirname "$0")/.." && pwd)"
SANDBOX="$(mktemp -d)"
trap 'rm -rf "$SANDBOX"' EXIT INT TERM

# Throwaway HOME + config dir. CLAUDE_PLUGIN_ROOT is deliberately unset: that's
# the case /kit:verify's fallback lookup has to handle.
run() {
    env -u CLAUDE_PLUGIN_ROOT HOME="$SANDBOX" CLAUDE_CONFIG_DIR="$SANDBOX/.claude" "$@"
}

step() { printf '\n── %s\n' "$1"; }
die()  { printf 'FAIL  %s\n' "$1"; exit 1; }

step "1. Add the marketplace and install the plugin"
run claude plugin marketplace add "$REPO" || die "marketplace add failed"
run claude plugin install kit@claude-code-starter-kit || die "plugin install failed"
run claude plugin list | grep -q "kit@claude-code-starter-kit" || die "kit not listed after install"

step "2. Find the kit using the exact lookup in commands/verify.md"
# Pull the first fenced code block out of verify.md and drop its last line
# (the `bash "$VERIFY"` call) so we can check what it found before running it.
# Testing the documented snippet itself means editing verify.md can't silently
# break the lookup again.
LOOKUP="$(awk '/^```/{n++; next} n==1' "$REPO/commands/verify.md" | sed '$d')"
[ -n "$LOOKUP" ] || die "could not read the lookup snippet from commands/verify.md"
FOUND="$(run bash -c "$LOOKUP"'; printf %s "$VERIFY"')"
case "$FOUND" in
    "$SANDBOX"/.claude/plugins/cache/*/scripts/verify-hooks.sh) echo "PASS  found installed kit: ${FOUND#"$SANDBOX"/}" ;;
    "") die "lookup found nothing; /kit:verify would fail for users" ;;
    *)  die "lookup found $FOUND, which is not the installed copy" ;;
esac

step "3. Run the fire drill from the installed copy"
run bash "$FOUND" || die "verify-hooks.sh reported failures in the installed copy"

printf '\nRESULT: install test passed.\n'
