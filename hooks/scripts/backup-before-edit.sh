#!/bin/bash
# Backup files before Claude overwrites them
# Creates timestamped copies in a _backups folder next to the original

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

# Skip backups for ephemeral/temp paths (reduces noise, saves disk)
case "$FILE_PATH" in
  /tmp/*|/private/tmp/*|*/tool-results/*|*/.claude/projects/*/tool-results/*)
    exit 0
    ;;
esac

# Only proceed if we have a file path and the file already exists
if [ -n "$FILE_PATH" ] && [ -f "$FILE_PATH" ]; then
  DIR=$(dirname "$FILE_PATH")
  FILENAME=$(basename "$FILE_PATH")
  BACKUP_DIR="$DIR/_backups"
  TIMESTAMP=$(date +%Y%m%d_%H%M%S)

  mkdir -p "$BACKUP_DIR"
  cp "$FILE_PATH" "$BACKUP_DIR/${FILENAME}.${TIMESTAMP}.bak"
fi

# Always allow the edit to proceed
exit 0
