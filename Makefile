#	'ensure that formatted text option in draw.io is disabled everywhere'

#SRC=test.rt
#SRC=test.err.rt
SRC=0d.rt

D2J=./das2json/mac/das2json



#all: generated-py
all: generated-cl


generated-py: rt2py.drawio py0d.py *.ohm *.rewrite ${SRC}.a ${SRC}.b
	${D2J} rt2py.drawio
	python3 main.py . 0D/python ${SRC}.a main rt2py.drawio.json >generated.a.py
	python3 mvline.py generated.a.py 80 >/tmp/generated.a.py
	mv /tmp/generated.a.py ./generated.a.py
	python3 errcheck.py generated.a.py
	python3 main.py . 0D/python ${SRC}.b main rt2py.drawio.json >generated.b.py
	python3 mvline.py generated.b.py 80 >/tmp/generated.b.py
	mv /tmp/generated.b.py ./generated.b.py
	python3 errcheck.py generated.b.py
	cat generated.a.py generated.b.py >generated.py
	python3 generated.py


generated-cl: rt2py.drawio py0d.py *.ohm *.rewrite ${SRC}.a ${SRC}.b
	${D2J} rt2cl.drawio
	./generate-cl-chunk.bash ${SRC}.a generated.a.lisp
	./generate-cl-chunk.bash ${SRC}.b generated.b.lisp
	cat generated.a.lisp generated.b.lisp >generated.lisp
	cat generated.lisp

# # for debug - partial - create the .MJS dsl
# rt2cldsl: rt2cldsl.drawio py0d.py *.ohm *.rewrite ${SRC}
# 	${D2J} rt2cldsl.drawio
# 	python3 main.py . 0D/python ${SRC} main rt2cldsl.drawio.json


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

