#	'ensure that formatted text option in draw.io is disabled everywhere'

D2J=../das2json/mac/das2json

all: tester

tester: tester.drawio.json generated.mjs
	cat generated.mjs main.mjs >tester.mjs
	node tester.mjs "." "-" "-" main tester.drawio.json

generated.mjs: ../../rt/generated.mjs
	cp ../../rt/generated.mjs ./generated.mjs

tester.drawio.json: ./tester.drawio ./tester.drawio.json
	${D2J} tester.drawio

## house-keeping

clean:
	rm -rf *.json
	rm -rf *~
	rm -rf __pycache__

# python3 -m venv ./rt
# source rt/bin/activate
# pip3 install websockets
