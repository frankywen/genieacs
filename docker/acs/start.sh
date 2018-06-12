#!/bin/sh

echo "Start mongodb"
service mongodb start

echo "run npm install"
cd /app/genieacs && npm install

echo "run npm run compile"
cd /app/genieacs && npm run compile

if [ -f /app/genieacs/config/config-sample.json ]; then
  echo "mv config-sample.json to config.json"
  mv /app/genieacs/config/config-sample.json /app/genieacs/config/config.json
fi

echo "Start genieacs-cwmp genieacs-nbi genieacs-fs"
/app/genieacs/bin/genieacs-cwmp & /app/genieacs/bin/genieacs-nbi & /app/genieacs/bin/genieacs-fs