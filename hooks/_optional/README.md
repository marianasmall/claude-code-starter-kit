# Optional hooks (not wired)

These scripts are kept for anyone who wants them, but they aren't registered in `hooks/hooks.json`, so they never run unless you wire them in yourself.

- `scope-creep-detector.sh` (UserPromptSubmit): warns when later prompts drift from the session's first ask. It only does anything when `SCOPE_CREEP_ENABLED=1` is set in your shell.
- `stop-check.sh` (Stop): returns an empty "ok" and nothing else. It's kept only as a template for writing your own Stop hook.

To use one, move it back into `hooks/scripts/`, make it executable (`chmod +x`), and add an entry for it under the right event in `hooks/hooks.json`. Then run `/kit:verify` to see it fire.
