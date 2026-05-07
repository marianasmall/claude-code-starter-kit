---
name: permissions-audit
description: Review settings.json permissions — flag overly broad rules, identify likely-unused ones, suggest pruning.
---

# /permissions-audit

Audit `~/.claude/settings.json` permissions for security and tidiness.

## What to do

### 1. Read the settings

Read `~/.claude/settings.json` and parse the `permissions.allow` array.

### 2. Categorize entries

Group into:
- **Wildcard rules** (e.g., `Bash(*)`, `mcp__*__*`) — broadest, highest risk
- **Tool-prefix wildcards** (e.g., `Bash(git:*)`, `mcp__notion__*`) — moderate
- **Specific commands** (e.g., `Bash(brew upgrade)`)
- **Comments** (start with `#` — purely organizational, ignore for audit)

### 3. Flag concerns

For each entry, check:

| Concern | Example | Severity |
|---|---|---|
| Overly broad shell access | `Bash(*)` | HIGH |
| Wildcard MCP server | `mcp__server__*` | LOW (usually fine, but note it) |
| Domain wildcards in WebFetch | `WebFetch(domain:*)` | HIGH (allows fetching from anywhere) |
| Permission for a tool that no longer exists | `mcp__deleted_server__*` | LOW (cleanup) |
| Duplicate or near-duplicate rules | `Bash(git:*)` AND `Bash(git push:*)` | LOW (redundant, prune later one) |

### 4. Identify likely-unused

For each MCP wildcard, check `~/.claude.json` and any `.mcp.json` files to see if the server is still configured. If not, the permission is dead weight.

### 5. Present findings

```
PERMISSIONS AUDIT — N total rules
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🚨 HIGH-RISK rules (review carefully):
  - Bash(*)                              # too broad
  - WebFetch(domain:*)                   # allows any URL

⚠️  MODERATE notes:
  - mcp__some_server__*                  # wildcard ok, but server is deprecated

✓ Likely safe:
  - 64 specific rules (Bash, mcp__*, etc.)

🧹 Cleanup candidates:
  - mcp__deleted_server__*               # server no longer exists
  - Bash(git push:*)                     # redundant with Bash(git:*)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Recommended: prune cleanup candidates, narrow HIGH-RISK rules to specific patterns.
```

### 6. Offer to act

Ask: "Want me to (a) remove the cleanup candidates, (b) narrow the HIGH-RISK rules with specific patterns, or (c) leave as-is and just keep the audit for review?"

If (a) or (b): make the changes via Edit, but **always backup first** (Edit triggers backup-before-edit hook automatically).

Show the diff after editing.

## Why this exists

`settings.json` accumulates permissions over time as users approve things. Most never get pruned. Periodic audit keeps the security surface small and helps you notice when you've accidentally said "yes" too broadly.
