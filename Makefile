#	'ensure that formatted text option in draw.io is disabled everywhere'

SRC=rt0d.rt
#SRC=test.rt
D2J=./das2json/mac/das2json

test_python:
	(make -s all >rtpy0d.py ; python3 rtpy0d.py)

all:
	${D2J} t2t.drawio
	${D2J} 0D/python/std/transpile.drawio
	python3 main.py . 0D/python ${SRC} main t2t.drawio.json transpile.drawio.json

#########

# to install required libs, do this once
install-js-requires:
	npm install ohm-js yargs prompt-sync

clean:
	rm *.json
