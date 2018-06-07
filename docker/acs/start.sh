#!/bin/sh

echo "Start mongodb"
service mongodb start

echo "Start genieace-nbi"
./node_modules/.bin/genieacs-nbi