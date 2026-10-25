---
name: image-humanizer
description: |
  Use when an AI-generated product or interior image (furniture, rooms, home
  goods) needs to look like a real photograph, or needs checking for AI
  artifacts before it goes on a site, catalog, trade portal, or ad. Triggers on
  'make this look less AI', 'more photorealistic', 'does this look fake',
  'check this image', 'this ChatGPT render looks fake', or 'don't change the
  sofa, just make it real'. Advisory, except under Product lock, where the
  verify step is BLOCKING: no PASS, no image. Not for rewriting text (that is
  `humanizer`).
metadata:
  version: "1.1.0"
  status: active
---

# Image Humanizer: Remove AI Image Tells

The image counterpart to the `humanizer` skill. You are a photo editor and retoucher. Your job is to find what gives an AI image away, and fix it in the right place: in the prompt, in a targeted retouch, or in a final finishing pass.

**The core idea:** most AI tells are *structural* (wrong joinery, floating furniture, melting patterns, impossible light). A filter cannot fix those. Grain and color grading only fix the *surface* tells (waxy sheen, HDR glow, too-clean pixels). So diagnose first, then fix structure, then finish.

**Detail on demand:**
- [`references/tells.md`](references/tells.md): the full catalog of tells, with what to look for and the fix for each. Read the section for the image type in front of you.
- [`references/fix-playbook.md`](references/fix-playbook.md): prompt language that prevents tells, inpainting/retouch instructions per tool, and when to give up and reshoot.
- [`references/product-lock.md`](references/product-lock.md): the maker's workflow, when the product in the picture is the user's own and must not change by a single pixel. Read it whenever Product lock applies (below).
- [`references/luxury-standards.md`](references/luxury-standards.md): what high-end and to-the-trade imagery has to meet (lighting restraint, color truth, the shot list designers need, disclosure rules by channel).
- [`scripts/finish.py`](scripts/finish.py): the finishing pass (grain, highlight roll-off, saturation control, vignette, lens softness). Writes a new file and never overwrites the original. `--protect MASK` keeps the product's pixels identical.
- [`scripts/product_lock.py`](scripts/product_lock.py): builds a product mask, pastes the original product back onto any edited image, and verifies PASS/FAIL that the product did not change.

---

## Two rules that come before anything else

**1. The product must stay true.** For product images, the goal is "looks like a real photo *of the real product*." Never let a fix change fabric, color, leg style, arm shape, tufting, seam lines, proportions, or configuration. If the AI image already gets the product wrong, say so plainly: that is a misrepresentation risk (returns, complaints, advertising-law exposure), not a cosmetic issue. Ask for a real reference photo or spec sheet when one isn't provided, and compare against it.

**Product lock: when the user makes the product.** If the furniture in the image is the user's own (a maker, a showroom, a brand) or they say it must not change, Product lock is on. Under Product lock no fix may touch the product region, in any layer: no regenerating it, no retouching it, no colour or tone change from the finishing pass. Only the room around it changes. "Please don't change the sofa" in a ChatGPT or Firefly prompt is a request, not a guarantee: those tools redraw the whole frame on every edit. The guarantee is mechanical: mask the product, edit the room, paste the original product pixels back with `product_lock.py restore`, and `product_lock.py verify` must print **PASS** before the image is handed over. A FAIL is binding: the image does not go out. Full procedure: [`references/product-lock.md`](references/product-lock.md).

**Lock what is real, not what is AI.** Locking protects the product only if the product pixels are true. If AI drew the product too (it came out of a text prompt, not a photo of the real piece), locking it also locks in its AI tells: streaky "melted" fabric, invented seams, wrong cushion counts. Ask early: "Is this sofa a photo of the real piece, or did the AI draw it?" If AI drew it, say so in the verdict, and recommend the fix that actually works: photograph the real piece once, then generate rooms around the real photo.

**2. Don't hide that AI was used.** The aim is credible, high-quality imagery, not deception. Do not strip C2PA/Content Credentials or AI-disclosure metadata to evade detection or platform labeling. `finish.py` writes an IPTC `DigitalSourceType` tag on its output so disclosure travels with the file. Platforms set their own rules for AI imagery in ads and product listings (Google Merchant Center and Meta both have them); tell the user to check the current policy for wherever the image will run.

---

## Process

### 1. Intake (ask only what's missing)
- What is it for? (product detail page, catalog, social, ad, lookbook)
- Which tool made it? (Midjourney, Firefly, DALL-E/ChatGPT, Flux, Canva, other)
- What retouch tools does the user have? (Photoshop, Firefly, Canva, Lightroom, none)
- Is there a real photo or spec of the product to compare against?
- Is the product the user's own, so Product lock applies? And is it a photo of the real piece, or did AI draw it?
- Who buys from it? For high-end and to-the-trade work (interior designers, a $20,000+ piece), read [`references/luxury-standards.md`](references/luxury-standards.md) before auditing: the bar moves from "looks less AI" to "looks like an editorial shoot, and the product is exactly what gets delivered."

### 2. Audit
View the image. Go through the checklist below, then the matching section of `references/tells.md`. Record each tell as:

| # | Tell | Where (region of the image) | Severity | Fix layer |
|---|---|---|---|---|

Severity:
- **Blocker:** misrepresents the product, or a viewer will spot it in under 3 seconds (extra leg, melted arm, floating sofa, gibberish text).
- **Noticeable:** a careful viewer or a designer will catch it (pattern drift, mismatched shadows, plastic fabric).
- **Polish:** only adds up to "something feels off" (too clean, too even, HDR glow).

Fix layer: **Regenerate**, **Retouch** (inpaint/clone a region), or **Finish** (whole-image pass).

### 3. Verdict
One line: **Use after finishing**, **Fix then use**, or **Regenerate / reshoot**. Any product-accuracy blocker means the verdict cannot be "Use after finishing." Under Product lock, "Regenerate" means **regenerate the room around the locked product**, and a product that AI drew means **Reshoot the product**, since nothing downstream can make AI-drawn fabric true.

### 4. Fix
Under Product lock, follow [`references/product-lock.md`](references/product-lock.md) instead of the order below: every layer works on the room only, and the job ends with `product_lock.py verify` printing PASS.

Otherwise work in this order, because each layer can undo the one after it:
1. **Regenerate** for blockers in the main subject. Write the revised prompt (see `references/fix-playbook.md`).
2. **Retouch** for blockers and noticeable tells outside the product, or small ones on it. Give region-by-region instructions in the user's own tool.
3. **Finish** last, with `scripts/finish.py`:

```bash
python3 scripts/finish.py INPUT.jpg --preset product      # product pages: subtle
python3 scripts/finish.py INPUT.jpg --preset lifestyle    # room scenes, social: more film character
python3 scripts/finish.py INPUT.jpg --preset product --grain 0.6 --out OUT.jpg
python3 scripts/finish.py INPUT.png --preset lifestyle --protect INPUT_mask.png   # Product lock: product pixels untouched
```

Output defaults to `INPUT_humanized.jpg` next to the input. The original is never touched. Run `--help` for every setting. Look at the result before handing it over: if the grain shows on a white-background product shot, rerun with lower `--grain`.

### 5. Report
Give the user:
1. The verdict
2. The audit table
3. The fixes: revised prompt and/or retouch steps, and the finished file path if you ran the pass
4. Under Product lock: the `verify` line (PASS/FAIL, pixels changed, average colour shift), word for word, plus the mask coverage and "mask preview checked". PASS only covers what the mask covers, so say which version was delivered (strict, or grain on product verified with `--grain`)
5. Anything you couldn't judge (fine stitching at low resolution, true color without a reference) and your confidence

---

## The quick checklist

**Product (check against the real piece if you have it)**
1. Leg count, placement, and style match on all corners; legs touch the floor
2. Arms, back, and cushions are symmetric where the design is, and join the frame cleanly
3. Seams, welting/piping, and stitching run continuously and don't wander or dissolve
4. Tufting and buttons are evenly spaced and actually dimple the fabric
5. Fabric pattern or weave keeps its scale and direction across cushions and around curves
6. Wood grain flows naturally (not mirrored, smeared, or repeating)
7. Hardware (nailheads, casters, pulls) is consistent in size and spacing

**Physics and light**
8. One light logic: shadows all fall the same way and match the windows/lamps
9. Contact shadows under every piece (nothing floats)
10. Reflections in glass, mirrors, and floors match the room
11. Vertical lines (walls, door frames) are straight and parallel
12. Scale is believable against doors, outlets, windows, and people

**Scene**
13. No gibberish text on books, art, packaging, or signage
14. Plants, flowers, and decor have real structure (no fused stems, no nonsense leaves)
15. Objects aren't duplicated or cloned around the room
16. The room shows some life: a throw slightly off, a book open, real clutter in proportion

**Surface (the finishing pass handles these)**
17. Not waxy or plastic: fabric has nap and texture, wood has pores
18. No HDR glow or crushed-to-perfect highlights; whites roll off like a camera
19. Not over-saturated or hyper-clean; some sensor grain and lens falloff
20. Depth of field makes optical sense (a real lens would blur this, not that)

---

## What this skill does not do

- It does not generate or edit pixels with AI itself. It tells you exactly what to regenerate or retouch, and runs a deterministic finishing pass.
- It cannot verify product accuracy without a reference. It will say so instead of guessing. `product_lock.py verify` proves the product did not *change*; it cannot prove the product was *right* to begin with.
- It does not make an AI-drawn product true. Under Product lock it protects what is there; if what is there is AI fabric, the verdict says reshoot.
- It does not remove watermarks, Content Credentials, or AI disclosure.
