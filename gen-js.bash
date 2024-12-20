#!/bin/bash
# usage ./gen-js.bash ${SRC}.a generated.a.js
echo generate chunk py $1 $2
set -e
src=$1
gen=$2
python3 main.py . - $src main rt2js.drawio.json >$gen
# python3 jsmvline.py  $gen 50 >/tmp/$gen
# mv /tmp/$gen ./$gen
# python3 errcheck.py $gen
