#!/bin/bash
# Scope-Creep Detector — UserPromptSubmit hook (OPT-IN).
#
# Tracks the original session ask (first user prompt) and warns when later
# prompts have drifted significantly from it. Designed to surface gentle
# pattern-recognition for users who tend to lose focus mid-session, without
# being naggy.
#
# Disabled by default. Enable with:
#   export SCOPE_CREEP_ENABLED=1
# in ~/.zshrc or ~/.bashrc, OR set it permanently in ~/.claude/settings.json
# under "env" block.
#
# Tunables:
#   SCOPE_CREEP_THRESHOLD=10  prompts after first before checking (default 10)
#   SCOPE_CREEP_DISABLE=1     hard disable for this session
#
# Behavior: stores the first prompt of the session. After threshold prompts,
# compares the most recent prompt to the original. If topic drift detected
# (heuristic: low keyword overlap), emits a soft additionalContext nudge.

if [ "${SCOPE_CREEP_ENABLED:-0}" != "1" ] || [ "${SCOPE_CREEP_DISABLE:-0}" = "1" ]; then
    echo '{"ok": true}'
    exit 0
fi

THRESHOLD="${SCOPE_CREEP_THRESHOLD:-10}"

INPUT=$(cat)
SESSION_ID=$(echo "$INPUT" | python3 -c "import sys,json; print(json.load(sys.stdin).get('session_id',''))" 2>/dev/null)
PROMPT=$(echo "$INPUT" | python3 -c "import sys,json; print(json.load(sys.stdin).get('prompt',''))" 2>/dev/null)

if [ -z "$SESSION_ID" ] || [ -z "$PROMPT" ]; then
    echo '{"ok": true}'
    exit 0
fi

STATE_DIR="$HOME/.claude/hooks/state"
ORIG_FILE="$STATE_DIR/scope-${SESSION_ID}.original.txt"
COUNT_FILE="$STATE_DIR/scope-${SESSION_ID}.count.txt"
mkdir -p "$STATE_DIR" 2>/dev/null

# First prompt — record it as the original
if [ ! -f "$ORIG_FILE" ]; then
    echo "$PROMPT" > "$ORIG_FILE"
    echo "1" > "$COUNT_FILE"
    echo '{"ok": true}'
    exit 0
fi

# Increment counter
COUNT=0
if [ -f "$COUNT_FILE" ]; then
    COUNT=$(cat "$COUNT_FILE" 2>/dev/null || echo 0)
fi
COUNT=$((COUNT + 1))
echo "$COUNT" > "$COUNT_FILE"

# Below threshold — no check
if [ "$COUNT" -lt "$THRESHOLD" ]; then
    echo '{"ok": true}'
    exit 0
fi

# Compute keyword overlap between original and current prompt
ORIGINAL=$(cat "$ORIG_FILE" 2>/dev/null)
OVERLAP=$(python3 <<PYEOF 2>/dev/null
import re
orig = """$ORIGINAL""".lower()
curr = """$PROMPT""".lower()

# Tokenize: alphanumeric words, length > 3 (skip stopwords roughly)
def tokens(s):
    words = re.findall(r'\b[a-z]{4,}\b', s)
    stopwords = {'this', 'that', 'with', 'from', 'have', 'will', 'should', 'would', 'could', 'about', 'where', 'when', 'what', 'which', 'there', 'their', 'them', 'they', 'were', 'been', 'than', 'then', 'into', 'some', 'just', 'like', 'want', 'need', 'make', 'made'}
    return set(w for w in words if w not in stopwords)

o = tokens(orig)
c = tokens(curr)
if not o or not c:
    print(1.0)
else:
    inter = len(o & c)
    union = len(o | c)
    print(inter / union if union else 0)
PYEOF
)

# Drift threshold: <0.05 overlap = significant scope creep
DRIFTED=$(python3 -c "print(1 if float('$OVERLAP') < 0.05 else 0)" 2>/dev/null)

if [ "$DRIFTED" = "1" ]; then
    # Reset counter so we don't nag every prompt afterwards (waits for another threshold cycle)
    echo "0" > "$COUNT_FILE"

    SHORT_ORIG=$(echo "$ORIGINAL" | head -c 120)
    MSG="SCOPE-CREEP CHECK: After ${COUNT} prompts, the conversation has drifted significantly from the original ask: '${SHORT_ORIG}...'. Worth pausing to check: are we still working the original problem? Or did we wander into a tangent that should be a separate session/note?"

    python3 <<PYEOF
import json
print(json.dumps({"additionalContext": """$MSG"""}))
PYEOF
    exit 0
fi

echo '{"ok": true}'
exit 0
