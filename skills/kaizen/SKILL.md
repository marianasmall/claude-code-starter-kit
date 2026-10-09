---
name: kaizen
description: Use when doing code implementation and refactoring, architecting or designing systems, or improving processes, workflows, and error handling. Provides techniques to avoid over-engineering and apply iterative improvements.
metadata:
  version: "1.1.0"
  status: active
---

# Kaizen: Continuous Improvement

Apply continuous improvement mindset - suggest small iterative improvements, error-proof designs, follow established patterns, avoid over-engineering; automatically applied to guide quality and simplicity

## Overview

Small improvements, continuously. Error-proof by design. Follow what works. Build only what's needed.

**Core principle:** Many small improvements beat one big change. Prevent errors at design time, not with fixes.

**Worked code examples** for every pillar live in [`references/examples.md`](references/examples.md). Read the matching section when you need a concrete good-vs-bad model; the principles below are enough for most runs.

## When to Use

**Always applied for:**

- Code implementation and refactoring
- Architecture and design decisions
- Process and workflow improvements
- Error handling and validation

**Philosophy:** Quality through incremental progress and prevention, not perfection through massive effort.

## The Four Pillars

### 1. Continuous Improvement (Kaizen)

Small, frequent improvements compound into major gains.

- **Incremental over revolutionary:** make the smallest viable change that improves quality; one improvement at a time; verify each change before the next.
- **Always leave code better:** fix small issues as you meet them, refactor within scope, update outdated comments, remove dead code.
- **Iterative refinement:** first make it work, then make it clear, then make it efficient. Don't try all three at once.

**In practice:**
- Implementing: start with the simplest version that works, add one improvement, test, repeat. Don't aim for perfect immediately.
- Refactoring: fix one smell at a time, commit after each, keep tests passing, stop at "good enough."
- Reviewing: suggest incremental improvements, not rewrites. Prioritize critical → important → nice-to-have. Accept "better than before."

### 2. Poka-Yoke (Error Proofing)

Design systems that prevent errors at compile/design time, not runtime.

- **Make errors impossible:** let the type system catch mistakes; make invalid states unrepresentable; catch errors early.
- **Design for safety:** fail fast and loudly with helpful messages; make the correct path obvious and the incorrect path difficult.
- **Defense in layers:** type system (compile time) → validation (runtime, early) → guards (preconditions) → error boundaries (graceful degradation).

**In practice:**
- Designing APIs: constrain inputs with types, return `Result<T, E>` instead of throwing, document preconditions in types.
- Handling errors: validate at system boundaries, use guards for preconditions, fail fast with clear messages, log context.
- Configuring: required over optional-with-defaults, validate all config at startup, never allow partial configuration.

### 3. Standardized Work

Follow established patterns. Document what works. Make good practices easy to follow.

- **Consistency over cleverness:** follow existing codebase patterns; introduce a new one only if it's significantly better and agreed.
- **Documentation lives with code:** README for setup and architecture, CLAUDE.md for AI conventions, comments for "why" not "what."
- **Automate standards:** linters for style, type checks for contracts, tests for behavior, CI for quality gates.

**In practice:**
- Before adding a pattern: search the codebase for the same problem solved, check CLAUDE.md, discuss before breaking from it, update docs when you introduce one.
- Writing code: match file structure, naming, error handling, and import locations.
- Reviewing: check consistency, point to examples in the codebase, update CLAUDE.md if a new standard emerges.

### 4. Just-In-Time (JIT)

Build what's needed now. No more, no less.

- **YAGNI:** implement only current requirements; no "just in case" features; delete speculation.
- **Simplest thing that works:** add complexity only when a current requirement, real pain point, measured performance issue, or multiple use cases demand it.
- **Optimize when measured:** profile before optimizing, measure before and after, accept good-enough performance.

**In practice:**
- Implementing: solve the immediate problem with a straightforward approach; resist "what if."
- Optimizing: profile first, document why the optimization was needed, keep the simple version in tests.
- Abstracting: wait for 3+ similar cases, keep the abstraction minimal, prefer duplication over the wrong abstraction.

Use this skill's guidance during day-to-day implementation and review. It doesn't require any companion commands.

## Red Flags

**Violating Continuous Improvement:**

- "I'll refactor it later" (never happens)
- Leaving code worse than you found it
- Big bang rewrites instead of incremental

**Violating Poka-Yoke:**

- "Users should just be careful"
- Validation after use instead of before
- Optional config with no validation

**Violating Standardized Work:**

- "I prefer to do it my way"
- Not checking existing patterns
- Ignoring project conventions

**Violating Just-In-Time:**

- "We might need this someday"
- Building frameworks before using them
- Optimizing without measuring

## Remember

**Kaizen is about:** small improvements continuously, preventing errors by design, following proven patterns, building only what's needed.

**Not about:** perfection on the first try, massive refactoring projects, clever abstractions, premature optimization.

**Mindset:** Good enough today, better tomorrow. Repeat.
