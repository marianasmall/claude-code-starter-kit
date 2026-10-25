#!/usr/bin/env python3
"""Finishing pass for AI-generated images: makes surfaces read like a camera photo.

Fixes surface tells only (waxy sheen, clean pixels, HDR glow, over-saturation,
no lens character). It cannot fix structure: wrong legs, floating furniture,
gibberish text. Fix those first.

Writes a new JPEG and never overwrites the input. Keeps the input's EXIF and
adds an IPTC DigitalSourceType XMP tag so the AI origin stays disclosed.

Needs Pillow and numpy:  pip install pillow numpy
"""
import argparse
import sys
from pathlib import Path

sys.dont_write_bytecode = True  # no .pyc files left in the skill folder

import numpy as np
from PIL import Image, ImageFilter, ImageOps, PngImagePlugin

PRESETS = {
    "product":   dict(grain=0.8, desat=0.10, rolloff=0.15, vignette=0.06, soften=0.4, warmth=0.0, quality=90),
    "lifestyle": dict(grain=1.6, desat=0.15, rolloff=0.25, vignette=0.14, soften=0.7, warmth=0.02, quality=88),
}

XMP_TEMPLATE = (
    '<?xpacket begin="﻿" id="W5M0MpCehiHzreSzNTczkc9d"?>'  # ﻿: the byte-order mark XMP requires
    '<x:xmpmeta xmlns:x="adobe:ns:meta/"><rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">'
    '<rdf:Description rdf:about="" xmlns:Iptc4xmpExt="http://iptc.org/std/Iptc4xmpExt/2008-02-29/">'
    '<Iptc4xmpExt:DigitalSourceType>'
    'http://cv.iptc.org/newscodes/digitalsourcetype/compositeWithTrainedAlgorithmicMedia'
    '</Iptc4xmpExt:DigitalSourceType>'
    '</rdf:Description></rdf:RDF></x:xmpmeta><?xpacket end="w"?>'
)


def luminance(rgb):
    return 0.2126 * rgb[..., 0] + 0.7152 * rgb[..., 1] + 0.0722 * rgb[..., 2]


def rolloff_highlights(rgb, amount):
    # Soft shoulder above the knee: bright values compress instead of clipping.
    if amount <= 0:
        return rgb
    knee = 1.0 - 0.35 * amount
    over = np.clip(rgb - knee, 0, None)
    span = 1.0 - knee
    compressed = knee + span * (1 - np.exp(-over / span * 1.5)) / (1 - np.exp(-1.5))
    rgb = np.where(rgb > knee, compressed, rgb)
    # Slight midtone S-curve to undo the flat, evenly lit HDR look.
    s = 0.15 * amount
    return rgb + s * (rgb - 0.5) * (1 - np.abs(2 * rgb - 1))


def reduce_saturation(rgb, amount):
    # Pull back only the colors that are already loud.
    if amount <= 0:
        return rgb
    lum = luminance(rgb)[..., None]
    sat = rgb.max(axis=-1, keepdims=True) - rgb.min(axis=-1, keepdims=True)
    weight = amount * np.clip((sat - 0.25) / 0.5, 0, 1)
    return rgb + (lum - rgb) * weight


def warm(rgb, amount):
    if amount == 0:
        return rgb
    return rgb * np.array([1 + amount, 1.0, 1 - amount])


def vignette(rgb, amount, h, w):
    if amount <= 0:
        return rgb, None
    y, x = np.ogrid[-1:1:complex(0, h), -1:1:complex(0, w)]
    r = np.sqrt(x * x + y * y) / np.sqrt(2)
    mask = r ** 2.2
    return rgb * (1 - amount * mask)[..., None], mask


def add_grain(rgb, amount, rng):
    # Luminance-only grain, strongest in midtones and shadows, slightly clumped.
    if amount <= 0:
        return rgb
    h, w, _ = rgb.shape
    noise = rng.normal(0, 1, (h, w)).astype(np.float32)
    clump = Image.fromarray(((noise * 32) + 128).clip(0, 255).astype(np.uint8)).filter(ImageFilter.GaussianBlur(0.6))
    noise = 0.6 * noise + 0.4 * (np.asarray(clump, dtype=np.float32) - 128) / 32
    lum = luminance(rgb)
    weight = 0.35 + 0.65 * (1 - np.abs(lum - 0.4) / 0.6).clip(0, 1)
    sigma = amount * 0.012
    return rgb + (noise * weight * sigma)[..., None]


def soften_edges(img, amount, mask):
    # Corners slightly softer than the center, like a real lens.
    if amount <= 0 or mask is None:
        return img
    blurred = img.filter(ImageFilter.GaussianBlur(radius=amount * max(img.size) / 1500))
    alpha = Image.fromarray((np.clip(mask * 1.4, 0, 1) * 255).astype(np.uint8))
    return Image.composite(blurred, img, alpha)


def protect_product(original, finished, args, settings, w, h):
    # Put the input's product pixels back, exactly, with a hard edge. The mask
    # is already grown a pixel or two past the product, which hides the seam;
    # feathering here would paste a ring of unfinished room around the product.
    sys.path.insert(0, str(Path(__file__).resolve().parent))
    from product_lock import load_mask
    mask = load_mask(args.protect, (w, h))
    orig = np.asarray(original, dtype=np.float32) / 255.0
    if args.grain_on_product:
        # Same seed, same shape: the identical grain field the room got.
        orig = add_grain(orig, settings["grain"], np.random.default_rng(args.seed))
    fin = np.asarray(finished, dtype=np.float32) / 255.0
    out = np.where(mask[..., None], orig, fin)
    print(f"Protected {mask.mean() * 100:.1f}% of the frame (product): "
          + ("grain only." if args.grain_on_product else "pixels identical to the input."))
    return Image.fromarray((np.clip(out, 0, 1) * 255 + 0.5).astype(np.uint8))


def main():
    p = argparse.ArgumentParser(description="Finishing pass that makes AI images read like camera photos.")
    p.add_argument("input")
    p.add_argument("--preset", choices=PRESETS, default="product")
    p.add_argument("--out", help="output path (default: INPUT_humanized.jpg)")
    for key in ("grain", "desat", "rolloff", "vignette", "soften", "warmth"):
        p.add_argument(f"--{key}", type=float, help=f"override the preset's {key}")
    p.add_argument("--quality", type=int, help="JPEG quality")
    p.add_argument("--seed", type=int, default=7, help="grain seed, for repeatable output")
    p.add_argument("--protect", metavar="MASK",
                   help="product mask (white = product, from product_lock.py mask): those pixels stay "
                        "identical to the input. Output defaults to PNG so they stay exact.")
    p.add_argument("--grain-on-product", action="store_true",
                   help="with --protect: add the same camera grain to the product so it doesn't look "
                        "pasted in. Colour, tone and shape stay untouched; pixels change by grain only.")
    args = p.parse_args()

    settings = dict(PRESETS[args.preset])
    for key in settings:
        if getattr(args, key) is not None:
            settings[key] = getattr(args, key)

    src = Path(args.input)
    if args.grain_on_product and not args.protect:
        sys.exit("--grain-on-product only means something with --protect MASK.")
    ext = "png" if args.protect else "jpg"
    out = Path(args.out) if args.out else src.with_name(f"{src.stem}_humanized.{ext}")
    if out.resolve() == src.resolve():
        sys.exit("Refusing to overwrite the input. Pass a different --out.")
    if out.exists():
        sys.exit(f"{out} already exists. Pass a different --out, or move the old file first.")

    # exif_transpose also drops the Orientation tag, so the kept EXIF won't rotate twice.
    upright = ImageOps.exif_transpose(Image.open(src))
    exif = upright.getexif()
    img = upright.convert("RGB")
    w, h = img.size

    rgb = np.asarray(img, dtype=np.float32) / 255.0
    rgb = rolloff_highlights(rgb, settings["rolloff"])
    rgb = reduce_saturation(rgb, settings["desat"])
    rgb = warm(rgb, settings["warmth"])
    rgb, mask = vignette(rgb, settings["vignette"], h, w)
    result = Image.fromarray((np.clip(rgb, 0, 1) * 255 + 0.5).astype(np.uint8))
    result = soften_edges(result, settings["soften"], mask)

    rng = np.random.default_rng(args.seed)
    rgb = add_grain(np.asarray(result, dtype=np.float32) / 255.0, settings["grain"], rng)
    result = Image.fromarray((np.clip(rgb, 0, 1) * 255 + 0.5).astype(np.uint8))

    if args.protect:
        result = protect_product(img, result, args, settings, w, h)

    if out.suffix.lower() == ".png":
        info = PngImagePlugin.PngInfo()
        info.add_itxt("XML:com.adobe.xmp", XMP_TEMPLATE)
        save = dict(pnginfo=info)
        if len(exif):
            save["exif"] = exif.tobytes()
        result.save(out, "PNG", **save)
    else:
        if args.protect:
            print("Note: JPEG re-encoding shifts protected pixels slightly. Keep a PNG master; "
                  "export the JPEG from it for the web.")
        save = dict(quality=settings["quality"], subsampling=0, optimize=True, xmp=XMP_TEMPLATE.encode("utf-8"))
        if len(exif):
            save["exif"] = exif.tobytes()
        result.save(out, "JPEG", **save)

    print(f"Wrote {out}")
    print("Settings: " + ", ".join(f"{k}={v}" for k, v in settings.items()))
    print("Original untouched. Look at the result at 100% before using it.")


if __name__ == "__main__":
    main()
