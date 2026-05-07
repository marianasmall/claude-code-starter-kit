# Worktrees Primer

Git worktrees are an underused feature that pair beautifully with Claude Code for parallel work on the same repo.

## What they are

A git worktree is a checkout of the same repository at a *different working directory* on a *different branch*. You can have one repo with many worktrees, each on its own branch, all simultaneously editable.

```
~/projects/my-app/                  # main worktree (main branch)
~/projects/my-app-feature-x/        # worktree for branch feature-x
~/projects/my-app-bugfix-y/         # worktree for branch bugfix-y
```

All three share the same `.git/` (under the hood) but each has its own files, branch, and working state.

## Why this matters for Claude Code

Without worktrees, parallel sessions on the same repo conflict:
- Session A is editing files on branch `feature-x`
- Session B wants to fix a bug on `main`
- They have to take turns

With worktrees, each session works in its own directory on its own branch. No conflicts.

## How to create a worktree

```
cd ~/projects/my-app
git worktree add ../my-app-feature-x feature-x
```

This creates `~/projects/my-app-feature-x/` as a new working directory checked out to the `feature-x` branch. If the branch doesn't exist yet:

```
git worktree add -b feature-x ../my-app-feature-x main
```

## Working with Claude Code in a worktree

Open a Claude Code session in the worktree:

```
cd ~/projects/my-app-feature-x
claude
```

Claude treats it like any other directory. The starter kit's `user-prompt-context.sh` hook will inject project state from the worktree (CONTEXT-SUMMARY.md or PLANNING.md if present).

The custom statusline in this kit shows a `wt:<name>` tag when you're in a worktree, so you always know which worktree you're in.

## When to use worktrees

✅ Good fits:
- **Long-running feature work + occasional hotfixes** — keep main worktree clean for hotfixes
- **Comparing approaches** — try approach A in one worktree, approach B in another, compare
- **Parallel Claude sessions** — different problems, same repo
- **Long-running PR review** — keep your branch checked out while reviewing someone else's

❌ Skip worktrees for:
- One-off branches that you'll merge and delete in the same day (just stash and switch)
- Repos where the build process pollutes the directory (worktrees can confuse build tools)

## Cleaning up

Done with a worktree?

```
git worktree remove ../my-app-feature-x
```

This deletes the directory. The branch still exists in the main repo's `.git/` (delete the branch separately if you want).

To list active worktrees:

```
git worktree list
```

## Worktrees + the `superpowers` plugin

The `superpowers` plugin (in this kit's recommended `enabledPlugins`) has agents that can launch in their own worktree:

```
Agent({
  isolation: "worktree",
  ...
})
```

When `isolation: "worktree"` is set, the agent works in a temporary git worktree. If the agent doesn't make changes, the worktree gets auto-cleaned. If it does, you get a clean branch with just that agent's changes.

This is great for:
- Agents that explore aggressively (try things, see what works)
- Parallel agents that all need their own clean state
- Speculative builds where you might want to throw the result away

## Common gotchas

- **Can't check out the same branch in two worktrees** — git enforces this. Switch branches in one worktree first.
- **Build artifacts** — Most build systems write to `node_modules/`, `target/`, `__pycache__/`, etc. Each worktree gets its own. This means each worktree triggers a full install/compile the first time.
- **Editor projects** — VS Code, JetBrains, etc. usually treat each worktree as a separate project. That's correct, but it means more open windows.

## Quick reference

| Command | What it does |
|---|---|
| `git worktree list` | List active worktrees |
| `git worktree add <path> <branch>` | Create a worktree on existing branch |
| `git worktree add -b <new-branch> <path> <base>` | Create a worktree on a new branch |
| `git worktree remove <path>` | Delete a worktree (must be clean) |
| `git worktree prune` | Clean up worktree records for deleted directories |
