# Subscription audit

A sweep through months of bank and card transactions that surfaces every recurring charge, flags the ones creeping up in price, and hands you a cancel-candidates list with the monthly savings attached.

## What you get

A list of every subscription and recurring charge it can find in your transaction history, grouped by how often you're billed — monthly and annual — with anything that's gotten more expensive called out by name. Alongside that, a shortlist of likely cancel candidates: duplicate services doing the same job, charges that look like forgotten free-trial conversions, and anything you clearly haven't used in months. Each candidate comes with the monthly amount you'd get back if you cancelled it.

It's the "wait, I'm still paying for that?" moment — except it's Claude reading the statements, not you scrolling back through six months of your own spending trying to remember what half these charges even are.

## What you need

- **A CSV export of your bank or card transactions, covering at least 2-3 months.** This is the one place this recipe is stricter than most: a single month can't show you price creep (a charge going from $9.99 to $14.99) or catch an annual renewal that only shows up once a year. If you've already set up [recipe 2, the weekly budget planner](02-weekly-budget-planner.md), you're exporting this CSV already — just widen the date range when you pull it.
- **A folder to save it in** — the same one you're using for recipe 2 works fine, or any folder Claude Code can read.
- No coding knowledge needed. Claude reads the CSV directly; you never have to open it yourself.

## Build it

1. Export a CSV covering the last 2-3 months of transactions from your bank or card's website — look for "Download," "Export," or "Statements" near your transaction list, and choose CSV rather than PDF. If you can pull 6-12 months, even better — that catches annual charges that only bill once a year.
2. Save it into your folder with a name that tells you the date range, like `transactions-jun-aug-2026.csv`.
3. Open Claude Code in that folder (or point it at the file's path) and paste:

```
I've saved a CSV of my bank/card transactions covering the last
[2-3 months / however many months] at [path to file].

Please:
1. Find every transaction that looks like a recurring subscription
   or membership — streaming, software, apps, gym, meal kits,
   news, cloud storage, anything billed on a regular cycle.
2. Group them by billing frequency: monthly and annual.
3. Flag any vendor whose charge amount increased between the
   earliest and most recent charge in this file — that's price
   creep, and I want to know the old amount, the new amount, and
   the difference.
4. Flag anything that looks like a forgotten free trial that
   converted to a paid charge, and anything where I seem to be
   paying for two services that do the same job (two streaming
   platforms, two note apps, etc.).
5. Build a "cancel candidates" list: for each one, name the
   vendor, the monthly cost, and why it's on the list (unused,
   duplicate, or a trial I might not remember signing up for).
   Add up the total monthly savings if I cancelled everything on
   the list.
6. Save all of this as a markdown file called subscription-audit.md
   in the same folder.
```

4. Read the cancel-candidates list carefully before acting on it. Claude is working from transaction history, not from knowing what you actually use — a charge that looks dormant might be something you use twice a year and still want. Treat the list as a set of things worth checking, not a set of things to cancel on sight.
5. For anything you're unsure about, ask Claude to pull up every transaction for that vendor across the whole file — seeing the full pattern (steady monthly charges vs. one you forgot existed) usually makes the decision obvious.
6. Cancel what you actually decide to cancel yourself, directly with the vendor or your bank. This recipe finds candidates; it doesn't cancel anything.

## Make it stick

- **Keep it manual.** Export a fresh CSV covering the last few months each time you want to re-check, and say "run my subscription audit on this new file."
- **Turn it into a slash command.** Save the prompt above (leaving the file path blank) as `.claude/commands/subscription-audit.md`. Then just type `/subscription-audit [path to file]` whenever you want to re-run it.
- **Schedule the reminder, not the export.** Banks require you to be logged in, so Claude can't pull the file itself — but you can use `/schedule` to set up a recurring cloud reminder (quarterly is plenty for this one) nudging you to export a fresh CSV and re-run the audit.

## Variations

- **Annual-renewal calendar.** Ask Claude to build a second list — everything billed annually, with the date it last charged and roughly when it'll renew again — so nothing auto-renews without you noticing. This one's worth revisiting a month or two before your biggest annual charges are due.
- **Price watch.** Ask Claude to save its findings as a dated snapshot (`subscription-audit-2026-09.md`), then next quarter, run the audit again and ask it to compare the new snapshot against the saved one — same-vendor price changes, anything new that showed up, anything that dropped off.
- **Household version.** If you and a partner both export transactions, ask Claude to combine both files and flag duplicate services across the two of you specifically — the case where you're each separately paying for the same streaming service or cloud storage plan.
- **Category-only view.** If you don't want a cancel list yet, just ask for the recurring-charges breakdown by category (streaming, software, fitness, etc.) so you can see the total before deciding whether to hunt for cuts.
- **Currency or multi-account.** If charges span more than one account or currency, say so up front and ask Claude to combine them and normalize the total before grouping.
