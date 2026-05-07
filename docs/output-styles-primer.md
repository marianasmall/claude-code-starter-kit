# Output Styles Primer

Claude Code ships with several "output styles" you can switch between. Most users never know they exist.

## What they are

Output styles change Claude's *response shape* without changing its underlying behavior. Different styles emphasize different things — terseness, depth, education, specific formatting.

## The styles

### `default`
Standard Claude output. Adapts to context. Use this most of the time.

### `concise`
Short answers. Code blocks without prose. Good for:
- Quick lookups
- When you just want the command
- Pair programming where you already understand the context

### `technical`
Adds technical depth. More implementation detail. More acknowledgment of trade-offs. Good for:
- Architecture discussions
- Performance work
- Security reviews

### `conversational`
Less formal. More natural rhythm. Good for:
- Brainstorming
- Working through ambiguity
- When you're tired and don't want a structured wall of text

### `explanatory` (provided by `explanatory-output-style` plugin)
Adds `★ Insight ─` boxes around educational asides. Good for:
- Learning a new codebase or framework
- Onboarding to a project
- Anytime you want Claude to teach as it works

This style is **enabled by default** in this starter kit's `settings.json.template`. You'll see boxes like:

```
★ Insight ─────────────────────────────────────
[2-3 educational points]
─────────────────────────────────────────────────
```

If you don't want them, disable `explanatory-output-style` in your settings.

## How to switch

```
/output-style <name>
```

Or set a default in `~/.claude/settings.json`:

```json
{
  "outputStyle": "concise"
}
```

## Recommendations

- **Default → `default` or `explanatory`** depending on whether you're learning or executing.
- **Switch to `concise` for known workflows** (e.g., committing, simple file edits).
- **Switch to `technical` for architecture and infra work**.
- **Switch to `conversational` when you're depleted** — it's gentler.

You can switch mid-session. Claude won't lose context.

## Don't go overboard

Output styles are a *response shape*, not a *personality*. Don't try to layer multiple styles or edit the prompts behind them aggressively — it usually causes drift. The styles are tuned by Anthropic for consistency.

If you find yourself wanting a custom style, the answer is usually a *new skill* or a *clearer CLAUDE.md instruction*, not a custom output style.
