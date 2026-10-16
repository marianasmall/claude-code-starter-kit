# Project Conventions

**This page moved.** The current project standard lives in **[never-lose-a-project.md](never-lose-a-project.md)**:

- [The project package](never-lose-a-project.md#part-1-the-project-package): README, AGENTS.md with a one-line CLAUDE.md, PLANNING, numbered decisions, newest-first handoff, and a gitignored `_private/` folder
- [The session-continuity loop](never-lose-a-project.md#part-2-the-session-continuity-loop): session summary, handoff, save state, then compact
- [Big builds](never-lose-a-project.md#part-3-big-builds-plan-first-then-hand-tasks-to-subagents): plan on disk, progress ledger, fresh implementer and reviewer per task
- [Naming](never-lose-a-project.md#part-4-naming): repo prefixes and file-name patterns
- [Blank templates](never-lose-a-project.md#appendix-blank-templates), used by `/kit:scaffold-project`

**Coming from the older five-file layout** (README, PLANNING, CONTEXT-SUMMARY, project-local CLAUDE.md, handoff)? See [What changed from the five-file layout](never-lose-a-project.md#what-changed-from-the-five-file-layout). Nothing breaks if you keep using it: the kit's prompt-context hook still reads `CONTEXT-SUMMARY.md` when one exists.
