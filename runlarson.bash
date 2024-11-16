#!/bin/bash
set -e
cd ../rtlarson
make scanner.drawio.json
cd ../rt
cp ../rtlarson/scanner.drawio.json .
./rebuild.bash
cat generated.py larsonmain.py >larson.py
./run1.bash
