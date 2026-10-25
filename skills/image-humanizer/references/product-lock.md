# Product Lock: The Maker's Workflow

For when the furniture in the picture is the user's own and must not change: not the fabric, the texture, the style, the pillow arrangement, the colour. Only the room around it may change.

Contents: 1. Why prompting isn't enough · 2. First question: is the product real? · 3. The procedure · 4. Room-only edits by tool · 5. Grain on the product · 6. What FAIL means

---

## 1. Why prompting isn't enough

ChatGPT, Firefly, Midjourney and Flux do not edit a picture the way a retoucher does. On every edit they redraw the whole frame from scratch, guided by the old one. "Keep the sofa exactly the same" makes the sofa *similar*: the pile direction shifts, a seam moves, the teal drifts a shade, a pillow changes angle. Over three or four edits it is a different sofa.

The guarantee has to come from the pixels: keep the original product pixels, put them back on top after any edit, and measure that they match.

## 2. First question: is the product real?

Ask before anything else: **is the product in this image a photo of the real piece, or did AI draw it from a text prompt?**

| Answer | What Product lock does | Verdict |
|---|---|---|
| Real photo (studio shot, showroom, composite of a real cut-out) | Protects true pixels. The room can be regenerated as often as needed. | Fix the room, then use |
| AI drew it, and the maker confirms it matches the piece (fabric, cushions, arms, base) | Protects it, but its AI fabric tells stay. Say which ones. | Usable for mood and social; not for the product page or trade portal |
| AI drew it, and it doesn't match the piece, or nobody has checked | Would lock in a misrepresentation | **Reshoot the product.** Don't polish it. |

The best route for a maker: **photograph each piece once** (plain background, even light, true colour with a grey card or colour checker in one frame), cut it out, and generate rooms around the real photo. The product stays 100% real, and one shoot feeds dozens of lifestyle images.

## 3. The procedure

```bash
# 1. Mask: white = product. Start from a colour key plus a box around the piece.
python3 scripts/product_lock.py mask ORIGINAL.png --hue 165-205 --box x0,y0,x1,y1

# 2. Check the preview by eye (ORIGINAL_mask_preview.jpg): the whole product
#    bright, nothing else. Fix misses in Photoshop (Select > Subject, refine,
#    save as a black-and-white PNG) or rerun with a tighter --hue / --box.

# 3. Edit the ROOM in any tool (section 4). Keep the framing: same crop, same size.

# 4. Put the real product back, then prove it.
python3 scripts/product_lock.py restore ORIGINAL.png EDITED.png --mask ORIGINAL_mask.png
python3 scripts/product_lock.py verify  ORIGINAL.png EDITED_locked.png --mask ORIGINAL_mask.png

# 5. Finish the whole frame, with the product protected, and verify again.
python3 scripts/finish.py EDITED_locked.png --preset lifestyle --protect ORIGINAL_mask.png
python3 scripts/product_lock.py verify ORIGINAL.png EDITED_locked_humanized.png --mask ORIGINAL_mask.png
```

**The mask is the weak point.** `verify` proves the pixels *inside* the mask didn't change. A pillow the mask missed can change and still PASS. So the preview check is part of the proof, and the report states the mask coverage and that the preview was checked.

**Finding the hue:** sample the product colour in any editor and read the H value in degrees, in the lit areas *and* the shadowed folds. Shadows shift hue: on a teal velvet, the lit pile reads around 175–195 and the shadows drop to about 150. Start wide (teal 145–210, navy 205–245, green 85–155, red wraps 340–20) and widen until the preview shows the whole product. Neutral products (ivory, grey, black, natural linen) have almost no hue, so a colour key won't separate them from a cream room: draw the mask by hand (Photoshop Select Subject, Canva background remover on a duplicate, or a lasso) and save it as a black-and-white PNG the same size as the image.

**Masters are PNG.** JPEG re-encoding moves every pixel slightly, product included. Keep the verified PNG as the master and export JPEGs for the web from it.

**Where the room cuts into the product.** Check the mask outline for edges that aren't the product's own: a plant's leaves across a back cushion, a step or floor edge slicing the base, a table hiding a leg. Each one is an occlusion, and the locked outline now has the room's shape cut into it. Two consequences:
- **Keep every occluder in place.** If a room edit removes the plant or moves the step, the tool must invent the hidden part of the product (invented furniture), or the product ends abruptly in mid-air and looks chopped off. Say so in the room prompt, and check the result along every cut edge.
- **Flag occlusion that hides a defining detail.** A step slicing the base hides exactly what designers spec (base, plinth, legs), and props over cushions blur the silhouette. Under Product lock this can't be fixed, so the audit flags it, and the fix is a real photo of the whole piece composited into a room that leaves the product clear.

Watch for AI geometry errors at these edges: an AI often draws the occluder *into* the product (a step edge that slices through a sofa that should sit in front of it). That's a room blocker, and Product lock freezes it into the outline.

**Shadows.** The mask covers the piece, not its shadow. Contact shadows belong to the room, so a room edit may (and often should) strengthen them: a sofa with no contact shadow floats (tells.md C2).

## 4. Room-only edits by tool

**Photoshop (best for this):**
1. Open the original. Open the mask PNG too, then Select > All and Edit > Copy.
2. Back in the original, open Window > Channels, click the New Channel button at the bottom, and Edit > Paste. You now have a channel called Alpha 1 holding the mask.
3. Cmd-click (Ctrl-click on Windows) the Alpha 1 thumbnail to load it as a selection, then Select > Inverse, so the room is selected and the product isn't.
4. Generative Fill the room in sections ("plain plaster wall, soft daylight", "remove", "oak floor with natural wear"). Keep any object that sits in front of the product.
5. Flatten, and File > Export > Export As > PNG at the same pixel size as the original (no resizing, no cropping).
6. Run restore + verify on the export anyway. Generative Fill can spill a pixel or two past a selection edge, and verify is the proof.

**Firefly / Express:** brush only room areas. Never brush across the product edge. Restore + verify afterwards.

**ChatGPT:** it redraws everything, and returns images in its own fixed set of sizes, which often won't match the original's (a 1672 × 941 original can't come back at that size). Prefer Photoshop or Firefly for room-only edits, and use ChatGPT when neither is available. Ask for "the same framing, same aspect ratio, same size", and run restore + verify on what comes back. If the size differs only by scaling, `restore --resize` brings it back. If it reframed (the sofa moved within the frame), restore can't line it up: redo the edit in Photoshop or Firefly, or start from the real product photo.

**A prompt for the room, written for high-end work:**
> Keep the sofa exactly as it is. Change only the room. Editorial interior photograph for a luxury furniture brand: soft overcast daylight from the windows on the left as the only light, no sun flare, no glowing edges, no LED strips. Real architecture with believable structure. Keep every object in front of the sofa exactly where it is. Restrained styling: one stack of books with plain spines, one ceramic. Muted, true-to-life colour, natural film tones. Full-frame camera, 35mm lens at f/8, eye level, verticals straight. Same framing, same aspect ratio, same size as the original.

## 5. Grain on the product

Strict lock (the default) leaves the product pixel-for-pixel identical, so even camera grain isn't added. In a grainy room, a perfectly clean product can look pasted in. `finish.py --protect MASK --grain-on-product` adds the same grain field to the product as the room got: colour, tone and shape stay put, and individual pixels move only by grain. Verify it with the same preset and seed: `product_lock.py verify ORIGINAL.png FINISHED.png --mask MASK.png --grain lifestyle --seed 7`. That rebuilds the exact grain field on the original and still demands a pixel-perfect match, so grain is allowed and nothing else is: a JPEG save or any other change still FAILs. Use it only when the maker agrees that grain counts as camera, not product, and say in the report which version was delivered.

## 6. What FAIL means

`verify` exits 1 and prints FAIL when any product pixel differs beyond the tolerance (default 0). A FAIL is binding: the image does not go out under Product lock. Usual causes:

| Cause | Fix |
|---|---|
| Forgot to restore after an AI edit | Run `restore`, then verify again |
| Saved the master as JPEG | Save as PNG; JPEG only for web exports |
| The tool resized or reframed | `restore --resize` for scaling only; otherwise redo the edit with the framing kept |
| Mask made from a different version of the image | Make the mask from the original, and keep the original as the reference |
| `--grain-on-product` used but verified without `--grain` | Verify again with `--grain PRESET --seed N` matching the finish run |
| The mask missed part of the product | Not caught by verify at all: widen `--hue` or fix the mask by hand, check the preview, rerun |
