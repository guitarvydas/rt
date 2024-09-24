#	'ensure that formatted text option in draw.io is disabled everywhere'

SRC=rt0d.rt
#SRC=test.rt
D2J=./das2json/mac/das2json

dev: python

commonlisp: 0D2cl.mjs support.mjs ${SRC}
	${D2J} cl-t2t.drawio
	${D2J} 0D/python/std/transpile.drawio
	python3 main.py . 0D/python ${SRC} main cl-t2t.drawio.json transpile.drawio.json >rtcl0d.lisp
	cat rtcl0d.lisp

python: 0D2py.mjs support.mjs t2t.mjs ${SRC}
	${D2J} py-t2t.drawio
	${D2J} 0D/python/std/transpile.drawio
	python3 main.py . 0D/python ${SRC}.optimized main py-t2t.drawio.json transpile.drawio.json >rtpy0d.py
	cat rtpy0d.py
	python3 rtpy0d.py

regress: python

basic: 0D2py.mjs support.mjs
	node 0d2py.mjs <rt0d.rt >rtpy0d.raw.py
	node scrubber.js <rtpy0d.raw.py >rtpy0d.scrubbed.py
	node indenter.js <rtpy0d.scrubbed.py >rtpy0d.py

0D2py.mjs: grammar rewrite-py support.mjs t2t.mjs
	cat grammar rewrite-py >rt-py.t2t
	node t2t.mjs <rt-py.t2t >0D2py.mjs

0D2cl.mjs: grammar rewrite-cl t2t.mjs support.mjs
	cat grammar rewrite-cl >rt-cl.t2t
	node t2t.mjs <rt-cl.t2t >0D2cl.mjs

t2t.mjs : ../t2t/t2t.mjs
	cp ../t2t/t2t.mjs .

support.mjs : ../t2t/support.mjs
	cp ../t2t/support.mjs .


#########

# to install required libs, do this once
install-js-requires:
	npm install ohm-js yargs prompt-sync

clean:
	rm -f *.json
	rm -f *~
	rm -f junk.*
	rm -f 0D2py.mjs
	rm -f t2t.mjs
	rm -f support.mjs



