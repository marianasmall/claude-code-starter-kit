#!/bin/bash
# Self-Guard — PreToolUse hook for Write|Edit on hook/script files.
#
# Catches Claude authoring destructive hooks/scripts without a DRY_RUN gate.
# This protects against a class of bug where a script with mirror-deletion
# logic looks correct, runs clean end-to-end, and silently deletes legitimate
# files — only caught after the fact by inspecting `git show --stat HEAD`.
#
# Behavior: BLOCKS (permissionDecision: deny) when a script destined for
# ~/.claude/hooks/*.sh or similar contains destructive patterns but no
# DRY_RUN safeguard. Remediation is clear: add the gate, retry.
#
# Strips bash comments and quoted strings before pattern-matching to avoid
# false positives on checker scripts like safety-net.sh (which mentions
# "rm -rf" and "git reset --hard" inside regex patterns).

INPUT=$(cat)

TOOL_NAME=$(echo "$INPUT" | python3 -c "import sys,json; print(json.load(sys.stdin).get('tool_name',''))" 2>/dev/null)

# Only check Write and Edit
if [ "$TOOL_NAME" != "Write" ] && [ "$TOOL_NAME" != "Edit" ]; then
    echo '{"ok": true}'
    exit 0
fi

FILE_PATH=$(echo "$INPUT" | python3 -c "import sys,json; print(json.load(sys.stdin).get('tool_input',{}).get('file_path',''))" 2>/dev/null)

if [ -z "$FILE_PATH" ]; then
    echo '{"ok": true}'
    exit 0
fi

# Only check shell scripts in hook/script locations
case "$FILE_PATH" in
    */.claude/hooks/*.sh) ;;
    */scripts/*.sh) ;;
    */bin/*.sh) ;;
    *.zsh|*.bash) ;;
    *) echo '{"ok": true}'; exit 0 ;;
esac

# Extract content: "content" for Write, "new_string" for Edit
CONTENT=$(echo "$INPUT" | python3 -c "
import sys, json
d = json.load(sys.stdin).get('tool_input', {})
print(d.get('content') or d.get('new_string') or '')
" 2>/dev/null)

if [ -z "$CONTENT" ]; then
    echo '{"ok": true}'
    exit 0
fi

# Strip comments and quoted strings before pattern matching.
# This avoids false positives on checker/lint scripts that MENTION
# destructive commands in regex patterns or error messages without
# actually executing them.
CLEANED=$(echo "$CONTENT" | python3 -c "
import sys, re
text = sys.stdin.read()
out = []
for line in text.split('\n'):
    # Drop full-line comments
    if re.match(r'^\s*#', line):
        continue
    # Blank out single-quoted content
    line = re.sub(r\"'[^']*'\", \"''\", line)
    # Blank out double-quoted content
    line = re.sub(r'\"[^\"]*\"', '\"\"', line)
    out.append(line)
print('\n'.join(out))
" 2>/dev/null)

# Check for destructive patterns in the cleaned content
REASONS=""
if echo "$CLEANED" | grep -qE '\bgit[[:space:]]+commit\b'; then
    REASONS="${REASONS}  - auto-commit (git commit)\n"
fi
if echo "$CLEANED" | grep -qE '\bgit[[:space:]]+push\b'; then
    REASONS="${REASONS}  - auto-push (git push)\n"
fi
if echo "$CLEANED" | grep -qE '\brm[[:space:]]+-[a-zA-Z]*[rR][a-zA-Z]*[fF]|\brm[[:space:]]+-[a-zA-Z]*[fF][a-zA-Z]*[rR]'; then
    REASONS="${REASONS}  - recursive deletion (rm -rf)\n"
fi
if echo "$CLEANED" | grep -qE 'rsync[^|]*--delete'; then
    REASONS="${REASONS}  - mirror deletion (rsync --delete)\n"
fi
if echo "$CLEANED" | grep -qE '\bgit[[:space:]]+reset[[:space:]]+--hard\b'; then
    REASONS="${REASONS}  - git reset --hard\n"
fi
if echo "$CLEANED" | grep -qE '\bfind\b[^|]*(-delete|-exec[[:space:]]+rm)'; then
    REASONS="${REASONS}  - find -delete or find -exec rm\n"
fi

# No destructive patterns → allow
if [ -z "$REASONS" ]; then
    echo '{"ok": true}'
    exit 0
fi

# Destructive patterns present — require DRY_RUN safeguard anywhere in original content
if echo "$CONTENT" | grep -qE 'DRY_RUN|--dry-run|DRYRUN|dry_run'; then
    echo '{"ok": true}'
    exit 0
fi

# Block with clear remediation instructions
REASON_TEXT=$(printf "Destructive logic without DRY_RUN gate in %s:\n%b\nRemediation: add a DRY_RUN gate (e.g., DRY_RUN=\${DRY_RUN:-0} and [ \"\$DRY_RUN\" = \"1\" ] && echo 'would ...' && exit 0) OR dry-run test the script on throwaway inputs, then retry." "$FILE_PATH" "$REASONS")

python3 <<PYEOF
import json, sys
reason = """$REASON_TEXT"""
print(json.dumps({
    "hookSpecificOutput": {
        "hookEventName": "PreToolUse",
        "permissionDecision": "deny",
        "permissionDecisionReason": reason
    }
}))
PYEOF
exit 0
