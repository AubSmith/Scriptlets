Open in HEX editor

Header 14 bytes:
424d = BM for bitmap
8E26 2C00 = File size
0000 0000 = Reserved
BAD0 0000 = DataOffset
Infoheader 40 Bytes:
BAD0 0000 = Size (4 Bytes)
6E04 0000 = Width (4 Bytes)
3201 0000 = Height (4 Bytes) - change to 3203 0000
Planes (2 Bytes)
Bits Per Pixel (2 Bytes)
Compression (4 Bytes)
ImageSize (4 Bytes)
XpixelsPerM (4 Bytes)
YpixelsPerM (4 Bytes)
Colors Used (4 Bytes)
Important Colors (4 Bytes)



File size = 2893454 bytes
Header = 54 bytes
Body = 2893400 bytes
Bits_per_byte = 24 therefor 2893400 / 3 =~ 964466 pixels
W 1134 * H 306 = 347004 pixels
964466 / 1134 =~850