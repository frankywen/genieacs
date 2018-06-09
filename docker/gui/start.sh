#!/bin/sh
echo "mv samply.yml to .yml"
for f in /app/genieacs-gui/config/*-sample.yml; do mv "$f" "${f/-sample.yml/.yml}"; done


if [-f /app/genieacs-gui/config/graphs-sample.json.erb]
  echo "mv graphs-sample.json.erb to graphs.json.erb"
  mv /app/genieacs-gui/config/graphs-sample.json.erb /app/genieacs-gui/config/graphs.json.erb
fi

echo "Start enieacs-gui"
/app/genieacs-gui/bin/rails server