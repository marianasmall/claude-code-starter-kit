#!/usr/bin/env python3
"""Product lock: keep the real product pixels identical through any edit.

When the maker's product is in the image, "don't change the sofa" cannot be a
request to an AI editor. ChatGPT, Firefly and Midjourney redraw the whole frame
on every edit, so the product drifts a little each time. This script makes the
guarantee mechanical:

  mask     build a product mask (white = product) from a colour key and/or a box
  restore  paste the original product pixels back on top of an edited image
  verify   measure how much the product changed between two images: PASS / FAIL

Typical flow:
  python3 product_lock.py mask ORIGINAL.png --hue 170-200 --box 360,500,1440,800
  # ...edit the room in any tool, or run finish.py --protect MASK...
  python3 product_lock.py restore ORIGINAL.png EDITED.jpg --mask ORIGINAL_mask.png
  python3 product_lock.py verify ORIGINAL.png EDITED_locked.png --mask ORIGINAL_mask.png

Always check the mask by eye (the script writes a preview). A colour key is a
starting point; fix the edges in Photoshop (Select Subject) or any paint tool
if it misses part of the product or grabs part of the room.

Never overwrites an input. Needs Pillow and numpy:  pip install pillow numpy
"""
import argparse
import colorsys
import sys
from pathlib import Path

sys.dont_write_bytecode = True  # no .pyc files left in the skill folder

import numpy as np
from PIL import Image, ImageDraw, ImageFilter, ImageOps

# A product pixel may differ by this much (0-255) after a lossless round trip.
# 0 for PNG. JPEG re-encoding moves pixels a little, which is why restore
# writes PNG by default.
DEFAULT_TOLERANCE = 0


def load_rgb(path):
    return np.asarray(ImageOps.exif_transpose(Image.open(path)).convert("RGB"), dtype=np.int16)


def load_mask_image(path, size):
    # White = product. A mask exported as white-on-transparent carries the
    # shape in its alpha, not its grey values, so read the alpha when it varies.
    src = Image.open(path)
    if src.size != size:
        sys.exit(f"Mask is {src.size[0]}x{src.size[1]} but the image is {size[0]}x{size[1]}. Make the mask from this image.")
    if "A" in src.getbands() or "transparency" in src.info:
        alpha = src.convert("RGBA").getchannel("A")
        lo, hi = alpha.getextrema()
        if lo != hi:
            grey = np.asarray(src.convert("L"), dtype=np.uint8)
            a_arr = np.asarray(alpha, dtype=np.uint8)
            return Image.fromarray(np.where(a_arr >= 128, grey, 0).astype(np.uint8))
    return src.convert("L")


def load_mask(path, size):
    mask = np.asarray(load_mask_image(path, size), dtype=np.uint8) >= 128
    share = 100 * float(mask.mean())
    if share > 50 or share < 0.5:
        print(f"WARNING: the mask covers {share:.1f}% of the frame. A product usually covers 2-40%. "
              "Check the mask is white on black (white = product) and made from this image.")
    return mask


def safe_out(path, inputs):
    out = Path(path)
    for i in inputs:
        if out.resolve() == Path(i).resolve():
            sys.exit("Refusing to overwrite an input. Pass a different --out.")
    if out.exists():
        sys.exit(f"{out} already exists. Pass a different --out, or move the old file first.")
    return out


def fill_enclosed_holes(m):
    # Any non-product pixel the outside can't reach is a hole in the product
    # (a dark fold, a shadowed button): make it product.
    w, h = m.size
    padded = Image.new("L", (w + 2, h + 2), 0)
    padded.paste(m, (1, 1))
    ImageDraw.floodfill(padded, (0, 0), 128)
    arr = np.asarray(padded, dtype=np.uint8)[1:-1, 1:-1]
    return Image.fromarray(np.where(arr == 128, 0, 255).astype(np.uint8))


def cmd_mask(a):
    # Same orientation as restore and verify see it, or the mask lands on the wrong pixels.
    img = ImageOps.exif_transpose(Image.open(a.image)).convert("RGB")
    w, h = img.size
    rgb = np.asarray(img, dtype=np.float32) / 255.0
    keep = np.ones((h, w), dtype=bool)

    if a.hue:
        lo, hi = (float(x) for x in a.hue.split("-"))
        hsv = np.asarray(img.convert("HSV"), dtype=np.float32)
        hue = hsv[..., 0] * 360 / 255
        sat = hsv[..., 1] / 255
        val = hsv[..., 2] / 255
        in_hue = (hue >= lo) & (hue <= hi) if lo <= hi else (hue >= lo) | (hue <= hi)
        keep &= in_hue & (sat >= a.min_sat) & (val >= a.min_val)

    if a.box:
        x0, y0, x1, y1 = (int(v) for v in a.box.split(","))
        boxed = np.zeros_like(keep)
        boxed[max(0, y0):min(h, y1), max(0, x0):min(w, x1)] = True
        keep &= boxed

    if not a.hue and not a.box:
        sys.exit("Give --hue, --box, or both.")

    m = Image.fromarray((keep * 255).astype(np.uint8))
    # Close small holes (shadowed folds, pile highlights), then drop specks.
    if a.close > 0:
        k = a.close * 2 + 1
        m = m.filter(ImageFilter.MaxFilter(k)).filter(ImageFilter.MinFilter(k))
    m = m.point(lambda v: 255 if v >= 128 else 0)
    if a.despeck > 0:
        # Drop stray specks (a teal-ish pixel in a bowl) that would otherwise
        # stay frozen in place when the room around them is regenerated.
        k = a.despeck * 2 + 1
        m = m.filter(ImageFilter.MinFilter(k)).filter(ImageFilter.MaxFilter(k))
    if a.fill_holes:
        m = fill_enclosed_holes(m)
    if a.grow > 0:
        m = m.filter(ImageFilter.MaxFilter(a.grow * 2 + 1))

    src = Path(a.image)
    out = safe_out(a.out or src.with_name(f"{src.stem}_mask.png"), [a.image])
    m.save(out)

    # Preview: product kept in full colour, everything else dimmed and tinted.
    marr = np.asarray(m, dtype=np.float32)[..., None] / 255
    dim = rgb * 0.25 + np.array([0.35, 0.0, 0.35]) * 0.4
    prev = Image.fromarray(((rgb * marr + dim * (1 - marr)) * 255).clip(0, 255).astype(np.uint8))
    prev_path = out.with_name(f"{out.stem}_preview.jpg")
    if not prev_path.exists():
        prev.save(prev_path, quality=88)

    share = float(marr.mean()) * 100
    print(f"Wrote {out} ({share:.1f}% of the frame is product)")
    print(f"Preview {prev_path}: check that the whole product is bright and nothing else is.")


def cmd_restore(a):
    orig = load_rgb(a.original)
    edit_img = ImageOps.exif_transpose(Image.open(a.edited)).convert("RGB")
    h, w = orig.shape[:2]
    if edit_img.size != (w, h):
        if not a.resize:
            sys.exit(f"Edited image is {edit_img.size[0]}x{edit_img.size[1]}, original is {w}x{h}. "
                     "If the tool only resized it, rerun with --resize. If it cropped or reframed, "
                     "the product cannot be restored: redo the edit at the original framing.")
        edit_img = edit_img.resize((w, h), Image.LANCZOS)
    edit = np.asarray(edit_img, dtype=np.int16)
    mask = load_mask(a.mask, (w, h))

    out_arr = edit.copy()
    out_arr[mask] = orig[mask]
    if a.feather > 0:
        # Blend only the outside edge, so product pixels stay exact. This brings
        # back a thin ring of the ORIGINAL room, which can halo on a regenerated
        # room; off by default.
        soft = Image.fromarray((mask * 255).astype(np.uint8)).filter(ImageFilter.MaxFilter(a.feather * 2 + 1))
        soft = np.asarray(soft.filter(ImageFilter.GaussianBlur(a.feather)), dtype=np.float32) / 255
        ring = (~mask) & (soft > 0)
        alpha = soft[ring][:, None]
        out_arr[ring] = (orig[ring] * alpha + edit[ring] * (1 - alpha)).round().astype(np.int16)

    ed = Path(a.edited)
    out = safe_out(a.out or ed.with_name(f"{ed.stem}_locked.png"), [a.original, a.edited])
    res = Image.fromarray(out_arr.clip(0, 255).astype(np.uint8))
    if out.suffix.lower() in (".jpg", ".jpeg"):
        print("Note: JPEG re-encoding shifts product pixels slightly. Use PNG for the master file.")
        res.save(out, quality=95, subsampling=0)
    else:
        res.save(out)
    print(f"Wrote {out}: original product pixels restored.")
    report(orig, np.asarray(Image.open(out).convert("RGB"), dtype=np.int16), mask, a.tolerance)


def report(orig, other, mask, tol, reference_note=""):
    print(f"Mask covers {100 * float(mask.mean()):.1f}% of the frame. PASS only covers what the mask covers: "
          "anything of the product outside it (a missed pillow) can change unseen, so check the preview.")
    diff = np.abs(orig - other).max(axis=-1)
    inside = diff[mask]
    changed = int((inside > tol).sum())
    pct = 100 * changed / max(1, inside.size)
    worst = int(inside.max()) if inside.size else 0
    outside = diff[~mask]
    room = 100 * float((outside > 2).mean()) if outside.size else 0.0
    verdict = "PASS" if changed == 0 else "FAIL"
    print(f"{verdict}: product pixels changed {changed:,} of {inside.size:,} ({pct:.3f}%), "
          f"largest change {worst}/255, tolerance {tol}{reference_note}.")
    # Grain moves pixels up and down but should not move the average colour.
    shift = (other[mask].astype(np.float32) - orig[mask]).mean(axis=0) if inside.size else np.zeros(3)
    print("Product average colour shift (R, G, B): " + ", ".join(f"{s:+.2f}" for s in shift)
          + "  (beyond ±1.0 = the product's colour drifted; compare by eye against the swatch)")
    print(f"Room (outside the mask): {room:.1f}% of pixels changed.")
    if outside.size and room == 0.0:
        print("WARNING: nothing outside the mask changed either. Is the candidate just the original?")
    return verdict


def cmd_verify(a):
    orig = load_rgb(a.original)
    other = load_rgb(a.candidate)
    h, w = orig.shape[:2]
    if other.shape[:2] != (h, w):
        sys.exit(f"FAIL: sizes differ ({other.shape[1]}x{other.shape[0]} vs {w}x{h}). Restore first.")
    mask = load_mask(a.mask, (w, h))
    note = ""
    if a.grain is not None:
        # The product was given finish.py's camera grain on purpose. Rebuild
        # that exact grain field on the original and demand an exact match, so
        # grain is allowed and nothing else is.
        sys.path.insert(0, str(Path(__file__).resolve().parent))
        from finish import PRESETS, add_grain
        amount = PRESETS[a.grain]["grain"] if a.grain in PRESETS else float(a.grain)
        base = orig.astype(np.float32) / 255.0
        grained = add_grain(base, amount, np.random.default_rng(a.seed))
        orig = (np.clip(grained, 0, 1) * 255 + 0.5).astype(np.int16)
        note = f", against the original plus finish.py grain {amount} (seed {a.seed})"
    verdict = report(orig, other, mask, a.tolerance, note)
    sys.exit(0 if verdict == "PASS" else 1)


def main():
    p = argparse.ArgumentParser(description="Keep product pixels identical through any edit.")
    sub = p.add_subparsers(dest="cmd", required=True)

    m = sub.add_parser("mask", help="build a product mask from a colour key and/or a box")
    m.add_argument("image")
    m.add_argument("--hue", help="hue range in degrees, e.g. 170-200 for teal (wraps: 340-20 for red)")
    m.add_argument("--min-sat", type=float, default=0.20, help="minimum saturation 0-1 (default 0.20)")
    m.add_argument("--min-val", type=float, default=0.05, help="minimum brightness 0-1 (default 0.05)")
    m.add_argument("--box", help="x0,y0,x1,y1 in pixels: only keep pixels inside this box")
    m.add_argument("--close", type=int, default=1, help="smooth gaps up to this radius in px (default 1)")
    m.add_argument("--despeck", type=int, default=2, help="remove specks smaller than about this radius in px (default 2)")
    m.add_argument("--no-fill-holes", dest="fill_holes", action="store_false",
                   help="keep holes fully enclosed by the product (default: fill them)")
    m.add_argument("--grow", type=int, default=1, help="grow the mask by this many px (default 1)")
    m.add_argument("--out")
    m.set_defaults(fn=cmd_mask)

    r = sub.add_parser("restore", help="paste original product pixels onto an edited image")
    r.add_argument("original")
    r.add_argument("edited")
    r.add_argument("--mask", required=True)
    r.add_argument("--resize", action="store_true", help="allow a same-framing resize back to the original size")
    r.add_argument("--feather", type=int, default=0,
                   help="blend width outside the mask edge in px (default 0; >0 brings back a ring of the original room)")
    r.add_argument("--tolerance", type=int, default=DEFAULT_TOLERANCE)
    r.add_argument("--out", help="default: EDITED_locked.png")
    r.set_defaults(fn=cmd_restore)

    v = sub.add_parser("verify", help="PASS/FAIL: did the product change?")
    v.add_argument("original")
    v.add_argument("candidate")
    v.add_argument("--mask", required=True)
    v.add_argument("--tolerance", type=int, default=DEFAULT_TOLERANCE,
                   help="per-channel difference allowed, 0-255 (default 0; use 0 for PNG)")
    v.add_argument("--grain", metavar="PRESET_OR_AMOUNT",
                   help="the candidate was made with finish.py --grain-on-product: rebuild that grain "
                        "(preset name or --grain amount) and require an exact match")
    v.add_argument("--seed", type=int, default=7, help="the --seed finish.py used (default 7)")
    v.set_defaults(fn=cmd_verify)

    a = p.parse_args()
    a.fn(a)


if __name__ == "__main__":
    main()
