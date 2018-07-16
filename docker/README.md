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

http://192.168.78.201:7557/devices/?query={"Device.DeviceInfo.SerialNumber":"00156546699d"}

http://192.168.78.201:7557/devices/?projection="_deviceId,_lastBoot,_lastInform,_registered,_lastBootstrap"&sort={"_registered":-1}&skip=0&limit=10

http://192.168.78.201:7557/tasks/?query={"_id":"5b20cf35e0ec8a4a45e000dc"}

http://192.168.78.201:7557/tasks/?query={"device":"000EB4-IPPBX-00100800GK6100100000000EB40AB0D0"}

#模糊搜索
http://192.168.78.201:7557/presets/?query={"_id":{"$regex":"t"}}

#查询故障
http://192.168.78.201:7557/faults

#序列号
http://192.168.78.201:7557/devices/?query={"_id":{"$regex":"000EA9396A5"}}

http://192.168.78.201:7557/devices/?query={"Device.DeviceInfo.SerialNumber":{"$regex":"000EA9396A5"}}

#制造商
http://192.168.78.201:7557/devices/?query={"_deviceId._Manufacturer":{"$regex":"GZ"}}

#产品类别
http://192.168.78.201:7557/devices/?query={"_deviceId._ProductClass":{"$regex":"IPPBX"}}

#IP
http://192.168.78.201:7557/devices/?query={"Device.LAN.IPAddress":{"$regex":"192.168.79.11"}}

```
[API Reference](https://github.com/genieacs/genieacs/wiki/API-Reference)


## ssl
- acs cwmp(CPE WAN Management Protocol，CPE广域网管理协议, 南向) 
  nbi(northbound interface, 北向接口供sms等系统调用)都可以开启ssl
- 开启ssl后，测试Yealink设备无法连接报证书错误, 禁用了“只允许受信任证书”也无法连接上, 需要更多的设备进行测试
- IPPBX设备可以正常连接，并上报及设置参数

## task跟踪
- 建task时失败会报202, 'Task faulted'
- task未执行完成可以通过tasks接口查询
- 如task执行遇到错误会记录到faults接口

## 预设
- 通过产品序列号做为预设条件(还支持产品类型、软件版本)
- 预设值参数中有值错误时，整个预设参数都不生效，并记录到faults中

## 验证设置成功
- task执行完成后，再查询参数进行对比


## 告警信息
- 查询faults接口

## 注意事项
- 设置的参数如果不存在时，不会报错，也不会向cpe设置该参数，建议在设置时判断该参数是否存在
- 设置的参数值有错误时会报错，并记录到faults中
- faults接口数据会进会重试，所以需要进行对应删除（比如参数值错误的）
