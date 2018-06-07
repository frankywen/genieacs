#!/bin/sh

echo "Start mongodb"
service mongodb start

echo "Start genieace-nbi"
/app/genieacs-gui/bin/genieacs-nbi