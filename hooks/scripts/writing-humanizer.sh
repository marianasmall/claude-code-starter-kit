#!/bin/bash
# Writing Humanizer — PostToolUse hook for Write|Edit on long-form text.
#
# When Claude writes a long piece of prose (>500 words, or specific extensions
# like .md/.txt/.docx), nudges Claude to apply the humanizer skill before
# considering the work complete. This catches AI-tells in the moment of
# creation rather than at delivery review.
#
# Triggers on:
#   - Write of a .md, .txt, .docx, or no-extension text file with body > 500 words
#   - Edit replacing >300 words of content
#
# Skips:
#   - Code files (.py, .ts, .js, .sh, .json, etc.)
#   - Config files
#   - Files in .claude/ or hooks/ directories (those are infrastructure)

INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | python3 -c "import sys,json; print(json.load(sys.stdin).get('tool_name',''))" 2>/dev/null)

if [ "$TOOL_NAME" != "Write" ] && [ "$TOOL_NAME" != "Edit" ]; then
    echo '{"ok": true}'
    exit 0
fi

FILE_PATH=$(echo "$INPUT" | python3 -c "import sys,json; print(json.load(sys.stdin).get('tool_input',{}).get('file_path',''))" 2>/dev/null)

if [ -z "$FILE_PATH" ]; then
    echo '{"ok": true}'
    exit 0
fi

# Skip infrastructure paths
case "$FILE_PATH" in
    */.claude/*|*/hooks/*|*/scripts/*|*/.git/*|*/node_modules/*) exit 0 ;;
esac

# Only check long-form text extensions
case "$FILE_PATH" in
    *.md|*.txt|*.docx|*.rst|*.org) ;;
    *) exit 0 ;;
esac

# Extract content and check length
WORD_COUNT=$(echo "$INPUT" | python3 -c "
import sys, json
try:
    d = json.load(sys.stdin).get('tool_input', {})
    content = d.get('content') or d.get('new_string') or ''
    print(len(content.split()))
except Exception:
    print(0)
" 2>/dev/null)

if [ -z "$WORD_COUNT" ] || [ "$WORD_COUNT" -lt 500 ]; then
    echo '{"ok": true}'
    exit 0
fi

# Long-form prose written — nudge humanizer
FILENAME=$(basename "$FILE_PATH")
MSG="WRITING-HUMANIZER: ${FILENAME} contains ~${WORD_COUNT} words of long-form prose. Before considering this work complete, apply the humanizer skill: scan for AI-tells (em-dash overuse, 'delve', 'multifaceted', 'tapestry', tricolons, hedging openers, every-sentence-same-length rhythm) and rewrite affected sections. Particularly important if this is client-facing or public-facing content."

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
