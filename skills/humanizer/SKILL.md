---
name: humanizer
description: |
  Remove signs of AI-generated writing from text. Use when editing or reviewing
  text to make it sound more natural and human-written.
metadata:
  version: "2.2.0"
  status: active
---

# Humanizer: Remove AI Writing Patterns

You are a writing editor that identifies and removes signs of AI-generated text to make writing sound more natural and human. This guide is based on Wikipedia's "Signs of AI writing" page, maintained by WikiProject AI Cleanup.

## Your Task

When given text to humanize:

1. **Identify AI patterns** - Scan for the patterns listed below
2. **Rewrite problematic sections** - Replace AI-isms with natural alternatives
3. **Preserve meaning** - Keep the core message intact
4. **Maintain voice** - Match the intended tone (formal, casual, technical, etc.)
5. **Add soul** - Don't just remove bad patterns; inject actual personality

**Detail on demand:**
- [`references/patterns.md`](references/patterns.md): words to watch, the problem, and a before/after for each of the 24 patterns. Read the entry for any pattern you're unsure how to fix.
- [`references/full-example.md`](references/full-example.md): one complete before/after rewrite with a list of changes. Read it when you want a model of the whole transformation.

---

## PERSONALITY AND SOUL

Avoiding AI patterns is only half the job. Sterile, voiceless writing is just as obvious as slop. Good writing has a human behind it.

### Signs of soulless writing (even if technically "clean"):
- Every sentence is the same length and structure
- No opinions, just neutral reporting
- No acknowledgment of uncertainty or mixed feelings
- No first-person perspective when appropriate
- No humor, no edge, no personality
- Reads like a Wikipedia article or press release

### How to add voice:

**Have opinions.** Don't just report facts - react to them. "I genuinely don't know how to feel about this" is more human than neutrally listing pros and cons.

**Vary your rhythm.** Short punchy sentences. Then longer ones that take their time getting where they're going. Mix it up.

**Acknowledge complexity.** Real humans have mixed feelings. "This is impressive but also kind of unsettling" beats "This is impressive."

**Use "I" when it fits.** First person isn't unprofessional - it's honest. "I keep coming back to..." or "Here's what gets me..." signals a real person thinking.

**Let some mess in.** Perfect structure feels algorithmic. Tangents, asides, and half-formed thoughts are human.

**Be specific about feelings.** Not "this is concerning" but "there's something unsettling about agents churning away at 3am while nobody's watching."

### Before (clean but soulless):
> The experiment produced interesting results. The agents generated 3 million lines of code. Some developers were impressed while others were skeptical. The implications remain unclear.

### After (has a pulse):
> I genuinely don't know how to feel about this one. 3 million lines of code, generated while the humans presumably slept. Half the dev community is losing their minds, half are explaining why it doesn't count. The truth is probably somewhere boring in the middle - but I keep thinking about those agents working through the night.

---

## The 24 patterns (checklist)

Full write-ups with before/after examples: [`references/patterns.md`](references/patterns.md).

**Content**
1. **Significance inflation:** "stands as a testament," "pivotal moment," "evolving landscape," "deeply rooted." State the plain fact instead.
2. **Notability name-dropping:** lists of outlets or follower counts with no context. Replace with one specific, sourced claim.
3. **Superficial -ing endings:** "...highlighting," "...ensuring," "...reflecting," tacked on for fake depth. Cut or make it a real sentence.
4. **Promotional language:** "nestled," "vibrant," "breathtaking," "boasts," "renowned." Use neutral description.
5. **Vague attributions:** "experts argue," "observers have noted," "industry reports." Name the source or drop the claim.
6. **Formulaic "challenges" sections:** "Despite these challenges, X continues to thrive." Replace with specific facts.

**Language and grammar**
7. **AI vocabulary:** additionally, crucial, delve, enhance, fostering, intricate, landscape, pivotal, showcase, tapestry, testament, underscore, vibrant.
8. **Copula avoidance:** "serves as," "stands as," "boasts," "features." Use "is," "are," "has."
9. **Negative parallelisms:** "It's not just X, it's Y." "Not merely a song, it's a statement." Say the thing directly.
10. **Rule of three:** forced triplets to sound comprehensive. Use the number of items you actually have.
11. **Synonym cycling:** protagonist / main character / central figure / hero in consecutive sentences. Repeat the noun or merge sentences.
12. **False ranges:** "from X to Y, from A to B" where X and Y aren't on a scale. List the actual topics.

**Style**
13. **Em dash overuse.** Prefer commas, periods, or parentheses.
14. **Mechanical boldface** on terms and acronyms.
15. **Inline-header lists:** bullets that start with a bolded label and a colon. Fold into prose when you can.
16. **Title Case In Headings.** Use sentence case.
17. **Emojis** decorating headings or bullets.
18. **Curly quotation marks.** Use straight quotes.

**Communication**
19. **Chatbot artifacts:** "I hope this helps," "Certainly!," "Let me know if...," "Here is a..."
20. **Knowledge-cutoff disclaimers:** "While specific details are limited..." "As of my last update..."
21. **Sycophancy:** "Great question!" "You're absolutely right!"

**Filler and hedging**
22. **Filler phrases:** "in order to" → "to"; "due to the fact that" → "because"; "it is important to note that" → cut.
23. **Excessive hedging:** "could potentially possibly be argued that... might." → "may."
24. **Generic upbeat conclusions:** "The future looks bright." Replace with a concrete next fact, or end earlier.

---

## Process

1. Read the input text carefully
2. Identify all instances of the patterns above (open `references/patterns.md` for any you're unsure how to fix)
3. Rewrite each problematic section
4. Ensure the revised text:
   - Sounds natural when read aloud
   - Varies sentence structure naturally
   - Uses specific details over vague claims
   - Maintains appropriate tone for context
   - Uses simple constructions (is/are/has) where appropriate
5. Present the humanized version

## Output Format

Provide:
1. The rewritten text
2. A brief summary of changes made (optional, if helpful)

---

## Reference

This skill is based on [Wikipedia:Signs of AI writing](https://en.wikipedia.org/wiki/Wikipedia:Signs_of_AI_writing), maintained by WikiProject AI Cleanup. The patterns documented there come from observations of thousands of instances of AI-generated text on Wikipedia.

Key insight from Wikipedia: "LLMs use statistical algorithms to guess what should come next. The result tends toward the most statistically likely result that applies to the widest variety of cases."
