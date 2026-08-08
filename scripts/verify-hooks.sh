#!/bin/bash
# verify-hooks.sh — smoke-test the kit's hook layer. "The fire drill."
#
# Why this exists: hooks fail silently. When one dies, nothing announces it —
# it just stops doing its job. This script proves each hook is ALIVE, on demand.
#
# Philosophy: dry-run only. Hooks are executed inside a sandbox: a throwaway
# HOME plus no-op stubs for osascript and curl on PATH, so no notifications
# fire, nothing is sent anywhere, and no real state files are touched. The
# sandbox is deleted on exit (including Ctrl-C).
#
# Usage:  bash "<kit-root>/scripts/verify-hooks.sh"
# Exit:   0 = all checks pass (WARNs allowed) · 1 = at least one FAIL

KIT="$(cd "$(dirname "$0")/.." && pwd)"
HOOKS="$KIT/hooks/scripts"
HOOKS_JSON="$KIT/hooks/hooks.json"

PASS=0; FAIL=0; WARN=0
pass() { PASS=$((PASS+1)); printf 'PASS  %s\n' "$1"; }
fail() { FAIL=$((FAIL+1)); printf 'FAIL  %s\n' "$1"; }
warn() { WARN=$((WARN+1)); printf 'WARN  %s\n' "$1"; }

# ── Sandbox: throwaway HOME + no-op osascript/curl, removed on any exit ─────
# Staged under the real ~/.claude (not /tmp) because backup-before-edit
# deliberately skips temp paths and would false-fail on a /tmp fixture.
SANDBOX_PARENT="$HOME/.claude"
case "$HOME" in
    /tmp/*|/private/tmp/*) SANDBOX_PARENT="$HOME" ;;  # containers/CI: best effort
esac
mkdir -p "$SANDBOX_PARENT"
TMPD="$SANDBOX_PARENT/.verify-hooks-tmp.$$"
mkdir -p "$TMPD/home/.claude" "$TMPD/bin" "$TMPD/stage"
trap 'rm -rf "$TMPD"' EXIT INT TERM
printf '#!/bin/sh\nexit 0\n' > "$TMPD/bin/osascript"
printf '#!/bin/sh\nexit 0\n' > "$TMPD/bin/curl"
chmod +x "$TMPD/bin/osascript" "$TMPD/bin/curl"

# Run a hook inside the sandbox: fake HOME, stubbed notifications/network.
sandboxed() {
    HOME="$TMPD/home" PATH="$TMPD/bin:$PATH" bash "$@"
}

echo "kit verify-hooks — $(date '+%F %T')"
echo "kit location: $KIT"
echo "────────────────────────────────────────"

# ── Tier 0: prerequisites (execution probes, not presence checks — a stub
# python3 that exists but can't run is worse than a missing one) ─────────────
python3 -c 'import json' >/dev/null 2>&1 \
    && pass "prereq: python3 runs" \
    || fail "prereq: python3 missing or not functional (macOS: a stub may exist until Xcode CLT is installed) — safety hooks refuse to run without it"
jq --version >/dev/null 2>&1 \
    && pass "prereq: jq runs" \
    || fail "prereq: jq missing or not functional — pre-edit backups and session logging depend on it"

# ── Tier 1: wiring — hooks.json parses, every referenced script exists ──────
if [ ! -f "$HOOKS_JSON" ]; then
    fail "hooks.json not found at $HOOKS_JSON"
else
    WIRED=$(python3 - "$HOOKS_JSON" <<'PY' 2>/dev/null
import json, sys, re
d = json.load(open(sys.argv[1]))
names = set()
def walk(x):
    if isinstance(x, dict):
        cmd = x.get('command', '')
        if isinstance(cmd, str) and cmd:
            m = re.search(r'([A-Za-z0-9_.-]+\.sh)', cmd)
            if m: names.add(m.group(1))
        for v in x.values(): walk(v)
    elif isinstance(x, list):
        for v in x: walk(v)
walk(d)
print('\n'.join(sorted(names)))
PY
)
    if [ -z "$WIRED" ]; then
        fail "hooks.json — did not parse as JSON"
    else
        pass "hooks.json — parses, $(wc -l <<< "$WIRED" | tr -d ' ') wired script(s)"
        while IFS= read -r w; do
            if [ ! -f "$HOOKS/$w" ]; then
                fail "wiring: $w is referenced in hooks.json but not present on disk"
            elif [ ! -x "$HOOKS/$w" ]; then
                fail "wiring: $w exists but is not executable (fix: chmod +x)"
            fi
        done <<< "$WIRED"
        for script in "$HOOKS"/*.sh; do
            name=$(basename "$script")
            if ! grep -q "^$name$" <<< "$WIRED"; then
                case "$name" in
                    pushover.sh) pass "wiring: pushover.sh — intentionally unwired (shared helper)" ;;
                    *) warn "wiring: $name is on disk but not wired in hooks.json" ;;
                esac
            fi
        done
    fi
fi

# ── Tier 2: every script parses ─────────────────────────────────────────────
for script in "$HOOKS"/*.sh; do
    name=$(basename "$script")
    bash -n "$script" 2>/dev/null \
        && pass "syntax: $name" \
        || fail "syntax: $name — bash reports a syntax error"
done

# ── Tier 3: functional tests of the safety spine (sandboxed) ────────────────

# safety-net must block a dangerous command
out=$(echo '{"tool_name":"Bash","tool_input":{"command":"git push --force origin main"}}' \
      | sandboxed "$HOOKS/safety-net.sh" 2>/dev/null)
grep -q '"error"' <<< "$out" \
    && pass "safety-net — blocks a force-push payload" \
    || fail "safety-net — did not emit an error for a force-push payload"

# safety-net must allow a benign command
out=$(echo '{"tool_name":"Bash","tool_input":{"command":"ls -la"}}' \
      | sandboxed "$HOOKS/safety-net.sh" 2>/dev/null)
if grep -q '"ok"' <<< "$out" && ! grep -q '"error"' <<< "$out"; then
    pass "safety-net — allows a benign command"
else
    fail "safety-net — emitted an error for a plain ls"
fi

# safety-net must fail closed on garbage input
out=$(echo 'not json at all' | sandboxed "$HOOKS/safety-net.sh" 2>/dev/null)
grep -q '"error"' <<< "$out" \
    && pass "safety-net — fails closed on unparseable input" \
    || fail "safety-net — allowed unparseable input through"

# self-guard must deny a destructive hook-script write without a DRY_RUN gate
out=$(echo '{"tool_name":"Write","tool_input":{"file_path":"/tmp/verify-synth/.claude/hooks/evil.sh","content":"git push --force origin main"}}' \
      | sandboxed "$HOOKS/self-guard.sh" 2>/dev/null)
grep -q '"deny"' <<< "$out" \
    && pass "self-guard — denies a destructive hook-script write" \
    || fail "self-guard — did not deny a destructive hook-script write"

# self-guard must allow the same content outside Claude infrastructure
# (regression test: an earlier version policed every scripts/ dir on disk)
out=$(echo '{"tool_name":"Write","tool_input":{"file_path":"/tmp/verify-synth/my-app/scripts/deploy.sh","content":"git push --force origin main"}}' \
      | sandboxed "$HOOKS/self-guard.sh" 2>/dev/null)
if grep -q '"ok"' <<< "$out" && ! grep -q '"deny"' <<< "$out"; then
    pass "self-guard — leaves unrelated projects' scripts alone"
else
    fail "self-guard — denied a write outside Claude infrastructure"
fi

# backup-before-edit must create a backup copy. The fixture lives in the real
# ~/.claude subtree (see sandbox note above), inside the auto-removed TMPD.
echo "original content" > "$TMPD/stage/sample.txt"
echo "{\"tool_name\":\"Edit\",\"tool_input\":{\"file_path\":\"$TMPD/stage/sample.txt\"}}" \
    | sandboxed "$HOOKS/backup-before-edit.sh" >/dev/null 2>&1
if ls "$TMPD/stage/_backups/sample.txt."*.bak >/dev/null 2>&1; then
    pass "backup-before-edit — backup copy created before edit"
else
    if [ "$SANDBOX_PARENT" != "$HOME/.claude" ]; then
        warn "backup-before-edit — skipped: HOME is under a temp path, which this hook ignores by design"
    else
        fail "backup-before-edit — no backup copy appeared for an edit payload"
    fi
fi

# ── Tier 4: liveness — every remaining wired hook, inside the sandbox ───────
for script in "$HOOKS"/*.sh; do
    name=$(basename "$script")
    case "$name" in
        safety-net.sh|self-guard.sh|backup-before-edit.sh|pushover.sh) continue ;;
    esac
    out=$(echo '{"session_id":"verify-synth","tool_name":"Bash","prompt":"hello"}' \
          | sandboxed "$script" 2>/dev/null)
    rc=$?
    firstchar=$(printf '%s' "$out" | head -c 1)
    if [ $rc -ne 0 ]; then
        fail "liveness: $name — exited non-zero ($rc) on a synthetic payload"
    elif [ "$firstchar" = "{" ] || [ "$firstchar" = "[" ]; then
        # JSON-shaped output must actually parse; plain text is a valid hook output
        python3 -c "import json,sys; json.loads(sys.stdin.read())" <<< "$out" 2>/dev/null \
            && pass "liveness: $name — exits clean, JSON output parses" \
            || fail "liveness: $name — emitted JSON-shaped output that does not parse"
    else
        pass "liveness: $name — exits clean"
    fi
done

# ── Optional: statusline, if the user installed it (sandboxed) ──────────────
if [ -f "$HOME/.claude/statusline.sh" ]; then
    out=$(echo '{"model":{"display_name":"Test"},"workspace":{"current_dir":"/tmp"},"context_window":{"remaining_percentage":50}}' \
          | sandboxed "$HOME/.claude/statusline.sh" 2>/dev/null)
    if [ $? -eq 0 ] && [ -n "$out" ]; then
        pass "statusline — installed, runs clean on a sample payload"
    else
        fail "statusline — installed but exited non-zero or emitted nothing"
    fi
fi

# ── Summary ─────────────────────────────────────────────────────────────────
echo "────────────────────────────────────────"
echo "PASS: $PASS   FAIL: $FAIL   WARN: $WARN"
if [ "$FAIL" -gt 0 ]; then
    echo "RESULT: $FAIL check(s) FAILING — ask Claude to diagnose (paste this output)."
    exit 1
fi
echo "RESULT: hook layer verified alive."
exit 0
