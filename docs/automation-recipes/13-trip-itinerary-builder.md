# Trip itinerary builder

Every confirmation email lives in a different thread: the flight, the hotel, the rental car, the dinner reservation your friend booked. This recipe pulls them all together into one itinerary you can actually read, in order, with the gaps still showing.

## What you get

One chronological itinerary for a trip, built from the confirmations sitting in your inbox. Something like:

> **Fri Oct 9:** Depart LAX 6:40am (Confirmation ABC123) → Arrive Lisbon 6:15am+1
> **Fri Oct 9:** Check in, Hotel Avenida, 3pm (Confirmation LIS-4471)
> **Sat Oct 10:** Dinner, Taberna da Rua, 8pm (reservation confirmed)
> **Sun Oct 11:** *Nothing planned yet*

Dates, times, confirmation numbers, and addresses where the email had them. It flags the gaps too, instead of pretending the trip is more planned than it actually is.

It only covers what showed up as a confirmation email. A reservation your travel companion booked under their own name, or a plan made over the phone, won't show up unless you tell Claude about it directly.

## What you need

- **Gmail connected**, so Claude can search for the confirmation emails itself. In Claude Code, connect it with the `/mcp` command; on claude.ai, turn it on under Settings → Connectors. [Recipe 1, the daily morning brief](01-morning-brief.md), walks through this same one-time setup if you haven't done it yet.
- If your inbox isn't connected, this still works too. Forward or paste the confirmation emails into the conversation and Claude builds the itinerary from those instead.
- No coding knowledge needed. This is a conversation, not a setup project.

## Build it

1. **Name the trip.** Tell Claude what you're looking for. "My Lisbon trip in October" is enough — it doesn't need exact dates, it can find those in the confirmations.
2. **Run the starter prompt below.** Claude searches your inbox for flight, hotel, rental car, and restaurant confirmations tied to that trip and lays them out in order.
3. **Check the gaps.** The itinerary will call out stretches with nothing booked yet: an afternoon with no plan, a day with no dinner reservation. That's expected, not an error.
4. **Ask it to fill the gaps, as suggestions, not bookings.** Once you can see the shape of the trip, ask something like "what could fill Sunday afternoon?" Claude can suggest neighborhoods, day trips, or restaurants worth looking into, clearly labeled as ideas to check out yourself, not things that are booked or confirmed.
5. **Re-run it as you book more.** Every time you confirm a new reservation, ask Claude to rebuild the itinerary. It'll fold the new piece in and the gaps will shrink.
6. **Correct mistakes as you spot them.** If Claude misreads a time or skips over a confirmation buried in a long thread, fix it and point out what it missed. It'll do better on the next similar email.

```
I'm planning a trip: [name of trip, e.g. "Lisbon in October"].
Search my email for confirmations related to it: flights, hotels,
rental cars, restaurant reservations, anything with a date attached.

Build one chronological itinerary: date, time, what it is, confirmation
number if there is one, and address if there is one. Where there's a
gap (a day or a stretch of hours with nothing booked), call it out
instead of skipping over it.

Don't suggest anything to fill the gaps yet. Just show me what's
actually confirmed.
```

**Verify everything against the original emails before you travel.** This itinerary is a convenience copy, not the source of truth. The airline's email or app is. Extraction can misread a time or a confirmation number, and schedules change after you book, especially flights. Before you leave for the airport, check the actual confirmation, not just what Claude pulled together. Claude never books or changes anything on your behalf here. It only reads what's already in your inbox and organizes it.

## Make it stick

- **Save this file and ask by name.** "Build my Lisbon itinerary" or "update my trip itinerary" is a complete way to use this. No setup required.
- **Save it as a slash command.** Create a file at `.claude/commands/itinerary.md` with the starter prompt as its contents (leave the trip name as a placeholder you fill in each time). Then `/itinerary` gets you most of the way there.
- **Schedule a refresh while you're still booking.** If you're mid-planning and confirmations are trickling in over a few weeks, ask Claude to `/schedule` a daily check that rebuilds the itinerary and flags anything new it found. Turn it off once the trip is locked in.

## Variations

- **Printable one-pager.** Ask for a version formatted to fit on one page, for printing or handing to someone who isn't traveling with you.
- **Phone-friendly version.** Ask for something short enough to screenshot: just the next 24 hours, no confirmation numbers, so it's fast to check standing in an airport.
- **Packing list.** Once the itinerary exists, ask Claude to build a packing list from the destination, the dates, and the weather it can find for that time of year.
- **Shared-trip version.** Traveling with others? Ask for a version stripped of anything private (no confirmation numbers, no payment details) that's safe to forward to travel companions.
- **What's still missing.** Ask "what do I still need to book?" and get a short checklist instead of a full itinerary. Useful early in planning, before there's much to lay out yet.
