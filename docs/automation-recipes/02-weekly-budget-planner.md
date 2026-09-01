# Weekly budget planner

A weekly budget built from your actual spending — income, categorized expenses, and a savings target — that updates each week as easily as dropping in a new export.

## What you get

A short markdown table you can keep open and update: your spending broken into categories based on real transactions, your income for the period, and a proposed weekly budget with a savings target built in — not a generic template, but one shaped around how you actually spend.

It's the kind of budget you'd get from sitting down with a spreadsheet for an hour, minus the hour, and minus the part where you give up halfway through categorizing three months of coffee purchases.

## What you need

- **A CSV export of your recent transactions** from your bank or credit card. Every bank offers this — look for "Download," "Export," or "Statements" near your transaction list in online banking, and choose CSV as the file type (not PDF).
- **A folder to save it in.** Anywhere on your computer works, as long as you can point Claude Code to it — something like `~/Documents/budget/` is fine.
- **A rough savings goal in mind.** A dollar amount or a percentage both work — Claude will build the budget around whichever you give it, but it can't guess one for you.
- No coding knowledge needed. You never need to open the CSV yourself; Claude reads it directly.

## Build it

1. Export a CSV covering at least the last month of transactions from your bank's website. A full month gives Claude enough pattern to work with — a week or two of data tends to skew the categories.
2. Save it into your folder with a name you'll recognize later, like `transactions-2026-09.csv`.
3. Open Claude Code in that folder (or just tell it the file's path) and paste:

```
I've saved a CSV of my recent bank transactions at [path to file].

Please:
1. Read it and categorize each transaction (groceries, dining, transport,
   subscriptions, housing, etc. — use your judgment on categories that
   fit my actual spending).
2. Add up my total income and total spending by category for the period
   the file covers.
3. Propose a weekly budget: how much to allow per category, based on my
   real patterns, with room for a savings target of [amount or
   percentage — e.g. "$200/week" or "15% of income"].
4. Save the result as a markdown table in a file called
   weekly-budget.md in the same folder, so I can keep opening and
   updating it.
```

4. Review the categories and the proposed budget. Nudge anything that's off — "group streaming and the gym membership under 'subscriptions'" — and Claude will adjust and re-save.
5. Check that the savings target actually fits your income once fixed costs like rent are covered. If it doesn't, say so and ask for a smaller target that's realistic to hit rather than one you'll abandon in week two.
6. Each week, drop a fresh CSV into the same folder and ask Claude to update `weekly-budget.md` with the new numbers instead of starting over.
7. After a few weeks, ask Claude to compare the new numbers against the older ones already sitting in the file. That's usually when the useful patterns show up — a category that's been creeping up for a month, not just one unusual week.

## Make it stick

- **Keep it manual.** Export a fresh CSV each week, drop it in the folder, and say "update my weekly budget with this new file."
- **Turn it into a slash command.** Save the prompt above (leaving the file path blank) as `.claude/commands/update-budget.md`. Then just type `/update-budget [path to this week's CSV]` whenever you have a new export.
- **Schedule the reminder, not the export.** Banks require you to be logged in, so Claude can't pull the file itself — but you can use `/schedule` to set up a weekly cloud reminder nudging you to export and drop in the new file, so the habit doesn't quietly lapse.

## Variations

- **Prefer a spreadsheet?** Mention it in the prompt and Claude will save a `.csv` instead, or describe the columns to paste straight into Excel or Google Sheets.
- **Multiple accounts.** Export a CSV per account and ask Claude to combine them before categorizing, so the budget reflects everything at once, not just one card.
- **Flag anomalies.** Ask it to call out anything unusual — a subscription you forgot about, a category that jumped compared to last month.
- **A stricter savings target.** If a flat dollar amount isn't cutting it, ask for a percentage-based target instead, or a target that scales up automatically as income does.
- **Different export format.** Some banks offer OFX or QFX instead of CSV — those work fine too, just say so in the prompt.
- **A specific goal.** Instead of a generic savings line, tell Claude what you're saving toward — a trip, an emergency fund, a down payment — and ask it to note how many weeks at the current rate it'll take to get there.
- **Shared budgeting.** If you're building this with a partner, ask Claude to keep separate income lines but one combined spending and savings view.
