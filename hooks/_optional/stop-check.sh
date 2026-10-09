#!/bin/bash
# Stop hook: always returns valid JSON so session end never fails.
# Verification behavior is handled by CLAUDE.md instructions, not enforced here.
# This hook exists to be bulletproof.
echo '{"ok": true}'
exit 0
