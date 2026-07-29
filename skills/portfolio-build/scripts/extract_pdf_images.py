#!/usr/bin/env python3
"""Extract usable images from a PDF portfolio/resume into an assets dir.

Deterministic helper for the portfolio-build skill (Step 2, PDF input): pulls
raster figures — architecture diagrams, dashboard screenshots — out of a PDF so
the deck references real images instead of empty placeholders. Selecting *which*
figures to use is left to the agent; this just dumps the raw material.

Usage:
  python extract_pdf_images.py INPUT.pdf OUT_DIR [--min 240] [--render-pages] [--dpi 144]

- Embedded images smaller than --min px on either side are skipped (icons/badges).
- --render-pages also renders each full page to PNG, for manual cropping when
  figures are vector/flattened rather than embedded rasters.

Requires PyMuPDF:  pip install pymupdf
Prints each written path to stdout; a one-line summary to stderr.
"""
import argparse
import os
import sys


def main() -> int:
    ap = argparse.ArgumentParser(description="Extract images from a PDF into OUT_DIR.")
    ap.add_argument("pdf")
    ap.add_argument("out_dir")
    ap.add_argument("--min", type=int, default=240, help="skip images smaller than this on either side (px)")
    ap.add_argument("--render-pages", action="store_true", help="also render each full page to PNG")
    ap.add_argument("--dpi", type=int, default=144, help="DPI for --render-pages")
    args = ap.parse_args()

    try:
        import fitz  # PyMuPDF
    except ImportError:
        print("PyMuPDF가 필요합니다:  pip install pymupdf", file=sys.stderr)
        return 2

    if not os.path.isfile(args.pdf):
        print(f"파일 없음: {args.pdf}", file=sys.stderr)
        return 1
    os.makedirs(args.out_dir, exist_ok=True)

    doc = fitz.open(args.pdf)
    seen: set[int] = set()
    n_img = 0
    n_page = 0
    for pno in range(len(doc)):
        page = doc[pno]
        for img in page.get_images(full=True):
            xref = img[0]
            if xref in seen:
                continue
            seen.add(xref)
            try:
                pix = fitz.Pixmap(doc, xref)
            except Exception:
                continue
            if pix.width < args.min or pix.height < args.min:
                pix = None
                continue
            if pix.n - pix.alpha >= 4:  # CMYK / other -> RGB
                pix = fitz.Pixmap(fitz.csRGB, pix)
            out = os.path.join(args.out_dir, f"pdf-p{pno + 1:02d}-img{xref}.png")
            pix.save(out)
            n_img += 1
            print(out)
            pix = None
        if args.render_pages:
            pix = page.get_pixmap(dpi=args.dpi)
            out = os.path.join(args.out_dir, f"pdf-p{pno + 1:02d}-page.png")
            pix.save(out)
            n_page += 1
            print(out)
            pix = None
    doc.close()
    print(f"# {n_img} embedded image(s), {n_page} page render(s) -> {args.out_dir}", file=sys.stderr)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
