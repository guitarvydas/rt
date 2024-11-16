#!/bin/bash
set -e
SRC=monitor.rt
#SRC=delay.rt
#SRC=reverser.rt
#SRC=decode.rt
#SRC=count.rt
#SRC=test.rt
#SRC=0d.rt
D2J=./das2json/mac/das2json
echo '#77 CL test successful' >generated.lisp
echo '#77 line 2 CL test successful' >>generated.lisp
${D2J} rt2py.drawio
./generate-py-chunk.bash ${SRC}.a generated.a.py
./generate-py-chunk.bash ${SRC}.b generated.b.py
cat generated.a.py generated.b.py >generated.py
${D2J} rt2cl.drawio
./generate-cl-chunk.bash ${SRC}.a generated.a.lisp
./generate-cl-chunk.bash ${SRC}.b generated.b.lisp
cat generated.a.lisp generated.b.lisp >generated.lisp

