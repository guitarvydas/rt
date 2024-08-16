#	'ensure that formatted text option in draw.io is disabled everywhere'

#SRC=rt0d.rt
SRC=test.rt
D2J=./das2json/mac/das2json

dev: commonlisp

all:
	${D2J} t2t.drawio
	${D2J} 0D/python/std/transpile.drawio
	python3 main.py . 0D/python ${SRC} main t2t.drawio.json transpile.drawio.json

commonlisp: 0D2py.mjs
	${D2J} cl-t2t.drawio
	${D2J} 0D/python/std/transpile.drawio
	python3 main.py . 0D/python rt0d.rt main cl-t2t.drawio.json transpile.drawio.json >rtcl0d.lisp

regress: 0D2py.mjs
	${D2J} py-t2t.drawio
	${D2J} 0D/python/std/transpile.drawio
	python3 main.py . 0D/python rt0d.rt main py-t2t.drawio.json transpile.drawio.json >rtpy0d.py
	python3 rtpy0d.py

basic: 0D2py.mjs
	node 0d2py.mjs <rt0d.rt >rtpy0d.raw.py
	node scrubber.js <rtpy0d.raw.py >rtpy0d.scrubbed.py
	node indenter.js <rtpy0d.scrubbed.py >rtpy0d.py

0D2py.mjs: grammar rewrite-py
	cat grammar rewrite-py >rt-py.t2t
	node t2t.mjs <rt-py.t2t >0D2py.mjs

#########

# to install required libs, do this once
install-js-requires:
	npm install ohm-js yargs prompt-sync

clean:
	rm -f *.json
	rm -f *~
	rm -f junk.*
	rm -f 0D2py.mjs


