# Image Humanizer: Fix Playbook

How to fix each layer. Prevention in the prompt is cheaper than retouching, and retouching is cheaper than reshooting, so start at the top.

---

## 1. Prompt language that prevents tells

### Describe a photo, not an image
Name the camera setup, the light, and the moment. Models copy the look of their training photos, so ask for the kind of photo you want.

**Before:**
> A beautiful modern sofa in a stunning luxury living room, photorealistic, 8k, ultra detailed

**After:**
> Editorial interior photograph of a three-seat sofa in oatmeal linen with a tight back and tapered walnut legs, in a living room with white oak floors. Soft north window light from the left, late morning. Shot on a full-frame camera, 35mm lens at f/5.6, eye level, verticals straight. Natural cushion compression, a wool throw folded over one arm, an open book on the coffee table.

Words like "stunning," "8k," "ultra detailed," "hyperrealistic," and "masterpiece" push the model toward the glossy AI look. Drop them.

### Building blocks

| Goal | Add |
|---|---|
| Real lens | "35mm lens at f/5.6" (rooms), "85mm at f/4" (detail), "50mm at f/8, eye level" (catalog) |
| One light source | "soft window light from the left," "overcast daylight," "single warm table lamp, dusk" |
| Straight lines | "verticals straight, architectural photography" |
| Lived-in | "slight cushion compression," "throw casually draped," "a coffee cup on the side table" |
| Material truth | name the material exactly: "slubby Belgian linen," "cognac aniline leather with natural creasing," "quarter-sawn white oak" |
| Less gloss | "matte," "natural film color," "muted palette," "true-to-life color" |

### Negative prompts (where the tool supports them)
`glossy, plastic, CGI, 3D render, oversaturated, HDR, perfect symmetry, floating, text, watermark, extra legs, distorted perspective`

### Use the real product
The best fix for product accuracy is to give the model the real product: a reference image (Midjourney `--cref`/image prompt, Firefly "Reference image," ChatGPT image upload, Flux image-to-image), or composite a real cut-out product photo into a generated room and only generate the room. For catalog and product pages, the composite route is the safest: the product pixels are real.

---

## 2. Retouch instructions by tool

Write retouch steps region by region, in the user's tool, with the exact inpaint prompt.

### Photoshop (Generative Fill)
1. Duplicate the background layer first (keeps the original).
2. Lasso the region with a little margin.
3. Generative Fill with a short, literal prompt: "tapered walnut sofa leg touching the floor," or leave blank to remove an object.
4. Pick the best of the three variations; repeat on a new selection rather than enlarging one huge one.
5. Contact shadows: new layer set to Multiply, soft black brush at 10–20% opacity under each foot.
6. Gibberish text: Remove Tool or Generative Fill with "plain linen book spine."
7. Verticals: Filter > Lens Correction or Edit > Perspective Warp.

### Adobe Firefly / Express
Same as Photoshop's Generative Fill: brush the area, describe what should be there in a few words. Use "Reference image" for the product.

### Canva
Magic Edit for small regions (brush, then describe). Magic Eraser for gibberish text and cloned decor. For larger structural problems, Canva is the wrong tool: regenerate.

### Lightroom
Not for structure. Use it for perspective (Geometry > Upright), color, and as an alternative to `finish.py` (Effects > Grain at 10–20, Vignetting −5 to −10, Dehaze slightly negative to tame HDR glow).

### No retouch tool
Regenerate with a revised prompt, crop the problem out if it's at the edge, then run `finish.py`.

---

## 3. When to stop and reshoot

Recommend a real photo instead of more AI passes when:
- The image is the primary product photo on a product detail page.
- The product is custom or made to order and the AI version keeps getting a defining detail wrong (arm style, leg finish, tufting pattern, fabric).
- Three regenerations haven't fixed a blocker.
- The image will be used in a paid ad where the product claim matters.

A useful middle path: photograph the real piece once on a plain background, then generate rooms around it. One real shoot can feed dozens of lifestyle images.

---

## 4. The finishing pass

Run last, after structure is fixed.

```bash
python3 scripts/finish.py room.png --preset lifestyle
python3 scripts/finish.py sofa-white-bg.jpg --preset product --grain 0.5
```

| Setting | product | lifestyle | What it does |
|---|---|---|---|
| `--grain` | 0.8 | 1.6 | Luminance grain strength, weighted to midtones and shadows |
| `--desat` | 0.10 | 0.15 | Pulls back saturation only where it is already high |
| `--rolloff` | 0.15 | 0.25 | Compresses the brightest highlights like a camera |
| `--vignette` | 0.06 | 0.14 | Darkens corners slightly |
| `--soften` | 0.4 | 0.7 | Lens-like softness toward the frame edges, center stays sharp |
| `--warmth` | 0.0 | 0.02 | Small shift toward warm |
| `--quality` | 90 | 88 | JPEG quality |

The script writes a new JPEG, keeps the original's EXIF, and adds an IPTC `DigitalSourceType` XMP tag (`compositeWithTrainedAlgorithmicMedia`) so the AI origin stays disclosed. Content Credentials (C2PA) on the original are not carried over, because any pixel edit invalidates them; keep the original file as the record.
