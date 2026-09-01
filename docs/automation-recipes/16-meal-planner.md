# Meal planner

A week of dinners you don't have to think up yourself, plus one grocery list organized by the aisle you'll actually walk through, instead of a recipe site in one tab and a notes app in another.

## What you get

Seven dinners, each with a one-line description, and a grocery list grouped by store section. Something like:

> **Mon:** Sheet-pan chicken thighs with roasted vegetables
> **Tue:** Black bean tacos with quick-pickled onion
> **Wed:** Leftover night (uses Monday's extra chicken)
> ...
>
> **Produce:** onions, bell peppers, cilantro, limes
> **Meat & dairy:** chicken thighs, cheddar, sour cream
> **Pantry:** black beans, corn tortillas, cumin

Nothing fancy, just a week's worth of "what's for dinner" answered in advance, with a list that matches how you actually shop.

## What you need

Nothing connected. This one doesn't touch your calendar or email. It just needs your preferences, which you give it directly in conversation: household size, dietary needs, cuisines you like, how much time you actually have on weeknights, and what's already sitting in your pantry.

No coding knowledge needed. No accounts to link.

## Build it

1. **Describe your preferences once**, using the starter prompt below.
2. **Get seven dinners and a grocery list back**, organized by store section.
3. **Refine what's off.** If Wednesday doesn't work (you're out that night, or nobody wants tacos twice in one week), say so directly: "swap Thursday for something vegetarian." Claude adjusts and regenerates just the grocery list changes, not the whole week.
4. **Save your preferences to a file.** Once the plan feels right, ask Claude to save what it learned (household size, dietary needs, the cuisines that landed well, the ones that didn't) to a preferences file. This is what keeps next week from starting over as a full interview.
5. **Next week, point to both files.** Ask Claude to read your preferences file and last week's plan before building the new one. That's what keeps Tuesday's tacos from showing up again three weeks running.

```
Build me a week of dinners. Here's what to work with:

- Household: [how many people, any picky eaters]
- Dietary needs: [allergies, preferences, anything to avoid]
- Cuisines we like: [a few examples]
- Weeknight time: [how much time you actually have to cook,
  most nights]
- Already in the pantry: [anything you want used up]

Give me 7 dinners, one line each describing what it is. Then give me
one grocery list covering the whole week, grouped by store section
(produce, meat & dairy, pantry, etc.) so I'm not backtracking through
the store.
```

## Make it stick

- **Save your preferences file, and just ask by phrase.** "Plan my dinners for this week" is enough once the preferences file exists. No setup beyond that first conversation.
- **Save it as a slash command.** Create a file at `.claude/commands/meal-plan.md` with a version of the starter prompt that points to your saved preferences file instead of asking you to fill in the brackets each time. Then `/meal-plan` starts from what Claude already knows about you.
- **Schedule a draft for Sunday morning.** If you'd rather review a plan than start the conversation yourself, ask Claude to `/schedule` this to generate a draft plan and grocery list every Sunday, which you then refine rather than build from scratch.

## Variations

- **Budget mode.** Give Claude a target grocery spend for the week and ask it to plan within that, not just around your preferences.
- **Batch-cook Sunday.** Ask for a version built around one longer Sunday cooking session instead of seven separate weeknight dinners.
- **Use-what's-expiring mode.** List what's actually in your fridge right now and ask Claude to build the week around using it up before it goes bad.
- **Add lunches.** Once dinners feel solved, ask for lunches folded into the same plan and grocery list.
- **Picky-kid mode.** Ask for one guaranteed-safe dinner built into every week (something you know will land) alongside the nights you're free to experiment.
