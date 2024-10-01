#	'ensure that formatted text option in draw.io is disabled everywhere'

#SRC="test.rt"
SRC="rt.rt"

D2J=./das2json/mac/das2json-x86_64

all: rt2py

rt2py: rt2py.drawio py0d.py *.ohm *.rewrite
	${D2J} rt2py.drawio
	python3 main.py . 0D/python ${SRC} main rt2py.drawio.json

## house-keeping

clean:
	rm -rf *.json
	rm -rf *~
	rm -rf __pycache__

install-js-requires:
	npm install yargs prompt-sync ohm-js

