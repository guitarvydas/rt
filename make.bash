#!/bin/bash
set -e
node das2json.js rt2all.drawio
./rt '0d'
./rt 'shellout'
./rt 'stock'
NOW=$(date)
FRESHDIR="before-${NOW}"
mkdir ../zd/"${FRESHDIR}"
mv ../zd/kernel0d.py ../zd/"${FRESHDIR}"
cat 0d.py shellout.py stock.py >../zd/kernel0d.py

