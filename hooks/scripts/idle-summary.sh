#!/bin/bash
# Idle Summary — UserPromptSubmit hook.
#
# When the user returns after a long pause (>15 min), prepend a short
# "Welcome back — here's where we left off" summary to their prompt.
# This re-orients Claude (and indirectly the user, since Claude will
# usually echo the summary back) without forcing a manual /recap.
#
# How it works:
#   * Tracks the timestamp of the last UserPromptSubmit per session
#   * If gap > IDLE_THRESHOLD_SECS (default 900 = 15 min), pulls the most
#     recent few entries from ~/.claude/active-context.md and ~/.claude/debt.md
#     and emits them as additionalContext on this prompt
#   * Resets the timestamp every prompt (so it only fires once per "return")
#
# Tunable:
#   IDLE_THRESHOLD_SECS=900   override threshold (in seconds)
#   IDLE_SUMMARY_DISABLE=1    skip entirely (useful for short focused sessions)
#
# Falls back silently when active-context.md is missing or empty.

if [ "${IDLE_SUMMARY_DISABLE:-0}" = "1" ]; then
    echo '{"ok": true}'
    exit 0
fi

IDLE_THRESHOLD_SECS="${IDLE_THRESHOLD_SECS:-900}"

INPUT=$(cat)
SESSION_ID=$(echo "$INPUT" | python3 -c "import sys,json; print(json.load(sys.stdin).get('session_id',''))" 2>/dev/null)

if [ -z "$SESSION_ID" ]; then
    echo '{"ok": true}'
    exit 0
fi

STATE_DIR="$HOME/.claude/hooks/state"
TS_FILE="$STATE_DIR/idle-${SESSION_ID}.ts"
mkdir -p "$STATE_DIR" 2>/dev/null

NOW=$(date +%s)
GAP=0

if [ -f "$TS_FILE" ]; then
    LAST=$(cat "$TS_FILE" 2>/dev/null)
    if [ -n "$LAST" ]; then
        GAP=$((NOW - LAST))
    fi
fi

# Always update timestamp for next prompt
echo "$NOW" > "$TS_FILE"

# Not idle long enough — just allow
if [ "$GAP" -lt "$IDLE_THRESHOLD_SECS" ]; then
    echo '{"ok": true}'
    exit 0
fi

# First prompt of session — no previous timestamp = no idle gap to summarize
if [ -z "$LAST" ]; then
    echo '{"ok": true}'
    exit 0
fi

# Build a "welcome back" summary
MINUTES=$((GAP / 60))
SUMMARY="WELCOME-BACK SUMMARY (${MINUTES}min idle since last prompt). Re-orient before responding:"

CONTEXT_FILE="$HOME/.claude/active-context.md"
if [ -f "$CONTEXT_FILE" ] && [ -s "$CONTEXT_FILE" ]; then
    SUMMARY="${SUMMARY}

CURRENT STATE (from active-context.md):
$(head -25 "$CONTEXT_FILE")"
fi

DEBT_FILE="$HOME/.claude/debt.md"
if [ -f "$DEBT_FILE" ]; then
    OPEN_DEBT=$(grep "^- \[ \]" "$DEBT_FILE" 2>/dev/null | head -5)
    if [ -n "$OPEN_DEBT" ]; then
        SUMMARY="${SUMMARY}

OPEN DEBT ITEMS (top 5):
${OPEN_DEBT}"
    fi
fi

SUMMARY="${SUMMARY}

When responding to the user's next message, briefly recap where we left off (1-2 sentences) before answering — they may have lost the thread during the pause."

# Emit as additionalContext (visible to Claude, not to the user directly)
python3 <<PYEOF
import json
print(json.dumps({"additionalContext": """$SUMMARY"""}))
PYEOF
exit 0
