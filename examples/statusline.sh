#!/bin/bash
# Claude Code Status Line — persistent context monitor
#
# Shows: Model | Session ID | Context bar + remaining% | ~Screenshots left | Cost | Duration | Worktree (if active)
# Color thresholds match context-monitor.sh hook alerts.
#
# Installation:
#   1. Copy this file to ~/.claude/statusline.sh:
#        cp $CLAUDE_PLUGIN_ROOT/examples/statusline.sh ~/.claude/statusline.sh
#        chmod +x ~/.claude/statusline.sh
#   2. Add to ~/.claude/settings.json (top level):
#        "statusLine": {
#          "type": "command",
#          "command": "~/.claude/statusline.sh",
#          "refreshInterval": 30
#        }
#
# Bonus: this script also writes a metrics bridge file at /tmp/claude-ctx-{session_id}.json
# which the context-monitor.sh hook reads to inject context warnings into the agent.
# Without the statusline running, context-monitor degrades to a no-op gracefully.

input=$(cat)

MODEL=$(echo "$input" | jq -r 'if .model | type == "object" then .model.display_name else .model end')
REMAINING=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty' | cut -d. -f1)
if [ -z "$REMAINING" ]; then
    USED_PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
    REMAINING=$((100 - USED_PCT))
fi
COST=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
DURATION_MS=$(echo "$input" | jq -r '.cost.total_duration_ms // 0')

RATE_5H=$(echo "$input" | jq -r '.rate_limits.five_hour.percentage_used // empty' 2>/dev/null | cut -d. -f1)

SESSION_ID=$(echo "$input" | jq -r '.session_id // empty' | cut -c1-6)
SESSION_ID_FULL=$(echo "$input" | jq -r '.session_id // empty')

WORKTREE=$(echo "$input" | jq -r '.worktree.name // empty')

# Colors
GREEN='\033[32m'
YELLOW='\033[33m'
RED='\033[31m'
CYAN='\033[36m'
DIM='\033[2m'
RESET='\033[0m'

# Color thresholds (by remaining%):
#   >35% remaining = green (safe)
#   25-35% remaining = yellow (matches hook WARNING)
#   <25% remaining = red (matches hook CRITICAL)
if [ "$REMAINING" -le 25 ]; then
    BAR_COLOR="$RED"
    LABEL="LOW"
elif [ "$REMAINING" -le 35 ]; then
    BAR_COLOR="$YELLOW"
    LABEL="watch"
else
    BAR_COLOR="$GREEN"
    LABEL="ok"
fi

# 20-char progress bar
BAR_WIDTH=20
FILLED=$((REMAINING * BAR_WIDTH / 100))
EMPTY=$((BAR_WIDTH - FILLED))
BAR=""
[ "$FILLED" -gt 0 ] && printf -v FILL "%${FILLED}s" && BAR="${FILL// /▓}"
[ "$EMPTY" -gt 0 ] && printf -v PAD "%${EMPTY}s" && BAR="${BAR}${PAD// /░}"

# Estimate screenshots remaining (1 screenshot ≈ 1500 tokens, 1M context window)
TOKENS_LEFT=$((REMAINING * 10000))
SCREENSHOTS_LEFT=$((TOKENS_LEFT / 1500))
if [ "$SCREENSHOTS_LEFT" -le 3 ]; then
    SS_COLOR="$RED"
elif [ "$SCREENSHOTS_LEFT" -le 8 ]; then
    SS_COLOR="$YELLOW"
else
    SS_COLOR="$GREEN"
fi

COST_FMT=$(printf '$%.2f' "$COST")

DURATION_SEC=$((DURATION_MS / 1000))
HOURS=$((DURATION_SEC / 3600))
MINS=$(((DURATION_SEC % 3600) / 60))
SECS=$((DURATION_SEC % 60))
if [ "$HOURS" -gt 0 ]; then
    TIME="${HOURS}h ${MINS}m"
else
    TIME="${MINS}m ${SECS}s"
fi

WT_TAG=""
if [ -n "$WORKTREE" ]; then
    WT_TAG="  ${YELLOW}wt:${WORKTREE}${RESET}"
fi

SID_TAG=""
if [ -n "$SESSION_ID" ]; then
    SID_TAG="${DIM}${SESSION_ID}${RESET}  "
fi

RATE_TAG=""
if [ -n "$RATE_5H" ] && [ "$RATE_5H" -gt 0 ] 2>/dev/null; then
    if [ "$RATE_5H" -ge 80 ]; then
        RATE_COLOR="$RED"
    elif [ "$RATE_5H" -ge 50 ]; then
        RATE_COLOR="$YELLOW"
    else
        RATE_COLOR="$GREEN"
    fi
    RATE_TAG="  ${RATE_COLOR}⚡${RATE_5H}%${RESET}"
fi

# Write metrics bridge for context-monitor.sh hook (allows the hook to know
# the current context state without the user having to invoke it).
if [ -n "$SESSION_ID_FULL" ]; then
    BRIDGE_FILE="/tmp/claude-ctx-${SESSION_ID_FULL}.json"
    NOW_TS=$(date +%s)
    cat > "$BRIDGE_FILE" 2>/dev/null <<EOF
{"timestamp": $NOW_TS, "remaining_percentage": $REMAINING, "cost_usd": $COST, "duration_ms": $DURATION_MS}
EOF
fi

printf '%b' "${CYAN}${MODEL}${RESET}  ${SID_TAG}${BAR_COLOR}${BAR} ${REMAINING}%${RESET} [${BAR_COLOR}${LABEL}${RESET}]  ${SS_COLOR}~${SCREENSHOTS_LEFT}ss${RESET}  ${DIM}${COST_FMT}  ${TIME}${RESET}${RATE_TAG}${WT_TAG}\n"
