import sys
import re
from repl import live_update

def check_for_stars(source_code):
    found = False
    good = ''
    for line in source_code.splitlines():
        if '>>>' in line:
            found = True
            #print(f"errcheck: {line}", file=sys.stderr)
        else:
            good += line + '\n'
    if not found:
        print (good, file=sys.stdout)
    else:
        exit (1)

if __name__ == "__main__":
    try:
        source_code = sys.stdin.read()
        check_for_stars(source_code)
    except FileNotFoundError:
        print(f"in errgrep.py: File '{filename}' not found.", file=sys.stderr)
