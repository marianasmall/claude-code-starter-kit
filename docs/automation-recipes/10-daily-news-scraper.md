# Daily news scraper

A daily digest built from the topics and sources you actually care about — not a
generic headline feed you skim past.

## What you get

One digest, one line per story: the headline, one sentence on why it matters to
you specifically, and a link. Built fresh from the web each time you ask, not
pulled from a single outlet or a static list.

## What you need

- **Nothing connected.** Claude Code's web search is built in — no API key, no
  aggregator account, no RSS feed to set up.
- **A short list of what you care about.** 3-5 topics (e.g. "AI regulation in the
  EU," "the used EV market") or specific sources (a publication, a newsletter, a
  commentator you follow). Have that list ready before you start — the more
  specific it is, the better the digest.

## Build it

1. Write down your 3-5 topics or sources. Specific beats broad: "tech news" gives
   Claude nothing to aim at; "enterprise AI adoption" or "what [publication]
   covered this week" does.
2. Ask for the digest. Starting prompt:

```
Give me today's news digest on these topics/sources: [your list].

Format: one line per story — headline, one sentence on why it matters to me
specifically, and a link. Only include links you actually opened and can
confirm are live — skip anything paywalled or that you can't verify, rather
than guessing at a URL.

Keep it to the 5-8 most relevant stories. Skip anything that's just a rehash
of yesterday's news.
```

3. Skim it. If a story doesn't land, that's useful signal for the pruning step
   below, not a failure.
4. **Watch for dead or unverifiable links.** Web search results sometimes include
   pages that are paywalled, redirected, or occasionally invented outright. The
   prompt above already asks Claude to include only links it actually opened —
   if one still doesn't resolve, tell Claude so it can avoid that source next
   time.

## Make it stick

- **Save it as a slash command.** Put your topic list and the prompt into
  `.claude/commands/news-digest.md`:

  ```markdown
  ---
  name: news-digest
  description: Daily digest on my topics
  ---

  Give me today's news digest on: [your topics/sources here].

  One line per story: headline, why it matters to me, and a link you
  actually opened and can verify. 5-8 stories. Skip paywalled or dead
  links.
  ```

  Then `/news-digest` runs it any time.

- **Put it on a schedule.** Use `/schedule` to set this up as a recurring cloud
  routine — tell it to run the digest every morning and it handles the
  recurrence without you having to ask each day.

- **Or just ask.** Keep this recipe file, and each morning tell Claude "run my
  news digest" — no setup required if you'd rather trigger it manually.

## Variations

- **Prune ruthlessly after a week.** Once you've run this for about a week, look
  back at what you actually read versus what you skipped every single time. Drop
  the topics and sources that never earned a click. A tight list of things you
  genuinely read beats a broad one you skim past.
- **Different cadence.** Weekly instead of daily suits slower-moving topics —
  ask for "this week's" digest instead of "today's."
- **Depth on demand.** If one story in the digest deserves more than a line, ask
  Claude to expand just that one into a short summary before you move on.
- **Two lists.** Keep a work list and a personal-interest list separately, and
  ask for two short digests instead of one blended one.
