#	'ensure that formatted text option in draw.io is disabled everywhere'

#SRC=test.rt
SRC=0d.rt

D2J=./das2json/mac/das2json

dev: generated-2py

all: generated-2cl

generated-2cl: rt2cl.drawio py0d.py *.ohm *.rewrite ${SRC}
	${D2J} rt2cl.drawio
	python3 main.py . 0D/python ${SRC} main rt2cl.drawio.json >generated-cl0d.lisp
	cat generated-cl0d.lisp

generated-2py: rt2py.drawio py0d.py *.ohm *.rewrite ${SRC}
	${D2J} rt2py.drawio
	python3 main.py . 0D/python ${SRC} main rt2py.drawio.json >generated-py0d.lisp
	cat generated-py0d.lisp

## house-keeping

clean:
	rm -rf *.json
	rm -rf *~
	rm -rf __pycache__
	rm -f generated-*

install-js-requires:
	npm install yargs prompt-sync ohm-js

