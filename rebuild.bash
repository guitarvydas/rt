#!/bin/bash
set -e
APP=larson.rt
a0D=0d.rt.a
b0D=0d.rt.b
D2J=./das2json/mac/das2json
echo '#77 CL test successful' >generated.lisp
echo '#77 line 2 CL test successful' >>generated.lisp
${D2J} rt2py.drawio
./generate-py-chunk.bash ${a0D} generated.a.py
./generate-py-chunk.bash ${b0D} generated.b.py
cat generated.a.py generated.b.py > zd.py

./generate-py-chunk.bash count.rt count.py
./generate-py-chunk.bash decode.rt decode.py
./generate-py-chunk.bash reverser.rt reverser.py
./generate-py-chunk.bash delay.rt delay.py
./generate-py-chunk.bash monitor.rt monitor.py

# ${D2J} rt2cl.drawio
# ./generate-cl-chunk.bash ${a0D} generated.a.lisp
# ./generate-cl-chunk.bash ${b0D} generated.b.lisp
# cat generated.a.lisp generated.b.lisp >generated.lisp

