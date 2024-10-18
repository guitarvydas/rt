#	'ensure that formatted text option in draw.io is disabled everywhere'

#SRC=test.rt
#SRC=0d.rt
SRC=0d.a.rt
#SRC=0d.b.rt

D2J=./das2json/mac/das2json


all: generated-2py
#all: generated-2cl

generated-2cl: rt2cl.drawio py0d.py *.ohm *.rewrite ${SRC}
	${D2J} rt2cl.drawio
	python3 main.py . 0D/python ${SRC} main rt2cl.drawio.json >generated-cl0d.lisp
	cat generated-cl0d.lisp

rt2cldsl: rt2cldsl.drawio py0d.py *.ohm *.rewrite ${SRC}
	${D2J} rt2cldsl.drawio
	python3 main.py . 0D/python ${SRC} main rt2cldsl.drawio.json


generated-2py: rt2py.drawio py0d.py *.ohm *.rewrite ${SRC}
	${D2J} rt2py.drawio
	python3 main.py . 0D/python ${SRC} main rt2py.drawio.json >generated-py0d.py
	python3 errcheck.py generated-py0d.py


## house-keeping

clean:
	rm -rf *.json
	rm -rf junk*
	rm -rf temp.*
	rm -rf *~
	rm -rf __pycache__
	rm -f generated-*

install-js-requires:
	npm install yargs prompt-sync ohm-js

