# Weekly review

A Friday or Sunday habit: look back at the week that actually happened, not the week you planned. What got done, what's worth remembering, what's still hanging, and what next week is shaping up to look like.

## What you get

A short weekly review, built from your calendar and sent mail. Something like:

> **What happened:** Closed out the Q3 budget review, onboarded two new clients, shipped the redesigned landing page.
> **Wins worth remembering:** Landed the Meridian account after three months of follow-up. Redesigned page went live a week ahead of schedule.
> **Still open:** Haven't replied to the vendor about renewal pricing. Budget sign-off from finance is still pending.
> **Next week:** Heavy on client calls (four scheduled), light on deep work. Worth protecting a morning if you can.

The wins are named specifically, not summarized into "a productive week." That's the part most people skip, and the part worth keeping.

It only covers what your calendar and inbox can show it. A decision made in a hallway conversation or a win nobody emailed about won't show up unless you mention it.

## What you need

The same calendar and email connections as [recipe 1, the daily morning brief](01-morning-brief.md). If you've built that one, you already have what you need here. This recipe just looks back over seven days instead of forward into one. Nothing new to connect.

A place to save each review matters more here than in most recipes. See the note on dated files below — it's what turns a single good summary into something worth returning to.

## Build it

1. **Run the starter prompt below**, on whatever day marks the end of your work week.
2. **Save the result to a dated file**, something like `weekly-reviews/2026-08-28.md`. This is the part that makes the recipe worth repeating: a single review is a nice summary, but a folder of them becomes a record you can look back across.
3. **Check the wins line first.** If it's vague (something like "good progress on client work" instead of naming the actual account), ask Claude to be specific. This is the section most worth pushing on.
4. **Adjust what "next week" means to you.** Some people want a preview of what's already scheduled; others want a gut check on whether the week ahead is realistic. Say which one you want and Claude will lean that way going forward.
5. **After about a month, ask the real question.** "Read my last four weekly reviews. What patterns do you see?" This is the payoff the single-week version can't give you. It's where you'll notice things like every heavy client-call week getting followed by a week where nothing else moved, or a win that quietly repeats every month without you noticing.
6. **Keep the folder even during slow weeks.** A review that says "not much happened, and that was on purpose" is still worth having on file a few months from now, when you're trying to remember whether a quiet stretch was rest or drift.

```
Look back at this week: my calendar and my sent email from
[start date] to [end date]. Give me:

1. What happened: meetings that took place, work that shipped,
   things I sent or finished.
2. 2-3 wins worth remembering. Name them specifically: the actual
   client, project, or outcome, not a general summary.
3. What's still open: anything unresolved, unanswered, or pushed
   to next week.
4. What next week looks like: heavy or light, and on what.

Keep it to a few lines per section. Save this as a dated file so I
can look back across multiple weeks later.
```

## Make it stick

- **Set it on a schedule.** Ask Claude to `/schedule` this for Friday afternoon or Sunday evening, whichever actually marks the end of your week. It'll run as a routine in the cloud and save the file without you having to remember to ask.
- **Save it as a slash command.** Create a file at `.claude/commands/weekly-review.md` with the starter prompt as its contents. Typing `/weekly-review` runs the whole thing, including saving to a dated file.
- **Just keep this file.** No setup required. Open it when Friday rolls around and ask Claude to "run my weekly review." A complete way to use this recipe on its own.

## Variations

- **Pair it with the daily version.** [Recipe 5, the daily evening brief](05-evening-brief.md), is the same muscle at a smaller scale: done today, open today, tomorrow's top 3. Run that daily and this one weekly, and you've got both altitudes covered.
- **Add a goals thread.** If you're tracking 2-3 standing goals for the quarter or year, ask Claude to measure each week against them explicitly — "how did this week move the needle on [goal]?"
- **Split work from life.** If your calendar and inbox mix both, ask for two shorter reviews instead of one blended one. Easier to scan, easier to see what each side of your week actually looked like.
- **Monthly rollup.** Once you've got four weeklies saved, ask Claude to read all four and write one monthly summary. Same idea as the pattern question above, just formalized into its own recurring habit.
- **Read it out loud to someone.** Some people get more out of this by turning the review into a two-minute check-in with a partner or a coworker instead of just reading it themselves. Ask Claude for a version phrased to say out loud, not to skim.
