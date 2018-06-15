##tasks query
```
http://localhost:7557/tasks/?query={"_id":"5b20cf35e0ec8a4a45e000dc"}

当_id不存在时，会很久都不超时
```

## tasks create
- 创建一个设置参数的tasks
```
  curl -i 'http://localhost:7557/devices/001565-SIP%252DT22P-00156546699d/tasks?timeout=3000&connection_request' \
> -X POST \
> --data '{ "name": "setParameterValues", "parameterValues": [["Device.Services.VoiceService.1.VoiceProfile.1.Line.1.SIP.AuthPassword", "123456"]] }'
HTTP/1.1 202 Task queued but not processed
GenieACS-Version: 1.1.2
Content-Type: application/json
Date: Thu, 14 Jun 2018 03:01:34 GMT
Connection: keep-alive
Transfer-Encoding: chunked

成功是会返回
{"name":"setParameterValues","parameterValues":[["Device.Services.VoiceService.1.VoiceProfile.1.Line.1.SIP.AuthPassword","123456"]],"device":"001565-SIP%2DT22P-00156546699d","timestamp":"2018-06-14T03:01:30.212Z","_id":"5b21da8a6759255b5d84df2d"}
```

- 设置一个不存在的设备
```
  curl -i 'http://localhost:7557/devices/001565-SIP%252DT22P-00156546699d1/tasks?timeout=3000&connection_request' \
  > -X POST \
  > --data '{ "name": "setParameterValues", "parameterValues": [["Device.Services.VoiceService.1.VoiceProfile.1.Line.1.SIP.AuthPassword", "123456"]] }'
  curl: (52) Empty reply from server

```
