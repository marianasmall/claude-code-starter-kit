# Choosing plugins, connectors and skills

**What this gives you:** a short way to decide which add-ons earn a place in your setup, the warning signs that mean "skip this one", a fix for add-ons that arrive in your terminal without you asking, and a small starter set grouped by what you're trying to get done.

**Time:** about twenty minutes the first time, then ten minutes once a month.

> Based on a hands-on review of 31 plugins from the claude.ai plugin directory in October 2026: what each one adds, what it overlaps with, and what it runs on your machine. Plugins change often. Treat the names below as a snapshot and re-check before you install.

---

## The three things you're choosing between

| Add-on | What it is | Where you manage it |
|---|---|---|
| **Skill** | A folder of instructions Claude reads when a request matches its description. Claude sees every skill's name and one-line description all the time, and reads the rest only when it uses one. | `~/.claude/skills/`, or inside a plugin |
| **Plugin** | A bundle that can hold skills, slash commands, agents, hooks (scripts that run automatically on events), output styles and connectors. | `/plugin` in Claude Code, or the claude.ai app |
| **Connector** | A live link to another service (Gmail, Drive, Airtable, Slack…) so Claude can read from it or act in it. Also called an MCP server. | claude.ai **Customize → Connectors**, or `/mcp` in Claude Code |

The part people miss: **a plugin is more than its skills.** A plugin that looks like "a few marketing prompts" can also ship a hook that runs on every command you approve, or a style that rewrites how Claude talks to you. You're installing all of it.

---

## 1. Decide by goals, not by catalog

The plugin directory is long and everything in it sounds useful. Browsing it is how you end up with forty plugins and a Claude that picks the wrong one. Start from what you want instead.

Write down which of these five goals you actually have. Rename or replace them to fit your life.

| Goal | Example of what it looks like |
|---|---|
| **A. Make Claude more efficient** | Fewer wasted steps, better prompts, checking its own work before it hands it to you |
| **B. Let it talk to other AIs** | Getting a second opinion from another model, or having two assistants debate a decision |
| **C. Organize better** | Your notes, tasks, files and databases in one place Claude can reach |
| **D. Do your job better** | Consulting: research and proposals. Operations: process docs, vendor reviews, risk. Marketing: SEO, campaigns, brand review |
| **E. Streamline personal life** | Reading and filling PDFs, paperwork, travel, household admin |

Then run every candidate through two questions:

1. **Which goal does it serve?** If you can't name one, skip it.
2. **Does it compete with something you already have?** If you already have a skill, plugin or habit that does the job, the new one doesn't add capability. It adds a coin-flip over which one Claude uses.

A plugin earns its place only when the answer to the first is a goal, and the answer to the second is no.

---

## 2. Red flags: skip, or read closely first

Any one of these is a reason to stop and look before installing. Two or more, skip it.

- **Descriptions that shout.** Skills whose description starts with "You MUST use this…", or says "MANDATORY" or "Always use this skill". Claude takes those words seriously, so the skill grabs ordinary requests that belonged to something else. In the review, one developer-team plugin had 13 skills that each opened with "You MUST use this", covering coding, planning and product decisions. A PDF skill in a creative-tools plugin described itself as "MANDATORY" for any PDF task, which would pull work away from every other PDF tool you have.
- **Hooks or output styles that override yours.** Read a plugin's `hooks/` folder before you install it. One workflow plugin in the review shipped a hook that **blocks your first `git commit` and `git push` in every session** until you load one of its own skills, and an output style that declares it "takes precedence" over other formatting guidance. If you've set up how Claude works for you, a plugin like that quietly rewrites it.
- **Its own memory or task files inside your projects.** Some productivity plugins create a memory folder, a `TASKS.md`, a dashboard file, or even a `CLAUDE.md` in whatever folder you're working in. If you already keep notes and tasks somewhere, you now have two systems and a project folder full of files you didn't ask for.
- **Reads sensitive data with no clear payoff.** Email, payments, bank feeds, health data. Ask what you'd get that's worth the access. If the answer is vague, don't connect it. A third-party "health" connector, for example, may send your data to that company's servers, not just to Claude.
- **Developer toolkits when you aren't a developer.** CDN tooling, SDK builders, product-analytics instrumentation, engineering-team role packs. They cost you skill-list space and do nothing for marketing or ops work.
- **Needs an account you don't have.** Many plugins are front ends for a paid service (ad platforms, sales databases, video tools). Without the account they can't do anything, and their connectors fail at startup.
- **A skill name you already use.** If a plugin ships `email-sequence` and you already have an `email-sequence`, Claude now has two with the same name and you can't be sure which runs. Check names before installing.

**How to look:** in Claude Code, ask *"Before I install `<plugin>`, list every skill, command, agent, hook and connector it ships, quote any skill description that says MUST or MANDATORY, and tell me what each hook does."* That's a two-minute read, and it catches most of the above.

---

## 3. The sync trap

Since Claude Code **2.1.275** (September 2026), plugins and skills you turn on in the claude.ai app also load in terminal sessions signed in with the same account. Handy when you have two or three. With many, two problems show up:

- **Things you turned off come back.** A plugin you installed from one marketplace and switched off in the terminal can return as a separate synced copy from claude.ai, switched on. In the review, five plugins the user had deliberately disabled reappeared this way, and one loaded twice.
- **Your own skills get crowded out.** Claude reads a list of every skill's name and description. That list has a size limit. With a few hundred synced skills on top of yours, Claude Code starts showing skills with **no description at all**, including the ones you wrote. A skill without its description is much less likely to be picked when it should be.

You have two options.

**Option A, cleaner: turn sync off and install the few you want directly.** Add this line to `~/.claude/settings.json` (inside the outer `{ }`, with a comma after the line before it):

```json
"syncClaudeAiPlugins": false
```

Then install the plugins you've chosen straight into Claude Code, for example:

```bash
claude plugin marketplace add anthropics/knowledge-work-plugins
claude plugin install pdf-viewer@knowledge-work-plugins
```

The first line is a one-time step: Claude Code only comes with Anthropic's main marketplace (`claude-plugins-official`), so any other marketplace has to be added before you can install from it. If a plugin isn't where you expect, run `/plugin`, find it under **Discover**, and use the marketplace name it shows. Nothing new appears in your terminal unless you install it, and a separate setting, `"syncClaudeAiSkills": false`, does the same for skills you uploaded to claude.ai.

The cost: something you add in the claude.ai app later won't reach the terminal on its own. You'd install it there too.

**Option B: leave sync on and switch plugins off one by one** in `/plugin`. That works until the next plugin you add in the claude.ai app, which arrives in the terminal switched on.

Restart Claude Code after changing either setting. **On Windows, edit the settings file for the place you run Claude Code.** If you run it straight from PowerShell or CMD, the file is `%USERPROFILE%\.claude\settings.json` (for example `C:\Users\you\.claude\settings.json`). If you run it inside WSL, it's `~/.claude/settings.json` in your Linux home folder instead. Not sure which? Think about where you type `claude`: a PowerShell or Command Prompt window means the Windows file, and an Ubuntu (WSL) window means the Linux one. After you save, run `/status` in Claude Code and check that the `Setting sources` line lists `User settings`.

---

## 4. Connectors: keep the ones you use

Connectors are easy to add and easy to forget. Each connected one adds its tool list to every session, whether you use it that day or not.

- **Keep only what you use.** Open claude.ai **Customize → Connectors** and ask of each one: did I use this in the last month?
- **Disconnect "Community" ones you don't recognize.** Connectors labeled Community are built by third parties, not the service itself. If you don't remember adding it, remove it.
- **Fix or remove broken ones.** A connector that shows a sign-in error, or that Claude Code reports as failing at startup, is doing nothing for you. Reconnect it if you want it. Remove it if you don't.
- **Watch for duplicates.** The same service connected twice (once in claude.ai, once inside a plugin) gives Claude two sets of near-identical tools to choose between.

---

## 5. A monthly hygiene check

Ten minutes, once a month. Put it on your calendar.

- [ ] **Privacy settings** in claude.ai **Settings → Privacy**. Confirm the setting for whether your chats can be used to improve the models is where you want it. Settings sometimes change with new features.
- [ ] **Sign-ins.** Check where your account is signed in and which apps hold access, and sign out of anything you don't recognize.
- [ ] **Connectors.** Run the four checks in section 4.
- [ ] **Plugins.** In Claude Code, run `/plugin` and look at what's enabled. Anything you haven't used in a month, switch off. If you use this kit, `/kit:maintain` also checks that every installed plugin is valid.
- [ ] **Skill list.** Run `/context` and look at the skills line. If it grew without you adding anything, a sync or plugin update did it.

---

## 6. A starter set, by goal

A short list drawn from the review. Each was rated worth keeping, and its files were read for hooks, scripts and network calls. Only add the ones that match a goal you wrote down in section 1.

Plugins marked **unverified** weren't part of that safety review. Run the check in section 2 before installing them.

| Goal | Plugin | Why |
|---|---|---|
| A. Efficiency | `verification-foundation` | Checks a finished document against its sources and scores the output before you send it. Most of its skills are written for legal work; the fidelity and scoring checks apply anywhere. |
| B. Other AIs | `agent-discussion` *(unverified, check before installing)* | Has several AI assistants (Claude Code, Gemini CLI, Copilot and others) debate a question through a shared file, taking turns until they reach a conclusion. |
| C. Organize | `airtable` | Lets Claude read and update your Airtable bases. Only if you already use Airtable. |
| D. Your job | `legal` | Contract review, NDA triage, compliance checks and vendor checks from Anthropic's knowledge-work set. Useful for anyone who signs vendor agreements, not just lawyers. Some connector slots expect Microsoft 365. |
| D. Your job | `operations` | Process docs, runbooks, vendor reviews, risk assessments and status reports, from the same set. |
| D. Your job | `marketing` *(unverified, check before installing)* | Campaign plans, content drafts, brand review and competitive briefs. Skip it if you already have your own marketing skills: it will compete with them. |
| D. Your job | `searchfit-seo` | Technical SEO audits, schema markup, keyword clusters and content briefs. Needs no extra account. |
| D. Leaders | `ai-adoption-playbook` *(unverified, check before installing)* | For people leading a team's AI rollout: readiness scorecards, blocker diagnosis, a 90-day plan and a board update. Note that it ships a skill named `roi-calculator`; check that against your own skills. |
| E. Personal | `pdf-viewer` | Opens, annotates, fills and signs PDFs. Paperwork, forms, contracts. It starts a small helper program from the internet each time it runs, so it can update without notice. |

**Also worth having:** a prompt-tightening skill that rewrites a rough request into a clear one before Claude acts on it. Several exist. None was part of this review, so treat any you find as unverified.

**Plugins the review advised against for most non-developers:** developer-team role packs, CDN and SDK toolkits, product-analytics instrumentation, and workflow plugins that ship their own hooks. Sales and ad-platform plugins only make sense if you have the account behind them.

---

## The short version

1. Write down your goals. Install only what serves one and doesn't duplicate something you have.
2. Before installing, list what a plugin ships and look for shouting descriptions, hooks, and files it creates in your folders.
3. If claude.ai keeps pushing plugins into your terminal, set `"syncClaudeAiPlugins": false` and install the few you want by hand.
4. Prune connectors and plugins once a month, and check your privacy settings while you're there.

Related: [context-budget primer](context-budget-primer.md) for what every loaded skill and connector costs, and how skills load.
