#	'ensure that formatted text option in draw.io is disabled everywhere'

#SRC=rt0d.rt
SRC=test.rt
D2J=./das2json/mac/das2json

dev: basic

all:
	${D2J} t2t.drawio
	${D2J} 0D/python/std/transpile.drawio
	python3 main.py . 0D/python ${SRC} main t2t.drawio.json transpile.drawio.json

regress:
	${D2J} py-t2t.drawio
	${D2J} 0D/python/std/transpile.drawio
	python3 main.py . 0D/python rt0d.rt main py-t2t.drawio.json transpile.drawio.json >rtpy0d.py
	python3 rtpy0d.py

basic:
	node t2t.mjs <rt-py.t2t >0D2py.mjs
	node 0d2py.mjs <rt-py.t2t

#########

# to install required libs, do this once
install-js-requires:
	npm install ohm-js yargs prompt-sync

clean:
	rm *.json
	rm *~
	rm junk.*

