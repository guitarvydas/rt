#!/bin/bash
# usage ./generate-chunk.bash ${SRC}.a generated.a.lisp
src=$1
gen=$2
python3 main.py . 0D/python $src main rt2cl.drawio.json >$gen
python3 mvline.py  80 >/tmp/$gen
mv /tmp/$gen ./$gen
python3 errcheck.py $gen
