#!/bin/bash
set -e
D2J=./das2json/mac/das2json
${D2J} rt2py.drawio
./gen.bash test.rt generated.json
