import React, { useState } from 'react'

/* ─────────────────────────────────────────────
   CLAUDE.MD TEMPLATE — The copyable starter
   ───────────────────────────────────────────── */
const CLAUDE_MD_TEMPLATE = `# CLAUDE.md — [Your Name]'s Claude Code Context

## Who I Am
[Your role and background — customize this. Example below.]

Marketing executive and strategist. I understand business concepts deeply but don't write code myself. When explaining what you're doing, focus on what it accomplishes and why — not how the syntax works.

## How to Work With Me

### Communication
- Be structured, calm, and precise. I value clarity over comfort.
- Signal your confidence: "I'm confident..." vs "My read is..." vs "I'd need to verify..."
- When something is technical, explain the impact and implications — not the implementation details

### Working Modes
- **Execution mode:** When I say "just do it" or move quickly → act without over-explaining (flag critical issues in one sentence if needed)
- **Thinking mode:** Default → challenge my thinking, suggest alternatives, push me to be more specific
- If I'm cycling through ideas without deciding, slow me down: "What are you actually committing to?"

## Partnership Frame
You're not a task executor — you're an operational partner. This means:
- If you see a problem with my approach, say so before executing
- If something could be done better, suggest it without being asked
- If I'm spending time on low-value work when I should be focused on strategy, flag it
- Own the quality of the work, not just the completion of the task

## Permissions You Have
- Flag patterns and observations without being asked
- Say "I don't think that's the right move" without elaborate justification
- Push back on ideas that don't hold up, regardless of where they came from
- Suggest improvements I didn't ask for when they'd make the work meaningfully better
- Ask "What's underneath this?" when a question seems to have layers

## Constitution (Never Override)
1. **Default to reversible actions.** When something could be destructive, create a recovery path (backups, staging folders) rather than blocking. Confirm only when no reversible path exists.
2. **Epistemic transparency.** Say "I don't know" when uncertain. Don't guess or make things up.
3. **No hidden actions.** Everything visible. If you're doing something, tell me what and why.

## Insights
When helping me with tasks, provide brief educational insights about your approach and decisions. Use this format:

\`★ Insight ─────────────────────────────────────\`
[2-3 key points about the approach, tool, or decision]
\`─────────────────────────────────────────────────\`

Focus on insights specific to my work — strategic implications, tool capabilities, alternative approaches I might not know about. These help me learn what's possible and ask better questions over time. Skip general concepts I already know.

## Session Continuity
At the end of each working session, provide a brief session summary:
- **What we accomplished** — key outcomes, not play-by-play
- **Decisions made** — and the reasoning behind them
- **What's still open** — pending items or unresolved questions
- **Recommended next steps** — what to tackle next time

Save session summaries to a persistent location (e.g., ~/.claude/session-summaries.md or a Notion database) so we can reference past work. At the start of new sessions, check recent summaries so we never start from zero.

## My Setup
[Customize this section with your tools and preferences]
- I use [Notion / Asana / Monday / etc.] for project management
- I keep files in [Google Drive / Dropbox / local folders]
- My key tools: [list the tools you use daily]

## When I Ask You to Do Things
- Explain what you're about to do before doing it
- After completing, summarize what changed in plain language
- If something fails, explain what went wrong and what my options are — don't just show error messages`


/* ─────────────────────────────────────────────
   ICON COMPONENTS
   ───────────────────────────────────────────── */
function IconFile() {
  return (
    <svg className="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={1.5}>
      <path strokeLinecap="round" strokeLinejoin="round" d="M19.5 14.25v-2.625a3.375 3.375 0 0 0-3.375-3.375h-1.5A1.125 1.125 0 0 1 13.5 7.125v-1.5a3.375 3.375 0 0 0-3.375-3.375H8.25m0 12.75h7.5m-7.5 3H12M10.5 2.25H5.625c-.621 0-1.125.504-1.125 1.125v17.25c0 .621.504 1.125 1.125 1.125h12.75c.621 0 1.125-.504 1.125-1.125V11.25a9 9 0 0 0-9-9Z" />
    </svg>
  )
}

function IconRocket() {
  return (
    <svg className="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={1.5}>
      <path strokeLinecap="round" strokeLinejoin="round" d="M15.59 14.37a6 6 0 0 1-5.84 7.38v-4.8m5.84-2.58a14.98 14.98 0 0 0 6.16-12.12A14.98 14.98 0 0 0 9.631 8.41m5.96 5.96a14.926 14.926 0 0 1-5.841 2.58m-.119-8.54a6 6 0 0 0-7.381 5.84h4.8m2.581-5.84a14.927 14.927 0 0 0-2.58 5.84m2.699 2.7c-.103.021-.207.041-.311.06a15.09 15.09 0 0 1-2.448-2.448 14.9 14.9 0 0 1 .06-.312m-2.24 2.39a4.493 4.493 0 0 0-1.757 4.306 4.493 4.493 0 0 0 4.306-1.758M16.5 9a1.5 1.5 0 1 1-3 0 1.5 1.5 0 0 1 3 0Z" />
    </svg>
  )
}

function IconStar() {
  return (
    <svg className="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={1.5}>
      <path strokeLinecap="round" strokeLinejoin="round" d="M9.813 15.904 9 18.75l-.813-2.846a4.5 4.5 0 0 0-3.09-3.09L2.25 12l2.846-.813a4.5 4.5 0 0 0 3.09-3.09L9 5.25l.813 2.846a4.5 4.5 0 0 0 3.09 3.09L15.75 12l-2.846.813a4.5 4.5 0 0 0-3.09 3.09ZM18.259 8.715 18 9.75l-.259-1.035a3.375 3.375 0 0 0-2.455-2.456L14.25 6l1.036-.259a3.375 3.375 0 0 0 2.455-2.456L18 2.25l.259 1.035a3.375 3.375 0 0 0 2.456 2.456L21.75 6l-1.035.259a3.375 3.375 0 0 0-2.456 2.456ZM16.894 20.567 16.5 21.75l-.394-1.183a2.25 2.25 0 0 0-1.423-1.423L13.5 18.75l1.183-.394a2.25 2.25 0 0 0 1.423-1.423l.394-1.183.394 1.183a2.25 2.25 0 0 0 1.423 1.423l1.183.394-1.183.394a2.25 2.25 0 0 0-1.423 1.423Z" />
    </svg>
  )
}

function IconClock() {
  return (
    <svg className="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={1.5}>
      <path strokeLinecap="round" strokeLinejoin="round" d="M12 6v6h4.5m4.5 0a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z" />
    </svg>
  )
}

function IconShield() {
  return (
    <svg className="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={1.5}>
      <path strokeLinecap="round" strokeLinejoin="round" d="M9 12.75 11.25 15 15 9.75m-3-7.036A11.959 11.959 0 0 1 3.598 6 11.99 11.99 0 0 0 3 9.749c0 5.592 3.824 10.29 9 11.623 5.176-1.332 9-6.03 9-11.622 0-1.31-.21-2.571-.598-3.751h-.152c-3.196 0-6.1-1.248-8.25-3.285Z" />
    </svg>
  )
}

function IconArrowUp() {
  return (
    <svg className="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={1.5}>
      <path strokeLinecap="round" strokeLinejoin="round" d="M3 4.5h14.25M3 9h9.75M3 13.5h9.75m4.5-4.5v12m0 0-3.75-3.75M17.25 21l3.75-3.75" />
    </svg>
  )
}

function IconClipboard({ copied }: { copied: boolean }) {
  if (copied) {
    return (
      <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2}>
        <path strokeLinecap="round" strokeLinejoin="round" d="m4.5 12.75 6 6 9-13.5" />
      </svg>
    )
  }
  return (
    <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={1.5}>
      <path strokeLinecap="round" strokeLinejoin="round" d="M15.666 3.888A2.25 2.25 0 0 0 13.5 2.25h-3c-1.03 0-1.9.693-2.166 1.638m7.332 0c.055.194.084.4.084.612v0a.75.75 0 0 1-.75.75H9.75a.75.75 0 0 1-.75-.75v0c0-.212.03-.418.084-.612m7.332 0c.646.049 1.288.11 1.927.184 1.1.128 1.907 1.077 1.907 2.185V19.5a2.25 2.25 0 0 1-2.25 2.25H6.75A2.25 2.25 0 0 1 4.5 19.5V6.257c0-1.108.806-2.057 1.907-2.185a48.208 48.208 0 0 1 1.927-.184" />
    </svg>
  )
}


/* ─────────────────────────────────────────────
   SECTION CARD COMPONENT
   ───────────────────────────────────────────── */
function SectionCard({
  id, icon, title, tier, tierColor, children
}: {
  id: string
  icon: React.ReactNode
  title: string
  tier?: string
  tierColor?: string
  children: React.ReactNode
}) {
  const colorMap: Record<string, string> = {
    green: 'bg-emerald-100 text-emerald-700',
    blue: 'bg-sky-100 text-sky-700',
    purple: 'bg-violet-100 text-violet-700',
  }

  return (
    <section id={id} className="bg-white rounded-2xl shadow-sm border border-stone-200/60 p-8 md:p-10 scroll-mt-24">
      <div className="flex items-start gap-4 mb-6">
        <div className="p-2.5 bg-teal-50 text-teal-brand rounded-xl shrink-0">
          {icon}
        </div>
        <div className="flex items-center gap-3 flex-wrap">
          <h2 className="text-2xl font-bold text-stone-900">{title}</h2>
          {tier && tierColor && (
            <span className={`text-xs font-semibold px-2.5 py-1 rounded-full ${colorMap[tierColor] || ''}`}>
              {tier}
            </span>
          )}
        </div>
      </div>
      <div className="text-stone-600 leading-relaxed space-y-4">
        {children}
      </div>
    </section>
  )
}


/* ─────────────────────────────────────────────
   EXPANDABLE DETAILS COMPONENT
   ───────────────────────────────────────────── */
function Expandable({ title, children }: { title: string; children: React.ReactNode }) {
  const [open, setOpen] = useState(false)
  return (
    <div className="border border-stone-200 rounded-xl overflow-hidden">
      <button
        onClick={() => setOpen(!open)}
        className="w-full flex items-center justify-between px-5 py-3.5 bg-stone-50 hover:bg-stone-100 transition-colors text-left"
      >
        <span className="font-medium text-stone-700">{title}</span>
        <svg
          className={`w-5 h-5 text-stone-400 transition-transform duration-200 ${open ? 'rotate-180' : ''}`}
          fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2}
        >
          <path strokeLinecap="round" strokeLinejoin="round" d="m19.5 8.25-7.5 7.5-7.5-7.5" />
        </svg>
      </button>
      {open && (
        <div className="px-5 py-4 text-stone-600 leading-relaxed space-y-3 border-t border-stone-200 bg-white">
          {children}
        </div>
      )}
    </div>
  )
}


/* ─────────────────────────────────────────────
   MAIN APP
   ───────────────────────────────────────────── */
export default function App() {
  const [copied, setCopied] = useState(false)

  const copyTemplate = async () => {
    try {
      await navigator.clipboard.writeText(CLAUDE_MD_TEMPLATE)
      setCopied(true)
      setTimeout(() => setCopied(false), 3000)
    } catch {
      const textarea = document.createElement('textarea')
      textarea.value = CLAUDE_MD_TEMPLATE
      document.body.appendChild(textarea)
      textarea.select()
      document.execCommand('copy')
      document.body.removeChild(textarea)
      setCopied(true)
      setTimeout(() => setCopied(false), 3000)
    }
  }

  const scrollTo = (id: string) => {
    document.getElementById(id)?.scrollIntoView({ behavior: 'smooth' })
  }

  return (
    <div className="min-h-screen bg-warm-50" style={{ fontFamily: "'Inter', system-ui, sans-serif" }}>

      {/* ── STICKY NAV ── */}
      <nav className="sticky top-0 z-50 bg-white/80 backdrop-blur-lg border-b border-stone-200/60">
        <div className="max-w-4xl mx-auto px-4 sm:px-6">
          <div className="flex items-center justify-between h-14">
            <span className="font-bold text-stone-900 text-sm tracking-tight">Claude Code Starter Kit</span>
            <div className="hidden md:flex items-center gap-1">
              {[
                ['intro', 'What is It?'],
                ['claude-md', 'CLAUDE.md'],
                ['setup', 'Setup'],
                ['insights', 'Insights'],
                ['summaries', 'Summaries'],
                ['level-up', 'Level Up'],
                ['template', 'Template'],
              ].map(([id, label]) => (
                <button
                  key={id}
                  onClick={() => scrollTo(id)}
                  className="px-3 py-1.5 text-xs font-medium text-stone-500 hover:text-teal-brand hover:bg-teal-50 rounded-lg transition-colors"
                >
                  {label}
                </button>
              ))}
            </div>
          </div>
        </div>
      </nav>


      {/* ── HERO ── */}
      <header className="relative overflow-hidden bg-gradient-to-br from-stone-50 via-white to-teal-50/30 border-b border-stone-200/40">
        <div className="max-w-4xl mx-auto px-4 sm:px-6 py-16 md:py-24">
          <div className="max-w-2xl">
            <p className="text-teal-brand font-semibold text-sm tracking-wide uppercase mb-4">From one marketing exec to another</p>
            <h1 className="text-4xl md:text-5xl font-extrabold text-stone-900 leading-tight mb-6">
              Claude Code<br />Starter Kit
            </h1>
            <p className="text-lg text-stone-600 leading-relaxed mb-8">
              Everything you need to turn Claude Code from a generic AI assistant into a strategic partner
              that knows how you work, learns as you go, and never loses context between sessions.
            </p>
            <div className="flex flex-wrap gap-3">
              <button
                onClick={() => scrollTo('template')}
                className="px-5 py-2.5 bg-teal-brand text-white font-semibold rounded-xl hover:bg-teal-700 transition-colors shadow-sm"
              >
                Get the Template
              </button>
              <button
                onClick={() => scrollTo('claude-md')}
                className="px-5 py-2.5 bg-white text-stone-700 font-semibold rounded-xl hover:bg-stone-50 transition-colors border border-stone-200 shadow-sm"
              >
                Start Reading
              </button>
            </div>
          </div>
        </div>
        {/* Decorative gradient blob */}
        <div className="absolute -top-24 -right-24 w-96 h-96 bg-gradient-to-br from-teal-100/40 to-emerald-100/20 rounded-full blur-3xl pointer-events-none" />
      </header>


      {/* ── VALUE PROPS ── */}
      <div className="max-w-4xl mx-auto px-4 sm:px-6 -mt-8 relative z-10 mb-12">
        <div className="grid grid-cols-2 md:grid-cols-4 gap-3">
          {[
            { label: 'Partner, Not Assistant', desc: 'Claude pushes back and suggests improvements' },
            { label: 'Insights Along the Way', desc: 'Learn the "why" behind every decision' },
            { label: 'Session Continuity', desc: 'Never start from zero again' },
            { label: 'Safety Built In', desc: 'Backups and guardrails by default' },
          ].map((item) => (
            <div key={item.label} className="bg-white rounded-xl border border-stone-200/60 p-4 shadow-sm">
              <p className="font-semibold text-stone-800 text-sm mb-1">{item.label}</p>
              <p className="text-xs text-stone-500">{item.desc}</p>
            </div>
          ))}
        </div>
      </div>


      {/* ── INTRO: WHAT IS CLAUDE CODE? ── */}
      <section id="intro" className="max-w-4xl mx-auto px-4 sm:px-6 mb-8 scroll-mt-24">
        <div className="bg-white rounded-2xl shadow-sm border border-stone-200/60 p-8 md:p-10">
          <h2 className="text-2xl font-bold text-stone-900 mb-6">First Things First: What is Claude Code?</h2>
          <div className="text-stone-600 leading-relaxed space-y-4">
            <p>
              You probably already know Claude — Anthropic's AI that you chat with at <strong>claude.ai</strong>.
              That's great for brainstorming, writing, and thinking through problems together. But it lives
              in a browser tab. It can't actually <em>touch</em> anything on your computer.
            </p>
            <p>
              <strong>Claude Code is different.</strong> It runs directly on your machine and can actually <em>do things</em> —
              read your files, create documents, build websites, connect to your tools (Notion, Gmail, Slack),
              run research, and produce real deliverables. It's the difference between talking about work and
              actually doing the work.
            </p>

            <div className="bg-stone-50 rounded-xl p-6 border border-stone-200/60 mt-2">
              <h3 className="font-semibold text-stone-800 mb-4">Think of it this way:</h3>
              <div className="grid md:grid-cols-2 gap-4">
                <div className="bg-white rounded-lg p-4 border border-stone-200">
                  <p className="font-semibold text-stone-700 text-sm mb-2">Claude.ai (the website)</p>
                  <p className="text-sm text-stone-500">Your thinking partner. Great for conversation,
                  brainstorming, drafting copy, and working through ideas. Like texting a brilliant colleague.</p>
                </div>
                <div className="bg-teal-50 rounded-lg p-4 border border-teal-200">
                  <p className="font-semibold text-teal-800 text-sm mb-2">Claude Code (the tool)</p>
                  <p className="text-sm text-teal-700">Your hands-on team member. Can read your Google Drive,
                  update your Notion, build a presentation, research competitors, create a website — and deliver
                  finished work, not just suggestions.</p>
                </div>
              </div>
            </div>

            <h3 className="font-semibold text-stone-800 pt-2">What can a marketing exec actually do with it?</h3>
            <div className="grid md:grid-cols-2 gap-3">
              {[
                { title: 'Research & Analysis', examples: 'Competitive audits, market research, SEO analysis — with real citations and sources' },
                { title: 'Content & Strategy', examples: 'Content calendars, LinkedIn posts, email sequences, campaign briefs — drafted in your voice' },
                { title: 'Build Deliverables', examples: 'Websites, dashboards, presentations, proposals, reports — real files you can share' },
                { title: 'Connect Your Tools', examples: 'Pull meeting notes from Fireflies, update Notion boards, draft emails in Gmail, read Slack threads' },
                { title: 'Automate Repetitive Work', examples: 'Marketing audits, client onboarding checklists, reporting templates — do it once, reuse forever' },
                { title: 'Manage Projects', examples: 'Track tasks across tools, summarize progress, coordinate work streams, keep you organized' },
              ].map((item) => (
                <div key={item.title} className="flex gap-3 items-start">
                  <div className="w-1.5 h-1.5 rounded-full bg-teal-brand mt-2 shrink-0" />
                  <div>
                    <p className="font-medium text-stone-800 text-sm">{item.title}</p>
                    <p className="text-xs text-stone-500">{item.examples}</p>
                  </div>
                </div>
              ))}
            </div>

            {/* How Anthropic uses it */}
            <div className="bg-stone-50 rounded-xl p-6 border border-stone-200/60 mt-2">
              <h3 className="font-semibold text-stone-800 mb-2">It's not just for developers.</h3>
              <p className="text-sm text-stone-600 mb-4">
                Anthropic — the company that builds Claude — uses Claude Code across their entire organization.
                Here are the teams that use it for non-engineering work:
              </p>
              <div className="grid grid-cols-2 md:grid-cols-4 gap-3">
                {[
                  {
                    team: 'Growth Marketing',
                    uses: ['Automated ad creative generation', 'Advanced prompt engineering with memory systems'],
                  },
                  {
                    team: 'Sales',
                    uses: ['Sales forecasting via MCP', 'End-to-end demo prep'],
                  },
                  {
                    team: 'Product Design',
                    uses: ['Rapid interactive prototyping', 'Complex copy changes and legal compliance'],
                  },
                  {
                    team: 'Finance',
                    uses: ['P&L modeling with sensitivity analysis', 'Cost modeling with assumptions'],
                  },
                ].map((dept) => (
                  <div key={dept.team} className="bg-white rounded-lg p-3.5 border border-stone-200">
                    <p className="font-semibold text-stone-800 text-xs mb-2">{dept.team}</p>
                    {dept.uses.map((use) => (
                      <p key={use} className="text-xs text-stone-500 mb-1 leading-snug">{use}</p>
                    ))}
                  </div>
                ))}
              </div>
              <p className="text-xs text-stone-400 mt-3 italic">
                Source: "Claude Code in an Hour" — Anthropic webinar on how they use Claude Code internally
              </p>
            </div>

            <h3 className="font-semibold text-stone-800 pt-2">Out of the box, it's good. With setup, it's transformative.</h3>
            <p>
              Claude Code works the moment you install it — no configuration required. But out of the box,
              every conversation starts from scratch. Claude doesn't know who you are, how you like to work,
              or what you did yesterday.
            </p>
            <p>
              <strong>That's what this guide fixes.</strong> The setup below teaches Claude your working style,
              gives it permission to push back on your ideas (not just agree), makes it explain what it's doing as it goes,
              and ensures it remembers what happened in previous sessions. The result is an AI partner that gets
              better the more you use it — not a blank slate every time.
            </p>

            <div className="bg-amber-50 rounded-xl p-5 border border-amber-200/40 mt-2">
              <p className="font-semibold text-stone-800 text-sm mb-1">You don't need to be technical.</p>
              <p className="text-sm text-stone-600">
                Seriously. Claude Code writes all the code. Your job is to describe what you want in plain language —
                the way you'd brief a team member. Everything in this guide can be set up by simply
                telling Claude Code what to do. Copy the template below, paste it, and say "save this as my CLAUDE.md."
                That's it.
              </p>
            </div>
          </div>
        </div>
      </section>


      {/* ── MAIN CONTENT ── */}
      <main className="max-w-4xl mx-auto px-4 sm:px-6 pb-20 space-y-8">

        {/* SECTION: The CLAUDE.md File */}
        <SectionCard id="claude-md" icon={<IconFile />} title="The CLAUDE.md File" tier="Start Here" tierColor="green">
          <p>
            <strong>This is the single most impactful thing you'll do.</strong> The <code className="px-1.5 py-0.5 bg-stone-100 rounded text-sm font-mono">CLAUDE.md</code> file
            lives at <code className="px-1.5 py-0.5 bg-stone-100 rounded text-sm font-mono">~/.claude/CLAUDE.md</code> and is loaded into every Claude Code conversation.
            It's your personal instruction manual — it tells Claude who you are, how you think, what you expect, and how to work with you.
          </p>
          <p>
            Without it, Claude is a brilliant generalist. With it, Claude becomes a partner who knows your communication style,
            pushes back when you're wrong, explains things the way you need, and builds on previous work instead of starting fresh.
          </p>

          <Expandable title="What goes in a CLAUDE.md?">
            <p>Think of it as onboarding a new team member. You'd tell them:</p>
            <ul className="list-disc list-inside space-y-1.5 ml-1 text-sm">
              <li><strong>Who you are</strong> — your role, your expertise level, how you prefer explanations</li>
              <li><strong>How you communicate</strong> — structured vs. casual, when to push back vs. just execute</li>
              <li><strong>The relationship</strong> — partner, not assistant. Permission to challenge your thinking.</li>
              <li><strong>Non-negotiables</strong> — always be transparent, never guess, default to reversible actions</li>
              <li><strong>Your tools and setup</strong> — what you use, where files live, how you organize</li>
            </ul>
            <p className="text-sm mt-3">
              The template at the bottom of this page gives you all of this pre-written. Just fill in the <code className="px-1 py-0.5 bg-stone-100 rounded text-xs font-mono">[brackets]</code> with your details.
            </p>
          </Expandable>

          <Expandable title="Where does this file go?">
            <p className="text-sm">
              Create the file at <code className="px-1.5 py-0.5 bg-stone-100 rounded text-xs font-mono">~/.claude/CLAUDE.md</code> — that's in a hidden
              folder called <code className="px-1.5 py-0.5 bg-stone-100 rounded text-xs font-mono">.claude</code> in your home directory.
              You can ask Claude Code to create it for you: just paste the template and say "save this as my CLAUDE.md."
            </p>
            <p className="text-sm">
              This is your <strong>global</strong> instruction file — it applies to every Claude Code conversation. You can also create project-specific
              CLAUDE.md files inside any project folder for context that only applies there.
            </p>
          </Expandable>
        </SectionCard>


        {/* SECTION: Day One Setup */}
        <SectionCard id="setup" icon={<IconRocket />} title="Your Day One Setup" tier="Day 1" tierColor="green">
          <p>
            Beyond the CLAUDE.md file, here are the three things worth setting up on your first day.
          </p>

          <div className="space-y-4 mt-2">
            <div className="bg-stone-50 rounded-xl p-5 border border-stone-200/60">
              <h3 className="font-semibold text-stone-800 mb-2">1. Connect Your Integrations</h3>
              <p className="text-sm">
                Claude Code can connect to tools you already use — <strong>Notion, Gmail, Slack, Google Calendar</strong>, and more.
                These aren't separate installs; they're remote integrations you authorize through your Claude account.
              </p>
              <p className="text-sm mt-2">
                When Claude is connected to your tools, it can search your Notion, draft emails in Gmail,
                read Slack threads for context, and check your calendar — all without you switching windows.
              </p>
              <p className="text-sm mt-2 text-stone-500 italic">
                Ask Claude Code: "What integrations are available?" to see your options and connect them.
              </p>
            </div>

            <div className="bg-stone-50 rounded-xl p-5 border border-stone-200/60">
              <h3 className="font-semibold text-stone-800 mb-2">2. Install the Superpowers Plugin</h3>
              <p className="text-sm">
                This community plugin adds structured workflows for <strong>brainstorming, debugging, and planning</strong>.
                Instead of Claude just doing whatever you ask, it follows a discipline — asking the right questions,
                considering alternatives, and checking its own work.
              </p>
              <p className="text-sm mt-2">
                The brainstorming workflow alone is worth it: before building anything, Claude will explore your
                intent, ask clarifying questions, and propose 2-3 approaches before diving in.
              </p>
              <p className="text-sm mt-2 text-stone-500 italic">
                Ask Claude Code: "Install the superpowers plugin from claudecodeplugins.com" or look for it in the plugin directory.
              </p>
            </div>

            <div className="bg-stone-50 rounded-xl p-5 border border-stone-200/60">
              <h3 className="font-semibold text-stone-800 mb-2">3. Set Up Basic Hooks</h3>
              <p className="text-sm">
                Hooks are small automations that run at specific moments — when Claude starts editing a file,
                when it finishes a task, when a session begins. Two are worth setting up immediately:
              </p>
              <ul className="list-disc list-inside text-sm mt-2 space-y-1.5 ml-1">
                <li><strong>Backup before edit</strong> — automatically saves a copy of any file before Claude modifies it. Your safety net.</li>
                <li><strong>Notify when done</strong> — plays a sound or sends a notification when Claude finishes working, so you can walk away and come back.</li>
              </ul>
              <p className="text-sm mt-2 text-stone-500 italic">
                Ask Claude Code: "Help me set up a backup-before-edit hook and a notification hook."
              </p>
            </div>
          </div>
        </SectionCard>


        {/* SECTION: Insights Feature */}
        <SectionCard id="insights" icon={<IconStar />} title="The Insights Feature" tier="Day 1" tierColor="green">
          <p>
            This is one of the features that makes Claude Code genuinely educational to use. With a simple instruction
            in your CLAUDE.md, Claude will proactively explain <em>what</em> it's doing and <em>why</em> — not just do the thing.
          </p>

          <div className="bg-stone-900 rounded-xl p-5 mt-2 font-mono text-sm">
            <p className="text-teal-400 mb-1">{`\`★ Insight ─────────────────────────────────────\``}</p>
            <p className="text-stone-300">
              <strong className="text-white">Why a Netlify page instead of a PDF:</strong> A hosted page gives you a
              shareable link you can update anytime. PDFs are static — once sent, you can't fix a typo or add a section.
              Plus, interactive elements (expandable sections, copy buttons) aren't possible in a PDF.
            </p>
            <p className="text-teal-400 mt-1">{`\`─────────────────────────────────────────────────\``}</p>
          </div>

          <p className="text-sm mt-4">
            Over time, these insights compound. You start recognizing patterns, understanding trade-offs, and asking
            better questions. You're not just getting work done — you're building intuition about what's possible.
          </p>

          <Expandable title="What kinds of insights does it share?">
            <ul className="list-disc list-inside text-sm space-y-1.5 ml-1">
              <li><strong>Tool choices</strong> — why Claude picked one approach over another</li>
              <li><strong>Strategic implications</strong> — what a decision means for your broader goals</li>
              <li><strong>Capability awareness</strong> — things Claude can do that you might not have known to ask for</li>
              <li><strong>Trade-offs</strong> — what you gain and lose with different approaches</li>
            </ul>
            <p className="text-sm mt-2">
              It skips obvious things you already know and focuses on insights specific to your work.
            </p>
          </Expandable>

          <Expandable title="How do I turn this on?">
            <p className="text-sm">
              It's already in the CLAUDE.md template below — the "Insights" section. Just by having it in your CLAUDE.md,
              Claude will include these insight blocks in its responses. No hooks or plugins needed.
            </p>
            <p className="text-sm mt-2">
              You can adjust what it focuses on by editing the instruction. Want more strategic insights? Say so.
              Want fewer technical details? Tell it. The CLAUDE.md is your control panel.
            </p>
          </Expandable>
        </SectionCard>


        {/* SECTION: Session Summaries */}
        <SectionCard id="summaries" icon={<IconClock />} title="Session Summaries" tier="Day 1" tierColor="green">
          <p>
            Here's the problem with AI assistants: every conversation starts from zero. You spend the first
            five minutes re-explaining context that Claude already knew yesterday.
          </p>
          <p>
            <strong>Session summaries fix this.</strong> At the end of each working session, Claude writes a brief
            summary of what you accomplished, what decisions were made, what's still open, and what to do next.
            At the start of your next session, it reads those summaries and picks up where you left off.
          </p>

          <div className="bg-stone-50 rounded-xl p-5 border border-stone-200/60 mt-2">
            <h3 className="font-semibold text-stone-800 text-sm mb-3">What a session summary looks like:</h3>
            <div className="text-sm space-y-2 font-mono bg-white p-4 rounded-lg border border-stone-200 text-stone-700">
              <p><strong className="text-stone-900">Session: March 9, 2026</strong></p>
              <p className="mt-2"><strong>What we accomplished:</strong></p>
              <p className="ml-3">- Finalized Q2 content calendar with 12 pieces</p>
              <p className="ml-3">- Drafted LinkedIn post series on AI in marketing</p>
              <p className="ml-3">- Set up Notion tracking board for content pipeline</p>
              <p className="mt-2"><strong>Decisions made:</strong></p>
              <p className="ml-3">- Going with weekly cadence (not biweekly) — audience engagement data supports it</p>
              <p className="ml-3">- Leading with case studies over thought leadership for Q2</p>
              <p className="mt-2"><strong>Still open:</strong></p>
              <p className="ml-3">- Need final approval on budget for paid promotion</p>
              <p className="ml-3">- Haven't decided on video format for LinkedIn</p>
              <p className="mt-2"><strong>Next steps:</strong></p>
              <p className="ml-3">- Draft first two case studies</p>
              <p className="ml-3">- Research LinkedIn video best practices</p>
            </div>
          </div>

          <Expandable title="Where do session summaries get saved?">
            <p className="text-sm">
              You choose. The simplest option is a local file at <code className="px-1 py-0.5 bg-stone-100 rounded text-xs font-mono">~/.claude/session-summaries.md</code>.
              If you use Notion, you can have Claude log them to a Notion database (searchable, filterable, beautiful).
            </p>
            <p className="text-sm mt-2">
              The key is persistence — the summaries need to exist somewhere Claude can read at the start of the next session.
              The CLAUDE.md template includes the instruction. Just tell Claude where you want them stored.
            </p>
          </Expandable>

          <Expandable title="How is this different from chat history?">
            <p className="text-sm">
              Chat history is a raw transcript — thousands of lines of back-and-forth. A session summary is a
              <strong> curated brief</strong>: what matters, distilled into a few paragraphs. Claude reads the summary
              in seconds; rereading a full transcript would eat into your context window and slow everything down.
            </p>
            <p className="text-sm mt-2">
              Think of it like meeting notes vs. a meeting recording. You want the notes.
            </p>
          </Expandable>
        </SectionCard>


        {/* SECTION: Safety & Hooks */}
        <SectionCard id="safety" icon={<IconShield />} title="Safety & Guardrails" tier="Week 1" tierColor="blue">
          <p>
            Claude Code can edit files, run commands, and make changes on your machine. That's powerful — and
            it means a few guardrails are worth setting up.
          </p>

          <div className="space-y-3 mt-2">
            <div className="flex gap-3 items-start">
              <div className="w-1.5 h-1.5 rounded-full bg-teal-brand mt-2.5 shrink-0" />
              <div>
                <p className="font-medium text-stone-800">The Constitution</p>
                <p className="text-sm">Three rules in your CLAUDE.md that Claude will never override: default to reversible actions,
                say "I don't know" when uncertain, and no hidden actions. These are already in the template.</p>
              </div>
            </div>
            <div className="flex gap-3 items-start">
              <div className="w-1.5 h-1.5 rounded-full bg-teal-brand mt-2.5 shrink-0" />
              <div>
                <p className="font-medium text-stone-800">Safety-net hook</p>
                <p className="text-sm">Blocks genuinely dangerous commands — things like deleting your home directory
                or force-pushing over your main branch. A hard stop that protects you even if Claude makes a mistake.</p>
              </div>
            </div>
            <div className="flex gap-3 items-start">
              <div className="w-1.5 h-1.5 rounded-full bg-teal-brand mt-2.5 shrink-0" />
              <div>
                <p className="font-medium text-stone-800">Backup-before-edit hook</p>
                <p className="text-sm">Creates a timestamped copy of any file before Claude modifies it. If something goes wrong,
                you can always get back to the previous version.</p>
              </div>
            </div>
            <div className="flex gap-3 items-start">
              <div className="w-1.5 h-1.5 rounded-full bg-teal-brand mt-2.5 shrink-0" />
              <div>
                <p className="font-medium text-stone-800">Permission prompts</p>
                <p className="text-sm">Claude Code already asks for permission before running commands or editing files.
                You can adjust how strict this is in your settings — start strict and loosen as you build trust.</p>
              </div>
            </div>
          </div>
        </SectionCard>


        {/* SECTION: Level Up */}
        <SectionCard id="level-up" icon={<IconArrowUp />} title="When You're Ready: Level Up" tier="Power User" tierColor="purple">
          <p>
            Once you're comfortable with the basics, here's what takes Claude Code from great to transformative.
          </p>

          <div className="grid md:grid-cols-2 gap-4 mt-2">
            <div className="bg-violet-50/50 rounded-xl p-5 border border-violet-200/40">
              <h3 className="font-semibold text-stone-800 mb-2">Memory Architecture</h3>
              <p className="text-sm">
                Beyond session summaries, you can set up a <code className="px-1 py-0.5 bg-white rounded text-xs font-mono">MEMORY.md</code> file
                where Claude stores patterns it notices about your work — your preferences, recurring solutions,
                tools that work well together. It's like building institutional knowledge.
              </p>
            </div>

            <div className="bg-violet-50/50 rounded-xl p-5 border border-violet-200/40">
              <h3 className="font-semibold text-stone-800 mb-2">Custom Skills & Commands</h3>
              <p className="text-sm">
                Create reusable workflows that Claude can run with a single command. A marketing audit,
                a content calendar builder, a competitive analysis — whatever you do repeatedly,
                you can teach Claude to do it your way.
              </p>
            </div>

            <div className="bg-violet-50/50 rounded-xl p-5 border border-violet-200/40">
              <h3 className="font-semibold text-stone-800 mb-2">Agent Teams</h3>
              <p className="text-sm">
                Spawn multiple Claude agents that work in parallel. One researches competitors while another
                drafts content while a third builds a Notion dashboard. It's like having a team that works
                simultaneously on different parts of a project.
              </p>
            </div>

            <div className="bg-violet-50/50 rounded-xl p-5 border border-violet-200/40">
              <h3 className="font-semibold text-stone-800 mb-2">Advanced Hooks</h3>
              <p className="text-sm">
                Context monitoring (alerts you when a session is running long), phone notifications
                (Pushover alerts when Claude needs your input), relay systems for cross-session handoffs,
                and more. The automation layer gets as sophisticated as you want it.
              </p>
            </div>
          </div>

          <p className="text-sm text-stone-500 mt-4 italic">
            You don't need any of this on day one. The CLAUDE.md and basic setup above will get you
            further than most people ever get. Come back to this section when you're ready.
          </p>
        </SectionCard>


        {/* ── THE TEMPLATE ── */}
        <section id="template" className="scroll-mt-24">
          <div className="bg-gradient-to-br from-teal-brand to-teal-700 rounded-2xl p-8 md:p-10 text-white shadow-lg">
            <div className="flex items-center justify-between mb-6 flex-wrap gap-4">
              <div>
                <h2 className="text-2xl font-bold">Your Starter CLAUDE.md</h2>
                <p className="text-teal-100 mt-1">Copy this template and customize the [bracketed] sections</p>
              </div>
              <button
                onClick={copyTemplate}
                className={`flex items-center gap-2 px-5 py-2.5 rounded-xl font-semibold transition-all shadow-sm ${
                  copied
                    ? 'bg-emerald-500 text-white'
                    : 'bg-white text-teal-brand hover:bg-teal-50'
                }`}
              >
                <IconClipboard copied={copied} />
                {copied ? 'Copied!' : 'Copy Template'}
              </button>
            </div>

            <div className="bg-stone-900/80 rounded-xl p-5 md:p-6 overflow-x-auto max-h-[600px] overflow-y-auto">
              <pre className="text-sm text-stone-300 whitespace-pre-wrap font-mono leading-relaxed">
                {CLAUDE_MD_TEMPLATE}
              </pre>
            </div>

            <div className="mt-6 bg-teal-800/50 rounded-xl p-5">
              <h3 className="font-semibold text-white mb-2">After you copy this template:</h3>
              <ol className="list-decimal list-inside text-sm text-teal-100 space-y-1.5">
                <li>Open Claude Code and paste the template</li>
                <li>Say: <em>"Save this as my CLAUDE.md file at ~/.claude/CLAUDE.md"</em></li>
                <li>Fill in the <code className="px-1 py-0.5 bg-teal-900/50 rounded text-xs">[bracketed sections]</code> with your details</li>
                <li>Start a new session — Claude will load your instructions automatically</li>
              </ol>
            </div>
          </div>
        </section>


        {/* ── TIPS ── */}
        <section className="bg-amber-50/60 rounded-2xl border border-amber-200/40 p-8 md:p-10">
          <h2 className="text-xl font-bold text-stone-900 mb-4">Quick Tips for Marketing Execs</h2>
          <div className="space-y-3 text-sm text-stone-600">
            <div className="flex gap-3 items-start">
              <span className="text-amber-600 font-bold mt-0.5">01</span>
              <p><strong className="text-stone-800">You don't need to write code.</strong> Claude Code writes and runs code for you.
              Your job is to describe what you want in plain language — the clearer, the better.</p>
            </div>
            <div className="flex gap-3 items-start">
              <span className="text-amber-600 font-bold mt-0.5">02</span>
              <p><strong className="text-stone-800">Treat it like onboarding a new hire.</strong> The more context you put in your CLAUDE.md,
              the better Claude performs. Update it as you learn what works.</p>
            </div>
            <div className="flex gap-3 items-start">
              <span className="text-amber-600 font-bold mt-0.5">03</span>
              <p><strong className="text-stone-800">Start simple, add complexity later.</strong> The CLAUDE.md template alone puts you
              ahead of 90% of users. Hooks, plugins, and custom skills can come when you need them.</p>
            </div>
            <div className="flex gap-3 items-start">
              <span className="text-amber-600 font-bold mt-0.5">04</span>
              <p><strong className="text-stone-800">Ask Claude to help you set things up.</strong> Want a hook? Ask Claude to create it.
              Want to connect Notion? Ask Claude how. It's recursive — Claude is the best guide to Claude.</p>
            </div>
            <div className="flex gap-3 items-start">
              <span className="text-amber-600 font-bold mt-0.5">05</span>
              <p><strong className="text-stone-800">The CLAUDE.md evolves.</strong> Your first version won't be perfect. After a few sessions,
              you'll know what to add. The best CLAUDE.md files are built iteratively, not written once.</p>
            </div>
          </div>
        </section>


        {/* ── RESOURCES ── */}
        <section className="bg-white rounded-2xl shadow-sm border border-stone-200/60 p-8 md:p-10">
          <h2 className="text-xl font-bold text-stone-900 mb-2">Official Resources</h2>
          <p className="text-sm text-stone-500 mb-6">Bookmark these — they're the best places to go deeper when you're ready.</p>
          <div className="grid md:grid-cols-2 gap-4">
            <a
              href="https://code.claude.com/docs/en/overview"
              target="_blank"
              rel="noopener noreferrer"
              className="group block bg-stone-50 hover:bg-teal-50 rounded-xl p-5 border border-stone-200/60 hover:border-teal-200 transition-colors"
            >
              <div className="flex items-center gap-2 mb-2">
                <svg className="w-5 h-5 text-teal-brand" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={1.5}>
                  <path strokeLinecap="round" strokeLinejoin="round" d="M12 6.042A8.967 8.967 0 0 0 6 3.75c-1.052 0-2.062.18-3 .512v14.25A8.987 8.987 0 0 1 6 18c2.305 0 4.408.867 6 2.292m0-14.25a8.966 8.966 0 0 1 6-2.292c1.052 0 2.062.18 3 .512v14.25A8.987 8.987 0 0 0 18 18a8.967 8.967 0 0 0-6 2.292m0-14.25v14.25" />
                </svg>
                <p className="font-semibold text-stone-800 text-sm group-hover:text-teal-brand transition-colors">Documentation</p>
              </div>
              <p className="text-xs text-stone-500">
                The official Claude Code docs. Everything from installation to advanced features, written clearly with examples.
              </p>
            </a>
            <a
              href="https://code.claude.com/docs/en/quickstart"
              target="_blank"
              rel="noopener noreferrer"
              className="group block bg-stone-50 hover:bg-teal-50 rounded-xl p-5 border border-stone-200/60 hover:border-teal-200 transition-colors"
            >
              <div className="flex items-center gap-2 mb-2">
                <svg className="w-5 h-5 text-teal-brand" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={1.5}>
                  <path strokeLinecap="round" strokeLinejoin="round" d="M3.75 13.5l10.5-11.25L12 10.5h8.25L9.75 21.75 12 13.5H3.75z" />
                </svg>
                <p className="font-semibold text-stone-800 text-sm group-hover:text-teal-brand transition-colors">Quickstart Guide</p>
              </div>
              <p className="text-xs text-stone-500">
                Get up and running in minutes. Step-by-step installation and your first conversation with Claude Code.
              </p>
            </a>
            <a
              href="https://anthropic.skilljar.com/claude-code-in-action"
              target="_blank"
              rel="noopener noreferrer"
              className="group block bg-stone-50 hover:bg-teal-50 rounded-xl p-5 border border-stone-200/60 hover:border-teal-200 transition-colors"
            >
              <div className="flex items-center gap-2 mb-2">
                <svg className="w-5 h-5 text-teal-brand" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={1.5}>
                  <path strokeLinecap="round" strokeLinejoin="round" d="M4.26 10.147a60.438 60.438 0 0 0-.491 6.347A48.62 48.62 0 0 1 12 20.904a48.62 48.62 0 0 1 8.232-4.41 60.46 60.46 0 0 0-.491-6.347m-15.482 0a50.636 50.636 0 0 0-2.658-.813A59.906 59.906 0 0 1 12 3.493a59.903 59.903 0 0 1 10.399 5.84c-.896.248-1.783.52-2.658.814m-15.482 0A50.717 50.717 0 0 1 12 13.489a50.702 50.702 0 0 1 7.74-3.342M6.75 15a.75.75 0 1 0 0-1.5.75.75 0 0 0 0 1.5Zm0 0v-3.675A55.378 55.378 0 0 1 12 8.443m-7.007 11.55A5.981 5.981 0 0 0 6.75 15.75v-1.5" />
                </svg>
                <p className="font-semibold text-stone-800 text-sm group-hover:text-teal-brand transition-colors">Free Video Course</p>
              </div>
              <p className="text-xs text-stone-500">
                Anthropic's official "Claude Code in Action" course. Watch real workflows, see what's possible, learn by example.
              </p>
            </a>
            <a
              href="https://anthropic.ondemand.goldcast.io/on-demand/09d55ee8-3223-481e-88df-357b3e7868c4"
              target="_blank"
              rel="noopener noreferrer"
              className="group block bg-stone-50 hover:bg-teal-50 rounded-xl p-5 border border-stone-200/60 hover:border-teal-200 transition-colors"
            >
              <div className="flex items-center gap-2 mb-2">
                <svg className="w-5 h-5 text-teal-brand" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={1.5}>
                  <path strokeLinecap="round" strokeLinejoin="round" d="M5.25 5.653c0-.856.917-1.398 1.667-.986l11.54 6.347a1.125 1.125 0 0 1 0 1.972l-11.54 6.347a1.125 1.125 0 0 1-1.667-.986V5.653Z" />
                </svg>
                <p className="font-semibold text-stone-800 text-sm group-hover:text-teal-brand transition-colors">Webinar: Claude Code in an Hour</p>
              </div>
              <p className="text-xs text-stone-500">
                On-demand webinar from Anthropic. A hands-on walkthrough of Claude Code — great for seeing it in action before diving in yourself.
              </p>
            </a>
            <a
              href="https://claude.com/blog/category/claude-code"
              target="_blank"
              rel="noopener noreferrer"
              className="group block bg-stone-50 hover:bg-teal-50 rounded-xl p-5 border border-stone-200/60 hover:border-teal-200 transition-colors"
            >
              <div className="flex items-center gap-2 mb-2">
                <svg className="w-5 h-5 text-teal-brand" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={1.5}>
                  <path strokeLinecap="round" strokeLinejoin="round" d="M7.5 8.25h9m-9 3H12m-9.75 1.51c0 1.6 1.123 2.994 2.707 3.227 1.087.16 2.185.283 3.293.369V21l4.076-4.076a1.526 1.526 0 0 1 1.037-.443 48.282 48.282 0 0 0 5.68-.494c1.584-.233 2.707-1.626 2.707-3.228V6.741c0-1.602-1.123-2.995-2.707-3.228A48.394 48.394 0 0 0 12 3c-2.392 0-4.744.175-7.043.513C3.373 3.746 2.25 5.14 2.25 6.741v6.018Z" />
                </svg>
                <p className="font-semibold text-stone-800 text-sm group-hover:text-teal-brand transition-colors">Claude Code Blog</p>
              </div>
              <p className="text-xs text-stone-500">
                Latest updates, new features, and tips straight from Anthropic. Follow along as Claude Code evolves.
              </p>
            </a>
          </div>
        </section>

      </main>


      {/* ── FOOTER ── */}
      <footer className="border-t border-stone-200 bg-white py-8">
        <div className="max-w-4xl mx-auto px-4 sm:px-6 text-center">
          <p className="text-sm text-stone-400">
            Built with Claude Code  ·  Last updated March 2026
          </p>
          <p className="text-xs text-stone-300 mt-1">
            A gift from one marketing exec to another. Go build something amazing.
          </p>
        </div>
      </footer>

    </div>
  )
}
