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
```
query example

http://localhost:7557/devices/?query={"_id":"001565-SIP%2DT22P-00156546699d"}

http://192.168.78.201:7557/devices/?projection="_deviceId,_lastBoot,_lastInform,_registered,_lastBootstrap"&sort={"_registered":-1}&skip=0&limit=10

http://192.168.78.201:7557/tasks/?query={"_id":"5b20cf35e0ec8a4a45e000dc"}

http://192.168.78.201:7557/tasks/?query={"device":"000EB4-IPPBX-00100800GK6100100000000EB40AB0D0"}
```
[API Reference](https://github.com/genieacs/genieacs/wiki/API-Reference)
