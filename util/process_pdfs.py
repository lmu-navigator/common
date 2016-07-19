#!/usr/bin/env python
"""
For all pdf files in a directory, this script does the following:
 - Convert pdf file to a png image
 - Create a sample image
 - Create image tiles

You can pass the directory containing the pdf files as command line 
argument, otherwise the current working directory is used.

In the specified directory, subdirectories "png", "samples" and "tiles"
will be created for the output images.

Requires:
 - Python Wand (http://www.wand-py.org/)
 - ImageMagick (http://www.imagemagick.org/)
 - Ghostscript (http://www.ghostscript.com/)
"""

from wand.image import Image
import sys
import os
import subprocess

SAMPLE_SIZE = 500
TILE_SIZE = 256

DPI_450 = ["0203", "0607", "0800", "2102", "2957", "2959", "2971", "2974", "2980", "4925"]
DPI_600 = ["0820", "1001", "2963", "3200", "7070"]

def create_tiles(img, path):
    os.makedirs(path)
    col = 0

    for w in range(0, img.width, TILE_SIZE):
        col_path = os.path.join(path, str(col))
        os.makedirs(col_path)
        w_end = min(w + TILE_SIZE, img.width)
        col += 1
        row = 0

        for h in range(0, img.height, TILE_SIZE):
            h_end = min(h + TILE_SIZE, img.height)
            with img[w:w_end, h:h_end] as tile:
                tile.save(filename=os.path.join(col_path, str(row) + ".png"))
            row += 1


path = os.getcwd()
if len(sys.argv) > 1:
    path = sys.argv[1]
    if not os.path.exists(path):
        raise ValueError("Path %s does not exist!" % path)

png_path = os.path.join(path, "png")
sample_path = os.path.join(path, "samples")
tile_path = os.path.join(path, "tiles")
os.makedirs(png_path, exist_ok=True)
os.makedirs(sample_path, exist_ok=True)
os.makedirs(tile_path, exist_ok=True)

pdf_files = [f for f in os.listdir(path) if os.path.isfile(os.path.join(path, f)) and f.endswith(".pdf")]

count = 0
for f in pdf_files:
    count += 1
    basename = f.replace(".pdf", "")
    print("(%d/%d) %s" % (count, len(pdf_files), f))

    pdf = os.path.join(path, f)
    png = os.path.join(png_path, basename + ".png")

    # Convert pdf file to png image
    dpi = 300
    if basename.split("_")[0] in DPI_450:
        dpi = 450
    if basename.split("_")[0] in DPI_600:
        dpi = 600
    subprocess.run(["gs", "-sDEVICE=pnggray", "-dTextAlphaBits=4", "-r" + str(dpi), "-o", png, pdf],
                   stdout=subprocess.DEVNULL)

    with Image(filename=png) as img:

        # Create sample image
        with img.clone() as sample:
            sample.transform(resize="%dx%d" % (SAMPLE_SIZE, SAMPLE_SIZE))
            sample.save(filename=os.path.join(sample_path, basename + ".png"))

        # Create tiles
        tile_base_path = os.path.join(tile_path, basename)
        os.makedirs(tile_base_path)

        with img.clone() as small:
            small.transform(resize="12.5%")
            create_tiles(small, os.path.join(tile_base_path, "125"))

        with img.clone() as medium:
            medium.transform(resize="25%")
            create_tiles(medium, os.path.join(tile_base_path, "250"))

        with img.clone() as large:
            large.transform(resize="50%")
            create_tiles(large, os.path.join(tile_base_path, "500"))

        create_tiles(img, os.path.join(tile_base_path, "1000"))

print("\nDONE!")
