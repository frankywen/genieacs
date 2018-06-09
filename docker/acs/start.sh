#!/bin/sh

echo "Start mongodb"
service mongodb start

echo "run npm install"
cd /app/genieacs && npm install

echo "run npm run compile"
cd /app/genieacs && npm run compile

if [-f /app/genieacs/config/config-sample.json]
  echo "mv config-sample.json to config.json"
  mv /app/genieacs/config/graphs-sample.json.erb /app/genieacs/config/config.json
fi

echo "Start genieace-nbi"
/app/genieacs/bin/genieacs-nbi