import sys
import re

def highlight_substring(line):
    # Highlight the substring between '>>>' and '<<<' in bright red
    line = re.sub(r'(>>>.*?<<<)', r'\033[91m\1\033[0m', line)
    # Highlight any substring starting with '#line' until the end of the line in gray
    line = re.sub(r'(#line.*)', r'\033[91m\1\033[0m', line)
    return line

def check_for_stars(source_code):
    found = False
    for line_num, line in enumerate(source_code.splitlines(), start=1):
        if '>>>' in line:
            found = True
            highlighted_line = highlight_substring(line)            
            print(f"{highlighted_line}")
    
    if found:
        sys.exit(1)
    else:
        sys.exit(0)

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python script.py <filename>")
        sys.exit(1)

    filename = sys.argv[1]

    try:
        with open(filename, 'r') as file:
            source_code = file.read()
            check_for_stars(source_code)
    except FileNotFoundError:
        print(f"File '{filename}' not found.")
        sys.exit(1)
