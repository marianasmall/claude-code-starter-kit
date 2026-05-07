#!/bin/bash
# PreCompact hook: fires before context compression.
# Logs when compaction happens so we know if important context was trimmed.
# Also sends a notification so the user knows the conversation is getting long.

TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
LOG_FILE="$HOME/.claude/compaction-log.md"

# Create log file if it doesn't exist
if [ ! -f "$LOG_FILE" ]; then
  echo "# Context Compaction Log" >> "$LOG_FILE"
  echo "" >> "$LOG_FILE"
  echo "Tracks when Claude Code compresses conversation context." >> "$LOG_FILE"
  echo "If something seems 'forgotten' mid-session, check timestamps here." >> "$LOG_FILE"
  echo "" >> "$LOG_FILE"
fi

echo "- $TIMESTAMP — Context compaction triggered" >> "$LOG_FILE"

# Notify so the user knows context is being trimmed (macOS only; silent on other OS)
osascript -e 'display notification "Context is being compressed — long conversation detected" with title "Claude Code" sound name "Purr"' 2>/dev/null

exit 0
