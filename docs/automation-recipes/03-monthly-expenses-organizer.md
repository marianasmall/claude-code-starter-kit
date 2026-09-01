# Monthly expenses organizer

One organized table of the month's spending — vendor, category, amount, and date — pulled from receipts in your email and, if you have one, a bank export, with anything it couldn't confidently identify flagged for you to check.

## What you get

A single table per month: every receipt Claude could find in your inbox, sorted by date, with vendor, amount, and a best-guess category attached. If you also give it a bank CSV, it matches transactions to receipts so you can see what's documented and what isn't — and it flags anything it's unsure about instead of guessing silently.

This is the recipe for the moment tax season shows up, or an expense report is due, and you'd otherwise be scrolling back through months of inbox search results by hand.

## What you need

- **Gmail connected** — in Claude Code via `/mcp`, or on claude.ai via the Gmail connector — since receipts usually arrive by email.
- **Optionally, a CSV export** from your bank or card as a second source. See [recipe 2, the weekly budget planner](02-weekly-budget-planner.md), for how to find and export one. Combining both catches things a receipt search alone might miss, like a charge that never generated an emailed receipt at all.
- No coding knowledge needed.

## Build it

1. Make sure Gmail is connected. If you also have a CSV for the month, save it into a folder like `~/Documents/expenses/2026-09/`.
2. Paste this prompt, filling in the month and, if you have one, the CSV path:

```
Go through my email and find receipts and purchase confirmations from
[month, e.g. "September 2026"]. For each one, pull out:

- Vendor / merchant name
- Amount
- Date
- A best-guess category (subscriptions, software, travel, office
  supplies, etc.)

[If you have a CSV: Also read the transactions in [path to CSV] and
match them against the receipts you found, so I can see which
transactions have a matching receipt and which don't.]

Put everything into one organized table, sorted by date. Flag anything
you're not confident about — an unfamiliar vendor name, an amount that
doesn't quite match — rather than guessing silently.

Save it as expenses-2026-09.md in [folder].
```

3. Check the flagged items. These are usually vendor names that email receipts obscure (a payment processor's name instead of the actual business) or an amount that got misread from a hard-to-parse email.
4. Fix anything wrong and tell Claude the correction — "that vendor is actually my web hosting, not software" — so the same misread doesn't repeat next month.
5. Keep one file per year and ask Claude to append each month's table to it, so you end up with a running record instead of a folder of scattered files.

## Make it stick

- **Keep it manual.** At the end of each month, say "run my monthly expenses organizer for [month]" and point Claude at any new CSV.
- **Turn it into a slash command.** Save the prompt above as `.claude/commands/organize-expenses.md`, and trigger it with `/organize-expenses September 2026`.
- **Schedule it.** Use `/schedule` to run this automatically on the first of each month for the month just finished, so the table is ready before you need it for taxes, budgeting, or an expense report.

## Variations

- **Split personal and business.** If one inbox covers both, tell Claude which senders or vendors belong to which, and ask for two tables instead of one.
- **Running year-to-date totals.** Ask for a category total that carries forward, updated each time you run it, so you can see the year building without adding up twelve files by hand.
- **Tax prep.** Ask Claude to flag anything that looks tax-deductible based on category, and keep a separate "needs receipt" list for anything without a matching document.
- **Vendor-level detail.** If one vendor shows up constantly (a supplier, a recurring contractor), ask for a dedicated section totaling just that relationship across the year.
- **Pair it with [recipe 2](02-weekly-budget-planner.md).** Cross-check this table against your weekly budget file so the two stay consistent instead of drifting apart.
