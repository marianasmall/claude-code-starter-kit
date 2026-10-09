---
paths:
  - "site/content/events/**/*.md"
  - "site/src/events/**/*.ts"
  - "newsletter/issues/**/*.md"
---

# Event times

- Store every event start and end as UTC with the venue's time zone name alongside it (`start: 2026-11-04T01:00:00Z`, `zone: America/Los_Angeles`). Never store a bare local time.
- Convert to local time only when displaying, using the venue's zone, not the reader's computer.
- Write the day of the week from the converted date, never by hand.

**Why:** a bare "Tuesday 6pm" was once copied into the email from a server set to UTC, and the event went out labeled Wednesday. Half the regulars showed up a day late.

**Check:** if a diff adds a time without `Z` or without a `zone`, it's wrong.
