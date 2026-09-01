# Receipts into your money tracker, tax-ready

Once a month, Claude finds the receipts sitting in your email, pulls out the vendor, amount, date, and category, and files each one into your money tracker, flagging anything that might be tax-relevant so your accountant gets a shortlist instead of a shoebox.

## What you get

- A pass through the month's inbox for receipts, matched against whatever you already use to track money.
- Each receipt logged as one row: vendor, amount, date, category.
- Anything that might be tax-relevant (a business expense, a charitable donation, a medical cost) flagged separately, for your accountant to make the actual call on.
- A tracker that's already current when tax season arrives, instead of a receipts archive you have to reconstruct from scratch every April.

## What you need

If you've already built [recipe 3, the monthly expenses organizer](03-monthly-expenses-organizer.md), this recipe is the natural next step. Recipe 3 turns receipts into one table you look at each month; this one takes that same extraction and files it permanently into whatever tracker you keep, so the record survives past the month you pulled it together.

- **Gmail connected**, the same connection recipe 3 uses. If you've already set that up, this recipe reuses it as-is; if not, connect it the same way, via `/mcp` in Claude Code or the Gmail connector on claude.ai.
- **A tracker to file into.** Any of these works:
  - **Airtable**, if that's already where you track money: connect it via the Airtable connector, and Claude appends rows to your existing base.
  - **A Google Sheet**, via the Drive/Sheets connection. Claude appends rows the same way, just in spreadsheet form.
  - **A CSV file**, the simplest option: Claude reads and rewrites a plain file on your computer, nothing beyond Gmail to connect. If you don't already have a system, start here and move to Airtable or Sheets later if you outgrow a single file.
- Pick the one you'll actually keep up with. The fanciest tracker is worthless if you stop opening it.
- No coding knowledge needed.

## Build it

1. Make sure Gmail is connected, and decide which tracker you're filing into, connecting it too if it isn't already.
2. Paste this prompt, filling in the month and a description of your tracker:

```
Go through my email and find receipts from [month, e.g. "September
2026"] that I haven't already logged. For each one, pull out:

- Vendor / merchant name
- Amount
- Date
- Category (subscriptions, software, travel, office supplies, etc.)
- Whether it might be tax-relevant (business expense, charitable
  donation, medical cost), flagged, not decided

File each one as a new row in [describe your tracker: "my Airtable
base called Finances, table Transactions" / "my Google Sheet called
2026 Expenses" / "the CSV at ~/Documents/finances/tracker.csv"].
Don't duplicate anything already logged; check existing rows first.
```

3. Check the flagged rows before you trust them. "Might be tax-relevant" is a candidate list, not a verdict. Some will turn out not to matter, and Claude won't always catch every deductible expense a specific situation creates.
4. **Claude flags candidates; it doesn't give tax advice. Deductibility is for you and your tax professional to decide.** And keep the original receipt emails — don't delete them once they're logged. The tracker line is a pointer to the receipt, not a substitute for it: if your accountant or the IRS ever wants proof, a row in a spreadsheet won't be enough on its own.
5. Once the tracker looks right, decide how you want this to run each month. See "Make it stick" below.

## Make it stick

- **Keep it manual.** Save this file, and at the end of each month say "run my receipts tracker for [month]," pointing to wherever things go.
- **Turn it into a slash command.** Create `.claude/commands/receipts.md`:

  ```markdown
  ---
  name: receipts
  description: Pull the month's receipts from email and file them into the money tracker, flagged for tax relevance
  argument-hint: "[month, e.g. September 2026]"
  ---

  Go through my email and find receipts from $ARGUMENTS that I
  haven't already logged. Pull vendor, amount, date, and category
  for each, flag anything that might be tax-relevant, and file each
  one as a new row in [your tracker]. Don't duplicate existing rows.
  ```

  Then `/receipts September 2026` runs the whole thing.
- **Schedule it.** Use `/schedule` to run this automatically on the first of each month for the month just finished; the same idea as [recipe 3](03-monthly-expenses-organizer.md), just filing into your permanent tracker instead of stopping at a monthly table.

## Variations

- **Split business and personal.** If one inbox covers both, tell Claude which vendors or categories belong to which, and ask for the split reflected in the tracker: a column, or two separate tables.
- **Year-to-date category totals.** Ask for a running total by category that updates each time you run it, so you can watch the year build without adding up twelve months by hand.
- **Graduate from CSV to Airtable or Sheets.** Once a plain file feels limiting (you want views, filters, or someone else to see it), ask Claude to help move the existing CSV rows into a proper base or sheet, so nothing gets re-entered by hand.
- **Hand your accountant the report.** At tax time, ask for a clean export of just the flagged rows, organized by category, ready to hand off. That beats your accountant re-deriving it from twelve months of raw data.
