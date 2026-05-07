#!/bin/bash
# Send macOS notification when Claude finishes a turn (silent on non-macOS).
osascript -e 'display notification "Claude Code finished working" with title "Claude Code" sound name "Glass"' 2>/dev/null
echo '{"ok": true}'
exit 0
