#!/bin/bash
SRC=test.rt
D2J=./das2json/mac/das2json
echo '#77 CL test successful' >generated.lisp
echo '#77 line 2 CL test successful' >>generated.lisp
${D2J} rt2py.drawio
python3 main.py . 0D/python ${SRC}.a main rt2py.drawio.json >generated.a.py
python3 mvline.py generated.a.py 60 >/tmp/generated.a.py
mv /tmp/generated.a.py ./generated.a.py
python3 errcheck.py generated.a.py
python3 main.py . 0D/python ${SRC}.b main rt2py.drawio.json >generated.b.py
python3 mvline.py generated.b.py 60 >/tmp/generated.b.py
mv /tmp/generated.b.py ./generated.b.py
python3 errcheck.py generated.b.py
cat generated.a.py generated.b.py >generated.py
python3 generated.py
${D2J} rt2cl.drawio
./generate-cl-chunk.bash ${SRC}.a generated.a.lisp
./generate-cl-chunk.bash ${SRC}.b generated.b.lisp
cat generated.a.lisp generated.b.lisp >generated.lisp

