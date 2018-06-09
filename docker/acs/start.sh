#!/bin/sh

echo "Start mongodb"
service mongodb start

echo "run npm install"
cd /app/genieacs && npm install

echo "run npm run compile"
cd /app/genieacs && npm run compile

echo "Start genieace-nbi"
/app/genieacs/bin/genieacs-nbi