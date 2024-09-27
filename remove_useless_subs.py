"""
Script to remove lines matching an expression from srt files. Useful for lines
like [Speaks language] that interfere with burned in subtitles in that language
"""

import sys
import re

if len(sys.argv) != 3:
    print("USAGE: python remove_useless_subs.py <filename> <regex>")
    exit(1)

with open(sys.argv[1], "r") as f:
    while (id_num := f.readline()) != "":
        time = f.readline()
        lines: list[str] = []
        while (l := f.readline()) != "\n" and l != "":
            lines.append(l)
        if any(re.search(sys.argv[2], l) for l in lines):
            continue
        print(f"{id_num}{time}{''.join(lines)}")
