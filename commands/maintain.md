---
name: maintain
description: Periodic system maintenance sweep — updates, health checks, cleanup
argument-hint: "[full|quick]"
---

# System Maintenance: $ARGUMENTS

Run a structured maintenance sweep of the development environment. This keeps tools current, catches drift, and prevents silent failures from accumulating between sessions. Recommended cadence: twice weekly.

**Mode selection:**
- If `$ARGUMENTS` is empty or "full": run all checks below
- If `$ARGUMENTS` is "quick": run only Sections 1-3 (package updates, no audits)

---

## Section 1: Package Updates

Check what's outdated first, then present a summary before upgrading anything.

### 1a. Homebrew (macOS)
```
brew update
brew outdated
```
Show the outdated list. If user approves, run `brew upgrade`. After upgrading, run `brew cleanup` to reclaim disk space.

### 1b. Python (pip)
```
pip list --outdated
```
Show outdated packages. Only upgrade packages the user actively uses (don't blindly upgrade everything — pip dependency conflicts are real).

### 1c. Node.js / npm globals
```
npm outdated -g
```
Show outdated global packages. Upgrade with approval.

### 1d. Runtime versions
```
node --version
python3 --version
```
Flag if either is more than one major version behind current stable.

---

## Section 2: Claude Code Health

### 2a. Claude Code version
```
claude --version
```
Report current version. Note: Claude Code auto-updates via native installer, so this is informational. Flag if the version seems old.

### 2b. MCP server status
Check which MCP servers are configured and whether they respond:
- Read MCP config from `~/.claude.json` and any `.mcp.json` files
- For each server, note if it's configured and check for obvious issues (missing binaries, expired tokens)
- Flag any servers that haven't been used recently or have known issues

### 2c. Plugin health
- List installed plugins (`/plugin` in Claude Code, or check `~/.claude/settings.json` `enabledPlugins`)
- Check for any plugin updates available

### 2d. New features & changelog
Check what's new in Claude Code since the last maintenance run:
1. Fetch `https://github.com/anthropics/claude-code/releases` via WebFetch
2. Compare the latest release version against the current installed version
3. Scan release notes for **new features, new flags, new plugin types, deprecations, and breaking changes**
4. Present a summary:
   - **New capabilities** — things the user can now do that they couldn't before
   - **Breaking changes** — anything that might affect current setup
   - **New docs pages** — topics that didn't exist before
5. If any new capability is relevant to the user's workflows, flag it with a one-line "why this matters for you"

---

## Section 3: Hook & Script Health

### 3a. Hook scripts
For every hook configured in `~/.claude/settings.json` and any plugin `hooks.json`:
- Verify the script file exists at the specified path
- Verify it's executable (`chmod +x`)
- Run a basic syntax check (`bash -n <script>`)
- Flag any hooks that reference files or commands that don't exist

### 3b. Statusline
- Verify `~/.claude/statusline.sh` exists, is executable, and passes syntax check
- Test it with a mock JSON input to verify it produces output without errors

### 3c. Plugin integrity
- Run `claude --debug` briefly and watch for plugin load errors
- Check that plugin paths in settings.json point to existing directories

---

## Section 4: Repository Audit (skip in quick mode)

### 4a. Secrets exposure scan (CRITICAL — never skip in full mode)
For each user-owned repo (typically under `~/Projects/` or similar):
```
gitleaks detect --source <repo> --no-banner --no-git -r /tmp/leaks-$(basename <repo>).json 2>/dev/null
gitleaks detect --source <repo> --no-banner -r /tmp/leaks-history-$(basename <repo>).json 2>/dev/null
```
The first scans the working tree; the second scans git history.

If ANY findings: this is a **CREDENTIAL ROTATION EVENT**. Flag prominently with:
- Repo name + file path + secret type (don't echo the secret value back)
- Recommended remediation: rotate the credential, then clean history with BFG or git-filter-repo, then force-push

(Requires `gitleaks` installed. Skip with note if not available.)

### 4b. Uncommitted work across projects
Scan the user's project root for repos with:
- Uncommitted changes (dirty working tree)
- Unpushed commits on any branch
- Branches with no upstream tracking

Present a summary table:
| Repo | Status | Unpushed | Dirty Files |
|------|--------|----------|-------------|

### 4c. Stale repos
Check `git log -1 --format=%cr` for last commit date. Flag repos with no commits in 60+ days as candidates for review.

---

## Section 5: Credential & Token Health (skip in quick mode)

### 5a. API keys
- Verify `~/.env.local` exists if user has hooks that depend on it
- Do NOT display key values — just confirm they exist and are non-empty
- If Pushover is configured, send a test notification ("Maintenance check — credentials OK")

### 5b. OAuth tokens
- Check any OAuth tokens (e.g., Google API token files) for expiry
- Test with a lightweight API call if possible

---

## Section 6: Cleanup (skip in quick mode)

### 6a. Stale backup files
The `backup-before-edit` hook creates timestamped copies before every edit:
```
find ~/Projects -path "*/_backups/*" -mtime +14 -type f
find ~/.claude -path "*/_backups/*" -mtime +14 -type f
```
Show count and total size of backups older than 14 days. Offer to delete with approval.

### 6b. Stale session temp files
```
find /tmp -name "claude-ctx-*" -mtime +1 2>/dev/null
find /tmp -name "claude-pushover-*" -mtime +1 2>/dev/null
```
Show count. Offer to clean up.

### 6c. Disk space check
```
df -h /
du -sh ~/.claude/ 2>/dev/null
```
Flag if disk is above 85% full or `~/.claude/` is unusually large.

---

## Presentation

After all checks complete, present a maintenance summary:

```
MAINTENANCE SUMMARY — [date]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚨 Secrets exposure:   Clean / N findings (ROTATION REQUIRED)
Packages updated:    X of Y outdated packages upgraded
Hooks:               All OK / N issues found
MCP servers:         All responding / N issues
Repos:               X with uncommitted work / Y stale (60d+)
Credentials:         All valid / N expired
Cleanup:             Xmb recovered / nothing to clean
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Next maintenance:    [date + 3-4 days]
```

If Secrets row is non-zero, surface it as the top action item before any other reporting.

If any issues were found that couldn't be auto-fixed, list them as action items at the bottom.
