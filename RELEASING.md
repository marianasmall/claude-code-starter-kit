# Releasing a change

The 0.2.0 release shipped two bugs that every check passed: a `hooks.json` Claude Code refused to load, and a `/kit:verify` that couldn't find the installed kit. Both were invisible from the repo folder and only showed up on a real install. This checklist exists so that doesn't happen again.

## Automatic (runs on every PR, every push to main, and every Monday)

`.github/workflows/check.yml` runs these on Linux and macOS with the latest Claude Code. A PR shouldn't merge while any of them is red.

| Check | What it catches |
|---|---|
| `claude plugin validate --strict .` | Manifest, hooks, commands, agents and skills that Claude Code would reject or ignore |
| `bash scripts/verify-hooks.sh` | Hooks that are unwired, not executable, broken, or don't block what they should |
| `bash scripts/install-test.sh` | Anything that only breaks after a real install: the plugin not installing, `/kit:verify` not finding the kit, the drill failing from the installed copy |

You can run all three locally the same way. None of them need a login.

## By hand, before tagging a release

1. **Bump the version** in `.claude-plugin/plugin.json` and add a `CHANGELOG.md` entry. Users only get the update through `/plugin update kit` when the version changes.
2. **Check the counts in the docs.** If you added or removed a hook, command, agent, skill or recipe, make sure README, INSTALL, getting-started and ARCHITECTURE all give the same numbers.
3. **Fresh install on Windows (WSL).** CI covers Linux and macOS. Ask a Windows tester to run `/plugin update kit` (or a fresh install), then `/kit:verify`, and to send the output.
4. **If the change fixes something users already have installed,** say in the CHANGELOG what they need to do (usually `/plugin update kit`, then `/kit:verify`).
