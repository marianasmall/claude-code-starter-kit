# Image Humanizer: The Tells in Detail

What to look for, why AI image models get it wrong, and the fix layer for each. Grouped by where you'll find them. Furniture and interiors first, because that is where this skill is used most.

Fix layers: **Regenerate** (new prompt or new seed), **Retouch** (inpaint, clone, or mask one region), **Finish** (whole-image pass with `scripts/finish.py`).

Contents: A. Upholstered furniture · B. Wood, stone, metal, glass · C. Light and physics · D. Scene and styling · E. Surface tells

> **Under Product lock, sections A and B are diagnosis only.** Their fixes regenerate or retouch the product, which Product lock forbids. Record the tell, mark it "Locked: confirm with the maker", and don't retouch it. If the maker says the real piece doesn't look like that, the verdict is reshoot the product (`product-lock.md` §2). Sections C–E still apply, to the room only.

---

## A. Upholstered furniture

### A1. Legs
**Look for:** five legs on a sofa, a leg growing out of a cushion, legs of different styles or heights on the same piece, legs that stop above the floor or sink into it, a back leg visible where the geometry says it should be hidden.
**Why:** models draw "furniture-shaped" texture, not a frame with four corners.
**Fix:** Regenerate if the frame is wrong. Retouch if one leg is off: mask the leg and its floor contact, inpaint with "tapered walnut leg, same as front left leg, touching the floor with soft contact shadow."

### A2. Arms, back, and frame joins
**Look for:** one arm rolled and the other track; arms that melt into the seat; a back that fades into the wall; a frame edge that turns into fabric with no seam.
**Fix:** Regenerate. These are almost never clean to retouch.

### A3. Seams, welting, and stitching
**Look for:** piping that wanders, doubles, or vanishes halfway along a cushion; topstitching that turns into texture; seams that don't match left to right.
**Why:** the model has seen seams, not sewn them. It doesn't know a seam has to go somewhere.
**Fix:** Retouch short runs (clone a good section along the path). Regenerate if seams are wrong across the piece. For a product page, a wrong seam line is a product-accuracy issue.

### A4. Tufting and buttons
**Look for:** uneven spacing, buttons that sit on top of the fabric with no dimple, diamond pleats that don't connect, tufting that changes density across the back.
**Fix:** Regenerate for the main view; retouch a few stray buttons.

### A5. Cushions
**Look for:** every cushion identically overstuffed with no compression, cushions merging into each other or the arm, seat cushion count changing between views of the same piece.
**Fix:** Prompt for "slight natural cushion compression, lived-in" (see playbook). Retouch merges.

### A6. Fabric
**Look for:** a plastic or rubbery sheen on linen, bouclé that reads as foam, velvet with no nap direction, a pattern that changes scale or direction from cushion to cushion or warps around a curve, a pattern that doesn't match at seams in a way a real upholsterer would match it.
**Fix:** Sheen and lack of texture: Finish (texture recovery and grain) after a retouch. Pattern drift: Regenerate, or composite a real fabric swatch with a displacement map in Photoshop. If the fabric is a specific SKU, the swatch must be the real one.

---

## B. Wood, stone, metal, glass

### B1. Wood grain
**Look for:** mirrored grain (a Rorschach blot down the middle of a tabletop), grain that runs across a leg instead of along it, a repeating tile, smeared or blurry grain next to sharp edges.
**Fix:** Retouch with a real wood texture, or Regenerate with the species and cut named ("quarter-sawn white oak").

### B2. Stone and marble
**Look for:** veining that loops back on itself or stops dead at an edge; the same vein pattern on two surfaces.
**Fix:** Retouch with a real slab texture.

### B3. Hardware
**Look for:** nailheads that change size or spacing, casters that melt into the leg, drawer pulls that don't match, screws with no slot.
**Fix:** Retouch (clone one good nailhead along the line, keep spacing even).

### B4. Glass and mirrors
**Look for:** reflections that don't show the room, show a different room, or show the camera at the wrong angle; glass with no edge thickness.
**Fix:** Retouch or remove the reflective object.

---

## C. Light and physics

### C1. Inconsistent light
**Look for:** shadows that fall different ways for different objects, a bright window with no matching light pool on the floor, a lamp that's on but lights nothing.
**Why:** the model blends lighting from many training photos.
**Fix:** Regenerate with one named light source ("soft north window light from the left, late morning"). Small fixes: dodge and burn.

### C2. Floating furniture
**Look for:** no contact shadow where legs or a plinth meet the floor. The piece looks pasted in.
**Fix:** Retouch: paint a soft, dark contact shadow at each foot (low opacity, multiply), plus a broader ambient occlusion shadow under the piece.

### C3. Perspective and scale
**Look for:** door frames and walls that bow or lean, a sofa wider than the room could hold, outlets at knee height on a sofa that comes up to them, a coffee table the size of a dining table.
**Fix:** Lens/perspective correction in Lightroom or Photoshop for leaning verticals. Wrong scale: Regenerate.

### C4. Impossible depth of field
**Look for:** everything razor-sharp from front to back in a dim room, or blur that cuts out around the product like a cutout instead of falling off with distance.
**Fix:** Prompt for a real lens and aperture. Finish adds slight lens softness toward the edges.

---

## D. Scene and styling

### D1. Gibberish text
**Look for:** book spines, magazines, art prints, packaging, signage. AI text is the fastest tell there is.
**Fix:** Retouch: replace with real titles, blank spines, or remove the object.

### D2. Plants and flowers
**Look for:** fused stems, leaves growing from nowhere, a plant that is half fiddle-leaf fig and half monstera.
**Fix:** Retouch, or replace with a real photographed plant.

### D3. Cloned decor
**Look for:** the same vase, pillow, or frame in two places; a repeating pattern of objects on a shelf.
**Fix:** Retouch one instance out.

### D4. Too perfect
**Look for:** a showroom with no life. Every pillow at the same angle, nothing on the table, a rug with no foot traffic, perfect symmetry.
**Why:** this is the most common "something's off" tell and the hardest to name.
**Fix:** Prompt for small human disorder (see playbook). Don't overdo it on product pages; a clean catalog shot is fine if the physics are right.

### D5. Windows and views
**Look for:** a view that doesn't match the light in the room, a skyline through a ground-floor window, a garden that turns into fog.
**Fix:** Retouch the view, or soften it to a believable overexposed window.

### D6. People and hands
**Look for:** hands, fingers, a foot resting on nothing, a face too smooth, two people with the same face.
**Fix:** Regenerate, or crop the person out. Hands are rarely worth retouching.

---

## E. Surface tells (the finishing pass)

These are the ones `scripts/finish.py` handles. Fix structure first; finishing an image with a melted arm just gives you a nicely graded melted arm.

| Tell | What it looks like | What the pass does |
|---|---|---|
| Waxy, plastic surfaces | Fabric and skin look airbrushed | Adds fine luminance grain; slight edge softness |
| Clean digital pixels | No noise anywhere, even in shadows | Grain weighted toward midtones and shadows, like a sensor |
| HDR glow | Highlights glow, everything evenly lit | Gentle highlight roll-off and a slight midtone contrast curve |
| Over-saturation | Candy colors, especially greens and blues | Saturation pulled back only where it's already high |
| No lens character | Corners as bright and sharp as the center | Subtle vignette and corner softness |
| Perfect edges | Hard cutout edges between objects | Small, uneven softness toward the frame edges |

The pass is deliberately subtle. If a viewer can see the grain on a product page, it's too strong.
