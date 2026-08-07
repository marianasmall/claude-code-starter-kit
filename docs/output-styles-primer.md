# Output Styles Primer

Claude Code ships with built-in "output styles" you can switch between. Most users never know they exist.

## What they are

Output styles change *how* Claude responds — role, tone, and output format — by modifying the system prompt. They don't change what Claude knows or which tools it can use.

## The built-in styles

### `Default`
Standard Claude Code output, tuned for efficient software engineering work. Use this most of the time.

### `Proactive`
Claude acts first and asks less — it makes reasonable assumptions instead of pausing for routine decisions. Good when you trust it with routine calls. (You still see permission prompts before tools run.)

### `Explanatory`
Adds `★ Insight ─` boxes with educational asides while working. Good for:
- Learning a new codebase or framework
- Onboarding to a project
- Anytime you want Claude to teach as it works

This style is **enabled by default** in this starter kit's `settings.json.template` (via the `outputStyle` setting). You'll see boxes like:

```
★ Insight ─────────────────────────────────────
[2-3 educational points]
─────────────────────────────────────────────────
```

If you don't want them, remove the `outputStyle` line from your settings or switch back to Default.

### `Learning`
Collaborative learn-by-doing mode: Claude shares insights *and* leaves small, strategic pieces of code for you to implement, marked `TODO(human)`. Good when you want to build the skill, not just ship the task.

## How to switch

Run `/config` and pick a style under **Output style**. Or set it directly in `~/.claude/settings.json`:

```json
{
  "outputStyle": "Explanatory"
}
```

Style changes take effect after `/clear` or a new session.

> **Note:** older guides mention an `/output-style` command — it was removed in v2.1.91. Everything lives in `/config` now.

## Custom styles

You can create your own: a markdown file in `~/.claude/output-styles/` with a `name`, a `description`, and your instructions. Add `keep-coding-instructions: true` to the frontmatter if you want Claude to keep its normal engineering behavior underneath your custom voice. See the [official docs](https://code.claude.com/docs/en/output-styles).

## Don't go overboard

Output styles are a *response shape*, not a *memory*. For project conventions or standing instructions, the answer is usually a *skill* or a *clearer CLAUDE.md instruction*, not a custom output style.
