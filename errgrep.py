import sys
import re

def check_for_stars(source_code):
    found = False
    for line_num, line in enumerate(source_code.splitlines(), start=1):
        if '>>>' in line:
            found = True
            print(f"\n{line}", file=sys.stderr)
        print (f"{line}")

if __name__ == "__main__":
    try:
        source_code = sys.stdin.read()
        check_for_stars(source_code)
    except FileNotFoundError:
        print(f"in errgrep.py: File '{filename}' not found.", file=sys.stderr)
