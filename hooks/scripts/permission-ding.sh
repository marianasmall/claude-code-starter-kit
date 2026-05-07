#!/bin/bash
# Permission ding — PermissionRequest hook.
# Plays a distinct sound when Claude is waiting for permission approval.
# Uses "Submarine" (deeper tone than the "Glass" completion sound) so the
# user can distinguish "Claude finished" from "Claude is stuck waiting."
#
# Optional: also sends Pushover notification with tool description and a
# tappable link to the remote session (if Pushover is configured).
# Falls back silently to just the Mac sound if Pushover isn't set up.

PERM_MARKER="/tmp/claude-permission-notified"

INPUT=$(cat)

TOOL_NAME=$(echo "$INPUT" | python3 -c "import sys,json; print(json.load(sys.stdin).get('tool_name','unknown'))" 2>/dev/null || echo "unknown")
SESSION_ID=$(echo "$INPUT" | python3 -c "import sys,json; print(json.load(sys.stdin).get('session_id',''))" 2>/dev/null || echo "")

# Build a human-readable description of what's being asked
TOOL_DESC="$TOOL_NAME"
case "$TOOL_NAME" in
    Bash)
        CMD=$(echo "$INPUT" | python3 -c "import sys,json; c=json.load(sys.stdin).get('tool_input',{}).get('command',''); print(c[:80]+'...' if len(c)>80 else c)" 2>/dev/null)
        [ -n "$CMD" ] && TOOL_DESC="Bash: $CMD"
        ;;
    Edit|Write)
        FILE=$(echo "$INPUT" | python3 -c "import sys,json; print(json.load(sys.stdin).get('tool_input',{}).get('file_path','').split('/')[-1])" 2>/dev/null)
        [ -n "$FILE" ] && TOOL_DESC="$TOOL_NAME: $FILE"
        ;;
    mcp__*)
        TOOL_DESC=$(echo "$TOOL_NAME" | python3 -c "import sys; n=sys.stdin.read().strip(); parts=n.split('__'); print(' '.join(parts[-2:]) if len(parts)>=2 else n)" 2>/dev/null || echo "$TOOL_NAME")
        ;;
esac

RC_URL=""
if [ -n "$SESSION_ID" ]; then
    RC_URL="https://claude.ai/code/session_${SESSION_ID}"
fi

# Log the permission request
LOG_FILE="$HOME/.claude/permission-log.md"
echo "- $(date '+%Y-%m-%d %H:%M') | $TOOL_DESC" >> "$LOG_FILE"

# Mac notification with tool context
osascript -e "display notification \"$TOOL_DESC\" with title \"Claude Code\" subtitle \"Waiting for approval\" sound name \"Submarine\"" 2>/dev/null

# Optional Pushover (silently no-ops if not configured)
if [ ! -f "$PERM_MARKER" ]; then
    touch "$PERM_MARKER"
    SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
    source "$SCRIPT_DIR/pushover.sh" 2>/dev/null
    PUSHOVER_DEBOUNCE=0 send_pushover \
        "Claude Code — Approval Needed" \
        "$TOOL_DESC" \
        1 \
        "$RC_URL" \
        "Approve in Browser" \
        2>/dev/null
fi

echo '{"ok": true}'
exit 0
