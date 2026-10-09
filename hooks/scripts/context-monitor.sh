#!/bin/bash
# Context Monitor — PostToolUse hook
#
# Reads context metrics from the statusline bridge file and injects warnings
# when context usage is high. This makes the AGENT aware of context limits
# (the statusline only shows the user).
#
# Thresholds:
#   WARNING    (remaining <= 35%): Agent should wrap up current task
#   CRITICAL   (remaining <= 25%): Agent should stop and save state
#   USER ALERT (remaining <= 30%): macOS + Pushover notification (once per session)
#
# Debounce: 5 tool uses between warnings to avoid spam.
#
# Requires: statusline.sh installed (writes /tmp/claude-ctx-{session}.json).
# Falls back silently if metrics file isn't present.

WARNING_THRESHOLD=35
CRITICAL_THRESHOLD=25
USER_THRESHOLD=30
STALE_SECONDS=60
DEBOUNCE_CALLS=5

INPUT=$(cat)

# Skip lightweight tools that don't meaningfully change context usage
TOOL_NAME=$(echo "$INPUT" | python3 -c "import sys,json; print(json.load(sys.stdin).get('tool_name',''))" 2>/dev/null)
case "$TOOL_NAME" in
  Read|Glob|Grep|LS|TaskList|TaskGet)
    echo '{"ok": true}'
    exit 0
    ;;
esac

SESSION_ID=$(echo "$INPUT" | python3 -c "import sys,json; print(json.load(sys.stdin).get('session_id',''))" 2>/dev/null)

if [ -z "$SESSION_ID" ]; then
    echo '{"ok": true}'
    exit 0
fi

METRICS_FILE="/tmp/claude-ctx-${SESSION_ID}.json"
WARN_FILE="/tmp/claude-ctx-${SESSION_ID}-warned.json"

# No metrics file = subagent or fresh session
if [ ! -f "$METRICS_FILE" ]; then
    echo '{"ok": true}'
    exit 0
fi

# All Python below is single-quoted and reads values from the environment,
# so file contents or session IDs are never spliced into code.
REMAINING=$(METRICS_FILE="$METRICS_FILE" STALE_SECONDS="$STALE_SECONDS" python3 -c '
import json, time, os
try:
    with open(os.environ["METRICS_FILE"]) as f:
        m = json.load(f)
    ts = m.get("timestamp", 0)
    now = int(time.time())
    if (now - ts) > int(os.environ["STALE_SECONDS"]):
        print(-1)
    else:
        print(int(m.get("remaining_percentage", 100)))
except Exception:
    print(-1)
' 2>/dev/null)

case "$REMAINING" in ''|*[!0-9]*) REMAINING=-1 ;; esac
if [ "$REMAINING" = "-1" ]; then
    echo '{"ok": true}'
    exit 0
fi

# User notification at threshold — fires once per session, Mac + Pushover
USER_ALERT_FILE="/tmp/claude-ctx-${SESSION_ID}-user-alerted"
if [ "$REMAINING" -le "$USER_THRESHOLD" ] 2>/dev/null && [ ! -f "$USER_ALERT_FILE" ]; then
    touch "$USER_ALERT_FILE"
    osascript -e 'display notification "Context at '"${REMAINING}"'% — STOP: run /session-end now, then push to GitHub" with title "⚠️ Save Session NOW" sound name "Hero"' 2>/dev/null
    SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
    PUSHOVER_DEBOUNCE=0 source "$SCRIPT_DIR/pushover.sh" 2>/dev/null
    send_pushover "⚠️ Save Session NOW" "Context at ${REMAINING}% — STOP and run /session-end, then push to GitHub. Don't keep going." 1 2>/dev/null
fi

if [ "$REMAINING" -gt "$WARNING_THRESHOLD" ] 2>/dev/null; then
    echo '{"ok": true}'
    exit 0
fi

if [ "$REMAINING" -le "$CRITICAL_THRESHOLD" ] 2>/dev/null; then
    LEVEL="CRITICAL"
else
    LEVEL="WARNING"
fi

CALLS_SINCE=0
LAST_LEVEL=""
if [ -f "$WARN_FILE" ]; then
    CALLS_SINCE=$(WARN_FILE="$WARN_FILE" python3 -c '
import json, os
try:
    with open(os.environ["WARN_FILE"]) as f:
        d = json.load(f)
    print(int(d.get("calls_since_warn", 0)))
except Exception:
    print(0)
' 2>/dev/null)
    LAST_LEVEL=$(WARN_FILE="$WARN_FILE" python3 -c '
import json, os
try:
    with open(os.environ["WARN_FILE"]) as f:
        d = json.load(f)
    lvl = d.get("last_level", "")
    print(lvl if lvl in ("WARNING", "CRITICAL") else "")
except Exception:
    print("")
' 2>/dev/null)
fi

# Digits only before arithmetic: bash $(( )) evaluates expressions.
case "$CALLS_SINCE" in ''|*[!0-9]*) CALLS_SINCE=0 ;; esac
CALLS_SINCE=$((CALLS_SINCE + 1))

ESCALATED=false
if [ "$LAST_LEVEL" = "WARNING" ] && [ "$LEVEL" = "CRITICAL" ]; then
    ESCALATED=true
fi

if [ "$ESCALATED" = "false" ] && [ "$CALLS_SINCE" -lt "$DEBOUNCE_CALLS" ]; then
    WARN_FILE="$WARN_FILE" CALLS_SINCE="$CALLS_SINCE" LAST_LEVEL="$LAST_LEVEL" python3 -c '
import json, os
with open(os.environ["WARN_FILE"], "w") as f:
    json.dump({"calls_since_warn": int(os.environ["CALLS_SINCE"]), "last_level": os.environ["LAST_LEVEL"]}, f)
' 2>/dev/null
    echo '{"ok": true}'
    exit 0
fi

WARN_FILE="$WARN_FILE" LEVEL="$LEVEL" python3 -c '
import json, os
with open(os.environ["WARN_FILE"], "w") as f:
    json.dump({"calls_since_warn": 0, "last_level": os.environ["LEVEL"]}, f)
' 2>/dev/null

if [ "$LEVEL" = "CRITICAL" ]; then
    MSG="CONTEXT CRITICAL (${REMAINING}% remaining): STOP current work. Run /session-end immediately, then push any uncommitted changes. If context is below 15%, skip /session-end and write a session summary directly. Tell the user: do NOT keep going — save first, continue in a new session."
else
    MSG="CONTEXT WARNING (${REMAINING}% remaining): Finish your current task, then run /session-end to save a session summary. The right move when this fires is to save and hand off — not push through."
fi

MSG="$MSG" python3 -c 'import os, json; print(json.dumps({"ok": True, "additionalContext": os.environ["MSG"]}))' 2>/dev/null

exit 0
