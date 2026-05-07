#!/bin/bash
# Retry-Nudge — PostToolUse hook.
#
# Catches the pattern: Claude hits a validation-style error once, then punts
# to the user ("I'm not sure about the format, can you help?") instead of
# fixing and retrying. Validation errors are usually fixable in 1-2 tries —
# this hook nudges Claude to retry before escalating.
#
# Behavior: per-session state file tracks (tool, error_signature) → count.
# Nudges on count 1 and 2 (retry is usually the right move). At count 3,
# advises escalation instead of more retries. Only fires on validation-style
# errors — skips auth (401/403), network (timeout/ECONN), rate limits (429),
# not-found (404). These error classes usually need escalation, not retry.
#
# Non-blocking: advisory via stdout systemMessage. Never prevents Claude
# from proceeding — the nudge is information, not enforcement.

INPUT=$(cat)

SESSION_ID=$(echo "$INPUT" | python3 -c "import sys,json; print(json.load(sys.stdin).get('session_id','default'))" 2>/dev/null)
TOOL_NAME=$(echo "$INPUT" | python3 -c "import sys,json; print(json.load(sys.stdin).get('tool_name',''))" 2>/dev/null)

if [ -z "$TOOL_NAME" ]; then
    exit 0
fi

# Skip read-only inspection tools — their content frequently contains words
# like "error", "failed", "invalid" from file bodies, docs, or logs. These
# are not tool errors and nudging on them is noise.
case "$TOOL_NAME" in
    Read|Glob|Grep|LS|NotebookRead|TodoRead|WebFetch|WebSearch) exit 0 ;;
esac

# Determine if tool errored and classify, using STRUCTURAL signals on the
# tool_response object (not text keyword matching on the full body). This
# avoids false positives where successful responses contain error-adjacent
# words in their content payload.
ERROR_CLASS=$(echo "$INPUT" | python3 -c "
import sys, json

try:
    d = json.load(sys.stdin)
except Exception:
    print('none')
    sys.exit()

resp = d.get('tool_response', {})

# Structural error check: explicit error flags at the top level
has_error = False
error_text = ''
if isinstance(resp, dict):
    if resp.get('isError') is True or resp.get('is_error') is True:
        has_error = True
        # Extract error text from common locations
        if isinstance(resp.get('content'), list):
            for item in resp['content']:
                if isinstance(item, dict) and item.get('type') == 'text':
                    error_text += item.get('text', '') + ' '
        error_text += str(resp.get('error', ''))
    elif isinstance(resp.get('error'), (str, dict)):
        # Top-level error field is a strong signal
        has_error = True
        error_text = json.dumps(resp.get('error'))
    elif resp.get('status') in (400, 401, 403, 404, 429, 500, 502, 503):
        has_error = True
        error_text = json.dumps(resp)
elif isinstance(resp, str):
    # Some tools return a raw string; only treat as error if it starts with an
    # explicit error marker (not just containing the word somewhere)
    stripped = resp.lstrip().lower()
    if stripped.startswith(('error:', 'error ', 'traceback', 'exception:', 'failed:', 'invalid:')):
        has_error = True
        error_text = resp

if not has_error:
    print('none')
    sys.exit()

text = error_text.lower()

# Auth / permission → skip nudge
if any(x in text for x in ['401', '403', 'unauthorized', 'forbidden', 'permission denied', 'access denied']):
    print('auth')
    sys.exit()

# Network → skip nudge
if any(x in text for x in ['timeout', 'econnrefused', 'enotfound', 'connection refused', 'connection reset', 'dns lookup', 'network error']):
    print('network')
    sys.exit()

# Rate limit → skip nudge
if any(x in text for x in ['rate limit', 'rate_limit', 'too many requests', '\"status\": 429']):
    print('rate')
    sys.exit()

# Not found — usually legit, not validation
if any(x in text for x in ['404', 'not found', 'does not exist', 'no such file', 'no such table']):
    print('notfound')
    sys.exit()

# Validation patterns
val_markers = [
    'validation', 'invalid_request', 'badrequest', 'bad request', '\"status\": 400',
    'schema', 'must be', 'expected', 'is not valid', 'is not a valid',
    'required field', 'missing required', 'wrong type', 'type mismatch',
    'unknown field', 'invalid format', 'invalid parameter', 'invalid argument',
    'body failed validation', 'should be'
]
if any(x in text for x in val_markers):
    print('validation')
    sys.exit()

print('unknown')
" 2>/dev/null)

# Only nudge on validation errors
if [ "$ERROR_CLASS" != "validation" ]; then
    exit 0
fi

# Build normalized error signature for state keying — pull the error text
# from the structured response, not from the whole input body.
ERROR_SIG=$(echo "$INPUT" | python3 -c "
import sys, re, json, hashlib

try:
    d = json.load(sys.stdin)
except Exception:
    print('default')
    sys.exit()

resp = d.get('tool_response', {})
candidate = ''
if isinstance(resp, dict):
    if isinstance(resp.get('content'), list):
        for item in resp['content']:
            if isinstance(item, dict) and item.get('type') == 'text':
                candidate = item.get('text', '')
                break
    if not candidate and resp.get('error'):
        candidate = json.dumps(resp['error']) if not isinstance(resp['error'], str) else resp['error']
    if not candidate:
        candidate = json.dumps(resp)[:400]
elif isinstance(resp, str):
    candidate = resp[:400]

# Normalize: strip long quoted values, hex IDs, digits, whitespace
norm = re.sub(r'\"[^\"]{6,}\"', '\"X\"', candidate)
norm = re.sub(r'\b[0-9a-f]{8,}\b', 'HEX', norm)
norm = re.sub(r'\b\d+\b', 'N', norm)
norm = re.sub(r'\s+', ' ', norm).strip()[:120]
print(hashlib.md5(norm.encode()).hexdigest()[:10] if norm else 'default')
" 2>/dev/null)

if [ -z "$ERROR_SIG" ]; then
    ERROR_SIG="default"
fi

# Update per-session state
STATE_DIR="$HOME/.claude/hooks/state"
STATE_FILE="$STATE_DIR/retry-${SESSION_ID}.json"
mkdir -p "$STATE_DIR" 2>/dev/null

COUNT=$(python3 - <<PYEOF 2>/dev/null
import json, os
path = "$STATE_FILE"
key = "${TOOL_NAME}:${ERROR_SIG}"
state = {}
if os.path.exists(path):
    try:
        with open(path) as f:
            state = json.load(f)
    except Exception:
        state = {}
state[key] = state.get(key, 0) + 1
with open(path, 'w') as f:
    json.dump(state, f)
print(state[key])
PYEOF
)

if [ -z "$COUNT" ]; then
    COUNT=1
fi

# Emit nudge via hookSpecificOutput additionalContext (visible to Claude)
if [ "$COUNT" -le 2 ]; then
    MSG="RETRY-NUDGE (attempt ${COUNT}/3 on ${TOOL_NAME}): Validation-style error detected (not auth/network/rate-limit). This class is usually fixable — check the error, adjust format/schema/parameters, and retry before escalating. Most validation errors resolve in 1-2 tries."
elif [ "$COUNT" -eq 3 ]; then
    MSG="RETRY-NUDGE (attempt 3/3 on ${TOOL_NAME}): Same validation signature 3x. Stop retrying the same fix — either read the tool schema, check docs, try a simpler payload to isolate, or escalate to the user. More of the same won't work."
else
    exit 0
fi

python3 <<PYEOF
import json
print(json.dumps({
    "hookSpecificOutput": {
        "hookEventName": "PostToolUse",
        "additionalContext": """$MSG"""
    }
}))
PYEOF
exit 0
