#!/usr/bin/env python
import sys
import re

if len(sys.argv) != 2:
    print("USAGE: srt-to-ass.py <srt file>")
    exit(1)

print("""[Script Info]
ScriptType: v4.00+
PlayResX: 384
PlayResY: 288
ScaledBorderAndShadow: yes

[V4+ Styles]
Format: Name, Fontname, Fontsize, PrimaryColour, SecondaryColour, OutlineColour, BackColour, Bold, Italic, Underline, StrikeOut, ScaleX, ScaleY, Spacing, Angle, BorderStyle, Outline, Shadow, Alignment, MarginL, MarginR, MarginV, Encoding
Style: Default,Arial,25,&Hffffff,&Hffffff,&H0,&H0,0,0,0,0,100,100,0,0,1,1,0,2,10,10,10,0

[Events]
Format: Layer, Start, End, Style, Name, MarginL, MarginR, MarginV, Effect, Text""")
with open(sys.argv[1]) as f:
    while True:
        try:
            _ = f.readline()
            times = f.readline()
            numbers = re.findall(r"\d+", times)
            hms_l = numbers[:3]
            hundreths_l = int(numbers[3]) // 10
            hms_r = numbers[4:7]
            hundreths_r = int(numbers[7]) // 10
            dialog = []
            while line := f.readline().rstrip():
                dialog.append(line)
            joined_dialog = "\\N".join(dialog)
            joined_dialog = joined_dialog.replace("<i>", "{\\i1}")
            joined_dialog = joined_dialog.replace("</i>", "{\\i0}")
            joined_dialog = joined_dialog.replace("<b>", "{\\b1}")
            joined_dialog = joined_dialog.replace("</b>", "{\\b0}")
            print(
                f"Dialogue: 0,{':'.join(hms_l)}.{hundreths_l:02d},"
                f"{':'.join(hms_l)}.{hundreths_r:02d},Default,,0,0,0,,{joined_dialog}"
            )
        except Exception:
            break
