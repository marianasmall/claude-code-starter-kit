#!/bin/bash
# Persistence Rule — PostToolUse hook.
#
# Enforces the "2-action write rule": after every 2 web search/fetch operations,
# nudges Claude to persist findings to a file before continuing. Prevents
# research findings from evaporating during long sessions or compaction.
#
# Behavior: counts WebSearch + WebFetch + perplexity_research/perplexity_search
# tool calls per session. After 2 in a row without a Write/Edit in between,
# emits an additionalContext nudge instructing Claude to persist findings.
#
# Counter resets when Claude calls Write or Edit (any file).

INPUT=$(cat)
SESSION_ID=$(echo "$INPUT" | python3 -c "import sys,json; print(json.load(sys.stdin).get('session_id','default'))" 2>/dev/null)
TOOL_NAME=$(echo "$INPUT" | python3 -c "import sys,json; print(json.load(sys.stdin).get('tool_name',''))" 2>/dev/null)

if [ -z "$TOOL_NAME" ] || [ -z "$SESSION_ID" ]; then
    exit 0
fi

STATE_DIR="$HOME/.claude/hooks/state"
STATE_FILE="$STATE_DIR/persistence-${SESSION_ID}.txt"
mkdir -p "$STATE_DIR" 2>/dev/null

# Detect tool category
case "$TOOL_NAME" in
    Write|Edit)
        # Persistence happened — reset counter
        echo "0" > "$STATE_FILE"
        exit 0
        ;;
    WebSearch|WebFetch|*perplexity_research|*perplexity_search|*perplexity_ask)
        # Research action — increment counter
        ;;
    *)
        # Other tool — don't increment, don't reset
        exit 0
        ;;
esac

# Read current counter
COUNT=0
if [ -f "$STATE_FILE" ]; then
    COUNT=$(cat "$STATE_FILE" 2>/dev/null || echo 0)
fi
COUNT=$((COUNT + 1))
echo "$COUNT" > "$STATE_FILE"

# Threshold met — nudge to persist
if [ "$COUNT" -ge 2 ]; then
    MSG="PERSISTENCE-RULE: ${COUNT} consecutive research actions without a Write/Edit. Per the 2-action write rule, persist findings to a file (or notes) before continuing further research. Findings evaporate during long sessions or context compaction. Reset by writing what you've found so far before the next search/fetch."
    python3 <<PYEOF
import json
print(json.dumps({
    "hookSpecificOutput": {
        "hookEventName": "PostToolUse",
        "additionalContext": """$MSG"""
    }
}))
PYEOF
fi

exit 0
