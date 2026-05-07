#!/bin/bash
# Safety Net — PreToolUse hook for Bash commands
#
# Catches destructive filesystem and git commands BEFORE they execute.
# Goes beyond simple pattern matching — detects:
#   - Direct destructive commands (rm -rf, git reset --hard, etc.)
#   - Shell wrapper bypass attempts (bash -c "rm -rf /")
#   - Interpreter one-liners (python3 -c "import shutil; shutil.rmtree('/')")
#   - Pipe-to-shell patterns (curl ... | bash)
#   - Protected path access (attempts to modify critical system/config files)
#
# Returns {"error": "..."} to BLOCK the command.
# Returns {"ok": true} to ALLOW the command.

INPUT=$(cat)

# Extract the tool name and command from hook input
TOOL_NAME=$(echo "$INPUT" | python3 -c "import sys,json; print(json.load(sys.stdin).get('tool_name',''))" 2>/dev/null)

# Only check Bash tool calls
if [ "$TOOL_NAME" != "Bash" ]; then
    echo '{"ok": true}'
    exit 0
fi

# Extract the command being run
COMMAND=$(echo "$INPUT" | python3 -c "import sys,json; print(json.load(sys.stdin).get('tool_input',{}).get('command',''))" 2>/dev/null)

if [ -z "$COMMAND" ]; then
    echo '{"ok": true}'
    exit 0
fi

# Normalize: lowercase for pattern matching, preserve original for reporting
CMD_LOWER=$(echo "$COMMAND" | tr '[:upper:]' '[:lower:]')

# ── DESTRUCTIVE FILESYSTEM COMMANDS ──────────────────────────────

# rm -rf with dangerous targets (root, home, broad wildcards)
if echo "$CMD_LOWER" | grep -qE 'rm\s+(-[a-z]*r[a-z]*f|-[a-z]*f[a-z]*r)\s+(/\s|~/|/Users|/home|/etc|/var|/System|\.\s|\.\.|\*\s)'; then
    echo '{"error": "BLOCKED: Destructive rm -rf targeting dangerous path. This could delete critical files."}'
    exit 0
fi

# rm -rf / or rm -rf /* specifically
if echo "$CMD_LOWER" | grep -qE 'rm\s+(-[a-z]*r[a-z]*f|-[a-z]*f[a-z]*r)\s+/(\s|$|\*)'; then
    echo '{"error": "BLOCKED: rm -rf on root filesystem. This would destroy the entire system."}'
    exit 0
fi

# chmod/chown 777 on broad paths
if echo "$CMD_LOWER" | grep -qE '(chmod|chown)\s+(-[a-z]*R[a-z]*\s+)?(777|000)\s+/'; then
    echo '{"error": "BLOCKED: Recursive permission change on root path. This could break system permissions."}'
    exit 0
fi

# mkfs / format commands
if echo "$CMD_LOWER" | grep -qE '(mkfs|newfs|diskutil\s+eraseDisk|diskutil\s+eraseVolume)'; then
    echo '{"error": "BLOCKED: Disk format command detected. This would destroy all data on the target disk."}'
    exit 0
fi

# dd writing to disk devices
if echo "$CMD_LOWER" | grep -qE 'dd\s+.*of=/dev/(disk|sd|nvme|hd)'; then
    echo '{"error": "BLOCKED: dd writing to raw disk device. This could overwrite the entire disk."}'
    exit 0
fi

# ── DESTRUCTIVE GIT COMMANDS ─────────────────────────────────────

# git reset --hard (without specific commit = dangerous)
if echo "$CMD_LOWER" | grep -qE 'git\s+reset\s+--hard'; then
    echo '{"error": "BLOCKED: git reset --hard discards all uncommitted changes irreversibly. Use git stash instead, or confirm with the user first."}'
    exit 0
fi

# git clean -f (deletes untracked files)
if echo "$CMD_LOWER" | grep -qE 'git\s+clean\s+(-[a-z]*f|-[a-z]*d[a-z]*f|-[a-z]*f[a-z]*d)'; then
    echo '{"error": "BLOCKED: git clean -f permanently deletes untracked files. These cannot be recovered."}'
    exit 0
fi

# git push --force to main/master
if echo "$CMD_LOWER" | grep -qE 'git\s+push\s+(-[a-z]*f|--force|--force-with-lease)\s+.*(main|master)'; then
    echo '{"error": "BLOCKED: Force push to main/master can destroy remote history. Confirm with the user first."}'
    exit 0
fi

# git checkout . or git restore . (discards all changes)
if echo "$CMD_LOWER" | grep -qE 'git\s+(checkout|restore)\s+\.\s*$'; then
    echo '{"error": "BLOCKED: This discards ALL uncommitted changes in the working directory. Use git stash if you want to save them."}'
    exit 0
fi

# git branch -D (force delete)
if echo "$CMD_LOWER" | grep -qE 'git\s+branch\s+-D\s'; then
    echo '{"error": "BLOCKED: git branch -D force-deletes a branch even if not merged. Use -d (lowercase) for safe deletion."}'
    exit 0
fi

# ── SHELL WRAPPER / INTERPRETER BYPASS DETECTION ─────────────────

# bash/sh/zsh -c with destructive content
if echo "$CMD_LOWER" | grep -qE '(bash|sh|zsh)\s+-c\s+.*\b(rm\s+-rf|mkfs|dd\s+.*of=/dev|git\s+reset\s+--hard)'; then
    echo '{"error": "BLOCKED: Destructive command inside shell wrapper detected."}'
    exit 0
fi

# Python one-liners with destructive imports
if echo "$CMD_LOWER" | grep -qE 'python[23]?\s+-c\s+.*\b(shutil\.rmtree|os\.remove|os\.unlink|os\.rmdir|subprocess.*rm)'; then
    echo '{"error": "BLOCKED: Destructive Python one-liner detected (file/directory removal via interpreter)."}'
    exit 0
fi

# Ruby one-liners with destructive calls
if echo "$CMD_LOWER" | grep -qE 'ruby\s+-e\s+.*\b(FileUtils\.rm_rf|File\.delete|Dir\.rmdir)'; then
    echo '{"error": "BLOCKED: Destructive Ruby one-liner detected."}'
    exit 0
fi

# Node one-liners with destructive calls
if echo "$CMD_LOWER" | grep -qE 'node\s+-e\s+.*\b(fs\.rm|fs\.unlink|rimraf|del)'; then
    echo '{"error": "BLOCKED: Destructive Node.js one-liner detected."}'
    exit 0
fi

# ── PIPE-TO-SHELL PATTERNS ───────────────────────────────────────

# curl/wget piped to bash/sh (remote code execution)
if echo "$CMD_LOWER" | grep -qE '(curl|wget)\s+.*\|\s*(bash|sh|zsh|sudo\s+bash|sudo\s+sh)'; then
    echo '{"error": "BLOCKED: Piping remote content to shell (curl|bash pattern). This executes arbitrary remote code. Download first, inspect, then run."}'
    exit 0
fi

# ── PROTECTED PATHS ──────────────────────────────────────────────

# Direct modification of .zshrc, .bashrc, .ssh (without backup hook)
if echo "$CMD_LOWER" | grep -qE '(>\s*|tee\s+)(~/|/Users/\w+/)\.(zshrc|bashrc|bash_profile|ssh/|gnupg/)'; then
    echo '{"error": "BLOCKED: Direct write to protected dotfile. Use Edit tool (which triggers backup hook) instead of shell redirection."}'
    exit 0
fi

# ── CREDENTIAL / SECRET EXPOSURE ─────────────────────────────────

# Echoing or catting env files to stdout (potential leak in logs)
if echo "$CMD_LOWER" | grep -qE '(cat|echo\s+\$|printenv|env\s*$)\s*.*\.(env|env\.local|env\.production)'; then
    echo '{"error": "BLOCKED: Potential credential exposure. Avoid printing .env files to output. Read specific vars instead."}'
    exit 0
fi

# ── ALL CLEAR ────────────────────────────────────────────────────
echo '{"ok": true}'
exit 0
