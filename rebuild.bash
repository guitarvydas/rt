#!/bin/bash
set -e
D2J=./das2json/mac/das2json
${D2J} rt2py.drawio
./gen-py.bash 0d.rt 0d.py
./gen-py.bash stock.rt stock.py
./gen-py.bash shellout.rt shellout.py
cat 0d.py stock.py shellout.py > zd.py

./gen-py.bash count.rt count.py
./gen-py.bash decode.rt decode.py
./gen-py.bash reverser.rt reverser.py
./gen-py.bash delay.rt delay.py
./gen-py.bash monitor.rt monitor.py

cat zd.py count.py decode.py reverser.py delay.py monitor.py >generated.py
#echo '*** Python not generated ***' >generated.py

${D2J} rt2cl.drawio
./gen-cl.bash 0d.rt 0d.lisp
./gen-cl.bash stock.rt stock.lisp
./gen-cl.bash shellout.rt shellout.lisp
cat 0d.lisp stock.lisp shellout.lisp >zd.lisp

./gen-cl.bash count.rt count.lisp
./gen-cl.bash decode.rt decode.lisp
./gen-cl.bash reverser.rt reverser.lisp
./gen-cl.bash delay.rt delay.lisp
./gen-cl.bash monitor.rt monitor.lisp

cat zd.lisp count.lisp decode.lisp reverser.lisp delay.lisp monitor.lisp >generated.lisp
#echo '*** Common Lisp not generated ***' >generated.lisp

${D2J} rt2js.drawio
python3 main.py . - 0d.rt main rt2js.drawio.json >0d.mjs
python3 main.py . - stock.rt main rt2js.drawio.json >stock.mjs
python3 main.py . - shellout.rt main rt2js.drawio.json >shellout.mjs
cat 0d.mjs stock.mjs shellout.mjs > zd.mjs

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
