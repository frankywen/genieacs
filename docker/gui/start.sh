#!/bin/sh
chmod -R 755 *

if [ -f /app/genieacs-gui/init.lock ]; then
  echo "Initialization"
else 
  for f in `ls /app/genieacs-gui/config/*-sample.yml`
  do 
    echo "mv samply.yml to .yml"
    mv "$f" "${f/-sample.yml/.yml}"
  done

  if [ -f /app/genieacs-gui/config/graphs-sample.json.erb ]; then
    echo "mv graphs-sample.json.erb to graphs.json.erb"
    mv /app/genieacs-gui/config/graphs-sample.json.erb /app/genieacs-gui/config/graphs.json.erb
  fi

  echo "set RAILS_ENV production bundle"
  cd /app/genieacs-gui && RAILS_ENV=production bundle && RAILS_ENV=production bundle exec rake assets:precompile

  echo "run bundle install"
  cd /app/genieacs-gui && bundle install
  touch /app/genieacs-gui/init.lock
fi

echo "Start enieacs-gui"
/app/genieacs-gui/bin/rails server
