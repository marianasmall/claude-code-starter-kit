#!/bin/bash
# SessionEnd hook: logs transcript path and session metadata for recovery.
# If the user forgets to run /session-end, this breadcrumb trail ensures
# Claude can always find and reconstruct what happened in past sessions.

INPUT=$(cat)
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // "unknown"')
TRANSCRIPT=$(echo "$INPUT" | jq -r '.transcript_path // "unknown"')
REASON=$(echo "$INPUT" | jq -r '.reason // "unknown"')
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
LOG_FILE="$HOME/.claude/session-log.md"

# Create log file with headers if it doesn't exist
if [ ! -f "$LOG_FILE" ]; then
  echo "# Claude Code Session Log" >> "$LOG_FILE"
  echo "" >> "$LOG_FILE"
  echo "| Timestamp | Session ID | Exit Reason | Transcript Path |" >> "$LOG_FILE"
  echo "|-----------|------------|-------------|-----------------|" >> "$LOG_FILE"
fi

# Append session entry
echo "| $TIMESTAMP | $SESSION_ID | $REASON | $TRANSCRIPT |" >> "$LOG_FILE"

# Optional: maintain a session-index.json with project-tagged entries.
# Project detection happens by matching the transcript path against a
# user-defined map at ~/.claude/project-map.json. Example:
#   { "client-acme": "Acme", "side-project": "SideProj" }
# Falls back to "general" if no project-map.json exists or no match.
INDEX_FILE="$HOME/.claude/session-index.json"
PROJECT_MAP="$HOME/.claude/project-map.json"
if [ -f "$INDEX_FILE" ] && command -v python3 &>/dev/null; then
  PROJECT="general"

  if [ -f "$PROJECT_MAP" ]; then
    DETECTED=$(python3 -c "
import json, sys
try:
    with open('$PROJECT_MAP') as f:
        m = json.load(f)
    t = '$TRANSCRIPT'
    for pattern, label in m.items():
        if pattern in t:
            print(label)
            sys.exit()
except Exception:
    pass
" 2>/dev/null)
    if [ -n "$DETECTED" ]; then
      PROJECT="$DETECTED"
    fi
  fi

  python3 -c "
import json, sys
try:
    with open('$INDEX_FILE') as f:
        idx = json.load(f)
    entry = {
        'session_id': '$SESSION_ID',
        'date': '$TIMESTAMP',
        'transcript': '$TRANSCRIPT',
        'project': '$PROJECT',
        'exit_reason': '$REASON'
    }
    idx.setdefault('sessions', []).append(entry)
    idx['last_updated'] = '$(date +%Y-%m-%d)'
    # Keep last 200 sessions max
    if len(idx['sessions']) > 200:
        idx['sessions'] = idx['sessions'][-200:]
    with open('$INDEX_FILE', 'w') as f:
        json.dump(idx, f, indent=2)
except Exception as e:
    sys.stderr.write(f'session-index update failed: {e}\n')
" 2>/dev/null
fi

# macOS notification as a gentle nudge if session ended without /session-end
osascript -e 'display notification "Session logged. Did you run /session-end?" with title "Claude Code" sound name "Purr"' 2>/dev/null

exit 0
