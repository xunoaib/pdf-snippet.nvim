import argparse
import os
from pathlib import Path

from pdf2image import convert_from_path
from PIL import Image, ImageDraw, ImageFont


def pdf_page_to_image(
    pdf_path: str | Path,
    page_num: int,
    output_path: str | Path,
    dpi: int = 200,
    scale: float = 0.5,
    font_path: str = 'DejaVuSans.ttf',
    font_size: int = 20,
):
    '''
    Convert a specific PDF page into a smaller image with text annotation.
    '''

    pages = convert_from_path(
        pdf_path, first_page=page_num, last_page=page_num, dpi=dpi
    )
    image = pages[0].convert('RGBA')

    if scale != 1.0:
        image = image.resize(
            (int(image.width * scale), int(image.height * scale)),
            Image.LANCZOS
        )

    pdf_name = os.path.basename(pdf_path)
    text = f'{pdf_name} - Page {page_num}'

    draw = ImageDraw.Draw(image)
    try:
        font = ImageFont.truetype(font_path, font_size)
    except Exception:
        font = ImageFont.load_default(font_size)

    bbox = draw.textbbox((0, 0), text, font=font)
    text_w, text_h = bbox[2] - bbox[0], bbox[3] - bbox[1]

    margin = 10
    x = image.width - text_w - margin
    y = image.height - text_h - margin

    draw.rectangle(
        [(x - 5, y - 5), (x + text_w + 5, y + text_h + 5)],
        fill=(200, 200, 200, 255)
    )

    draw.text((x, y), text, font=font, fill='black')

    image.save(output_path, 'PNG')


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('pdf', help='Path to PDF file')
    parser.add_argument('page', type=int, help='1-based page number')
    parser.add_argument(
        '--outdir',
        type=Path,
        default=Path('.'),
        help='Output directory for PNG (default: current directory)'
    )
    parser.add_argument(
        '--label',
        type=str,
        default=None,
        help='Custom link text for the markdown image (default: PDF file name)'
    )
    args = parser.parse_args()

    pdf_input = Path(args.pdf)
    page = args.page

    args.outdir.mkdir(parents=True, exist_ok=True)

    # assert args.outdir.exists(
    # ), f'Output directory doesn't exist! {args.outdir}'

    png_output = Path(args.outdir) / (pdf_input.stem + f'_page_{page}.png')

    pdf_page_to_image(pdf_input, page, png_output)

    # Print path relative to output directory (fragile)
    out = png_output.parent.name + '/' + png_output.name

    label = args.label if args.label else pdf_input.name

    print(f'![{label} - Page {page}]({out})')


if __name__ == '__main__':
    main()
