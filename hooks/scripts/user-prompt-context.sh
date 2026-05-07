#!/bin/bash
# UserPromptSubmit hook: injects active context + relay inbox + debt count
# before Claude processes each prompt.
#
# Reads from:
#   ~/.claude/active-context.md   — current state, updated at session end or manually
#   ~/.claude/relay-inbox.md      — inter-session messages (optional)
#   ~/.claude/debt.md             — operational debt items flagged mid-session
#
# Also injects a project-state preview when cwd is inside a git repo with
# CONTEXT-SUMMARY.md or PLANNING.md, helping re-entry to inactive projects
# without manual lookup.

# Reset permission notification marker — user is back and responding
rm -f /tmp/claude-permission-notified 2>/dev/null

CONTEXT_FILE="$HOME/.claude/active-context.md"
RELAY_FILE="$HOME/.claude/relay-inbox.md"

# --- Auto session naming (first prompt only) ---
SESSION_TITLE=""
TITLE_MARKER="/tmp/claude-session-titled-$$"
if [ ! -f "$TITLE_MARKER" ]; then
  touch "$TITLE_MARKER"
  CWD=$(pwd)
  DATE=$(date +"%b %d")
  case "$CWD" in
    "$HOME"|/)              PROJECT="home" ;;
    *)                      PROJECT=$(basename "$CWD") ;;
  esac
  SESSION_TITLE="${PROJECT} — ${DATE}"
fi

# --- Context injection ---
COMBINED=""

if [ -f "$CONTEXT_FILE" ] && [ -s "$CONTEXT_FILE" ]; then
  COMBINED=$(head -30 "$CONTEXT_FILE")
fi

if [ -f "$RELAY_FILE" ] && [ -s "$RELAY_FILE" ]; then
  if [ -n "$COMBINED" ]; then
    COMBINED="$COMBINED

---

"
  fi
  COMBINED="${COMBINED}$(head -40 "$RELAY_FILE")"
fi

# --- Project state (CONTEXT-SUMMARY.md or PLANNING.md preview) ---
# When cwd is inside a git repo, inject a preview of CONTEXT-SUMMARY.md
# (preferred) or PLANNING.md. Helps re-entry without manual lookup.
PROJECT_STATE=""
CWD=$(pwd)

# Walk up to find .git or hit /
REPO_ROOT="$CWD"
while [ "$REPO_ROOT" != "/" ] && [ ! -d "$REPO_ROOT/.git" ]; do
  REPO_ROOT=$(dirname "$REPO_ROOT")
done

if [ -d "$REPO_ROOT/.git" ]; then
  PROJECT_NAME=$(basename "$REPO_ROOT")
  CONTEXT_SUMMARY="$REPO_ROOT/CONTEXT-SUMMARY.md"
  PLANNING="$REPO_ROOT/PLANNING.md"

  # Prefer CONTEXT-SUMMARY.md (smaller, current state). Fall back to PLANNING.md.
  if [ -f "$CONTEXT_SUMMARY" ]; then
    PROJECT_STATE="📍 ${PROJECT_NAME} — CONTEXT-SUMMARY.md (current state):

$(head -50 "$CONTEXT_SUMMARY")"
  elif [ -f "$PLANNING" ]; then
    # Staleness: PLANNING.md mtime vs latest git commit time
    STALENESS=""
    PLANNING_MTIME=$(stat -f %m "$PLANNING" 2>/dev/null)
    GIT_MTIME=$(cd "$REPO_ROOT" && git log -1 --format=%ct 2>/dev/null)
    if [ -n "$GIT_MTIME" ] && [ -n "$PLANNING_MTIME" ] && [ "$GIT_MTIME" -gt "$PLANNING_MTIME" ]; then
      DAYS_DIFF=$(( (GIT_MTIME - PLANNING_MTIME) / 86400 ))
      if [ "$DAYS_DIFF" -gt 7 ]; then
        STALENESS="📅 PLANNING.md may be ${DAYS_DIFF}d stale (last updated before recent commits). Consider refreshing at session end.

"
      fi
    fi
    PROJECT_STATE="${STALENESS}📋 ${PROJECT_NAME} — PLANNING.md preview:

$(head -30 "$PLANNING")"
  fi
fi

if [ -n "$PROJECT_STATE" ]; then
  if [ -n "$COMBINED" ]; then
    COMBINED="${COMBINED}

---

${PROJECT_STATE}"
  else
    COMBINED="$PROJECT_STATE"
  fi
fi

# --- Debt register count (operational debt flagged mid-session) ---
DEBT_FILE="$HOME/.claude/debt.md"
if [ -f "$DEBT_FILE" ]; then
  DEBT_COUNT=$(grep -c "^- \[ \]" "$DEBT_FILE" 2>/dev/null || echo 0)
  if [ "$DEBT_COUNT" -gt 0 ]; then
    DEBT_LINE="📋 ${DEBT_COUNT} open debt item(s) — type /debt to review"
    if [ -n "$COMBINED" ]; then
      COMBINED="${DEBT_LINE}

${COMBINED}"
    else
      COMBINED="$DEBT_LINE"
    fi
  fi
fi

# --- Build JSON output ---
if [ -n "$SESSION_TITLE" ] && [ -n "$COMBINED" ]; then
  CONTEXT_JSON=$(printf '%s' "$COMBINED" | jq -Rs .)
  TITLE_JSON=$(printf '%s' "$SESSION_TITLE" | jq -Rs .)
  echo "{\"additionalContext\": $CONTEXT_JSON, \"sessionTitle\": $TITLE_JSON}"
elif [ -n "$SESSION_TITLE" ]; then
  TITLE_JSON=$(printf '%s' "$SESSION_TITLE" | jq -Rs .)
  echo "{\"sessionTitle\": $TITLE_JSON}"
elif [ -n "$COMBINED" ]; then
  CONTEXT_JSON=$(printf '%s' "$COMBINED" | jq -Rs .)
  echo "{\"additionalContext\": $CONTEXT_JSON}"
else
  echo '{"ok": true}'
fi

exit 0
