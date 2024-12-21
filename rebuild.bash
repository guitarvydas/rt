#!/bin/bash
set -e
D2J=./das2json/mac/das2json
${D2J} rt2py.drawio
./gen-py.bash 0d.rt.a generated.a.py
./gen-py.bash 0d.rt.b generated.b.py
cat generated.a.py generated.b.py > zd.py

./gen-py.bash count.rt count.py
./gen-py.bash decode.rt decode.py
./gen-py.bash reverser.rt reverser.py
./gen-py.bash delay.rt delay.py
./gen-py.bash monitor.rt monitor.py

cat zd.py count.py decode.py reverser.py delay.py monitor.py >generated.py
#echo '*** Python not generated ***' >generated.py

${D2J} rt2cl.drawio
./gen-cl.bash 0d.rt.a generated.a.lisp
./gen-cl.bash 0d.rt.b generated.b.lisp
cat generated.a.lisp generated.b.lisp >zd.lisp

./gen-cl.bash count.rt count.lisp
./gen-cl.bash decode.rt decode.lisp
./gen-cl.bash reverser.rt reverser.lisp
./gen-cl.bash delay.rt delay.lisp
./gen-cl.bash monitor.rt monitor.lisp

cat zd.lisp count.lisp decode.lisp reverser.lisp delay.lisp monitor.lisp >generated.lisp
#echo '*** Common Lisp not generated ***' >generated.lisp

${D2J} rt2js.drawio
python3 main.py . - 0d.rt.a main rt2js.drawio.json >generated.a.mjs
python3 main.py . - 0d.rt.b main rt2js.drawio.json >generated.b.mjs
cat generated.a.mjs generated.b.mjs > zd.mjs

python3 main.py . - count.rt main rt2js.drawio.json >count.mjs
python3 main.py . - decode.rt main rt2js.drawio.json >decode.mjs
python3 main.py . - reverser.rt main rt2js.drawio.json >reverser.mjs
python3 main.py . - delay.rt main rt2js.drawio.json >delay.mjs
python3 main.py . - monitor.rt main rt2js.drawio.json >monitor.mjs

cat count.mjs zd.mjs decode.mjs reverser.mjs delay.mjs monitor.mjs >generated.mjs


echo '"javascript":"' >generated-js.json
cat generated.mjs >> generated-js.json
echo '",' >> generated-js.json
echo '"python":"' >generated-py.json
cat generated.py >> generated-py.json
echo '",' >> generated-py.json
echo '"lisp":"' >generated-cl.json
cat generated.lisp >> generated-cl.json
echo '",' >> generated-cl.json
