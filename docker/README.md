# Overview
This is for genieacs, genieacs-gui run environment

## Quick Start
```
git clone git@github.com:frankywen/genieacs.git
cd genieacs/docker/
chmod -R 755 acs/start.sh
chmod -R 755 gui/start.sh
```

start
```
docker-compose up -d
```

down
```
docker-compose down 
```

restart
```
docker-compose restart
```

acs server address
```
#cwmp
ip:7547

#nbi
ip:7557

#fs
ip:7567
```

gui server address
```
ip:3000
```

## ACS API Reference
[API Reference](https://github.com/genieacs/genieacs/wiki/API-Reference)
