#	'ensure that formatted text option in draw.io is disabled everywhere'

#SRC=test.rt
#SRC=count.rt
#SRC=decode.rt
SRC=reverser.rt
#SRC=test.err.rt
#SRC=0d.rt

D2J=./das2json/mac/das2json

all:
	python3 choreographer.py



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

# python3 -m venv ./rt
# source rt/bin/activate
# pip3 install websockets
