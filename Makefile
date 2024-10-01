#	'ensure that formatted text option in draw.io is disabled everywhere'

#SRC="test.rt"
SRC="0d.rt"

D2J=./das2json/mac/das2json-x86_64

all: generated-2py

generated-2py: rt2py.drawio py0d.py *.ohm *.rewrite
	${D2J} rt2py.drawio
	python3 main.py . 0D/python ${SRC} main rt2py.drawio.json >generated-py0d.py
	cat generated-py0d.py
	python3 generated-py0d.py

## house-keeping

clean:
	rm -rf *.json
	rm -rf *~
	rm -rf __pycache__

install-js-requires:
	npm install yargs prompt-sync ohm-js

