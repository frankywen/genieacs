iGenieACS expoeses a rich API through its NBI component. The API is HTTP based and uses JSON as the data format. This document serves as a reference for the available APIs.

For reference on search query format, refer to MongoDB queries.

The examples below are done using curl for simplicity and ease of testing. Query parameters are URL-encoded, but non encoded params are included as a comment for reference. The examples assume genieacs-nbi is running locally and listening to the default NBI port (7557).


# Functions

## GET /\<collection\>/?query=\<query\>

Search for items in database (e.g. devices, tasks, presets, files). Returns a JSON representation of all items in the given collection that match the search criteria.

*Collection*: The data collection to search. Could be one of: tasks, devices, presets, objects.

*Query*: Search query. Refer to MongoDB queries for reference.

### Examples

* Find device by its ID:

        # query={"_id":"202BC1-BM632w-0000000"}
        
        curl -i 'http://localhost:7557/devices/?query=%7B%22_id%22%3A%22202BC1-BM632w-0000000%22%7D'

* Find a device by its MAC address:

        # query={
        #    "InternetGatewayDevice.WANDevice.1.WANConnectionDevice.1.WANIPConnection.1.MACAddress" :
        #       "20:2B:C1:E0:06:65"
        # }
        
        curl -i 'http://localhost:7557/devices/?query=%7B%22InternetGatewayDevice.WANDevice.1.WANConnectionDevice.1.WANIPConnection.1.MACAddress%22%3A%2220:2B:C1:E0:06:65%22%7D'

* Search for devices which have not sent an inform in the last 7 days.

        # query={
        #    "_lastInform" :
        #       {
        #           "$lt" : "2017-12-11 13:16:23 +0000"
        #       }
        # }
        
        curl -i 'http://localhost:7557/devices/?query=%7B%22_lastInform%22%3A%7B%22%24lt%22%3A%222017-12-11%2013%3A16%3A23%20%2B0000%22%7D%7D

* Show pending tasks for a given device:

        # query={"device":"202BC1-BM632w-0000000"}
        
        curl -i 'http://localhost:7557/tasks/?query=%7B%22device%22%3A%22202BC1-BM632w-0000000%22%7D'

* Return specific parameters for a given device:

        # query={"_id":"202BC1-BM632w-0000000"}

        curl -i 'http://localhost:7557/devices?query=%7B%22_id%22%3A%22202BC1-BM632w-0000000%22%7D&projection=InternetGatewayDevice.DeviceInfo.ModelName,InternetGatewayDevice.DeviceInfo.Manufacturer'

  The projection is a comma separated list of the values you want.

## POST /devices/\<device_id\>/tasks?[connection_request]

Append a task to queue for a given device. Refer to below for reference about tasks format. Returns status code 200 if tasks have been successfully executed, and 202 if the tasks have been queued to be executed at the next inform.

*device_id*: The ID of the device

*connection_request*: Indicates that connection request will be triggered to execute the tasks immediatly. Otherwise, tasks will be queued and be handled at the next inform.

### Examples

* Refresh all device parameters now:

        curl -i 'http://localhost:7557/devices/202BC1-BM632w-0000000/tasks?connection_request' \
        -X POST \
        --data '{"name":"refreshObject", "objectName":""}'

* Change WiFi SSID and password:

        # query={
        #   "name":"setParameterValues",
        #   "parameterValues":
        #      [
        #         ["InternetGatewayDevice.LANDevice.1.WLANConfiguration.1.SSID", "GenieACS", "xsd:string"],
        #         ["InternetGatewayDevice.LANDevice.1.WLANConfiguration.1.PreSharedKey.1.PreSharedKey", "hello world", "xsd:string"]
        #      ]
        # }
        
        curl -i 'http://localhost:7557/devices/202BC1-BM632w-0000000/tasks?connection_request' \
        -X POST \
        --data '{"name":"setParameterValues", "parameterValues":[["InternetGatewayDevice.LANDevice.1.WLANConfiguration.1.SSID", "GenieACS", "xsd:string"],["InternetGatewayDevice.LANDevice.1.WLANConfiguration.1.PreSharedKey.1.PreSharedKey", "hello world", "xsd:string"]]}'


## POST /tasks/\<task_id\>/retry

Retry a faulty task at the next inform.

*task_id*: The ID of the task as returned by 'GET /tasks' request.

### Example

    curl -i 'http://localhost:7557/tasks/5403908ef28ea3a25c138adc/retry' -X POST


## DELETE /tasks/\<task_id\>

Delete the given task.

*task_id*: The ID of the task as returned by 'GET /tasks' request.

### Example

    curl -i 'http://localhost:7557/tasks/5403908ef28ea3a25c138adc' -X DELETE


## POST /devices/\<device_id\>/tags/\<tag\>

Assign a tag to a device. Has no effect if such tag already exists.

*device_id*: The ID of the device.

*tag*: The tag to be assigned.

### Example

Assign the tag "testing" to a device:

    curl -i 'http://localhost:7557/devices/202BC1-BM632w-0000000/tags/testing' -X POST

## DELETE /devices/\<device_id\>/tags/\<tag\>

Remove a tag from a device.

*device_id*: The ID of the device.

*tag*: The tag to be assigned.

### Example

Remove the tag "testing" from a device:

    curl -i 'http://localhost:7557/devices/202BC1-BM632w-0000000/tags/testing' -X DELETE

## PUT /presets/\<preset_name\>

Create or update a preset. Returns status code 200 if the preset has been added/updated successfully. The body of the request is a JSON representation of the preset. Refer to below for reference on presets format. The preset name cannot contain ".".

*preset_name*: The name of the preset.

### Example

Create a preset to set 5 minutes inform interval for all devices tagged with "test":

    # query={
    #    weight: 0,
    #    precondition: "{\"_tags\":\"test\"}"
    #    configurations:
    #       [
    #           { type: "value",
    #             name: "InternetGatewayDevice.ManagementServer.PeriodicInformEnable", value: "true" },
    #           { type: "value", name: "InternetGatewayDevice.ManagementServer.PeriodicInformInterval",
    #              value: "300" }
    #       ]
    # }
    
    curl -i 'http://localhost:7557/presets/inform' \
    -X PUT \
    --data '{ "weight": 0, "precondition": "{\"_tags\":\"test\"}", "configurations": [ { "type": "value", "name": "InternetGatewayDevice.ManagementServer.PeriodicInformEnable", "value": "true" }, { "type": "value", "name": "InternetGatewayDevice.ManagementServer.PeriodicInformInterval", "value": "300" } ] }'

## DELETE /presets/\<preset_name\>

	curl -i 'http://localhost:7557/presets/inform' -X DELETE

## PUT /files/\<file_name\>

Upload a new file or overwrite an existing one. Returns status code 200 if the file has been added/updated successfully. The file content should be sent as the request body.

*file_name*: The name of the device.

The meta info of the file are sent in the request headers. There are four meta info:

- *fileType*: For firmware images it should be "1 Firmware Upgrade Image". Other common types are "2 Web Content" and "3 Vendor Configuration File".
- *oui*: The OUI of the device model that this file belogs to.
- *productClass*: The product class of the device.
- *version*: In the case of firmware images, this refer to the firmware version.

### Example

Upload a firmware image file:

    curl -i 'http://localhost:7557/files/new_firmware_v1.0.bin' \
    -X PUT \
    --data-binary @"./new_firmware_v1.0.bin" \
    --header "fileType: 1 Firmware Upgrade Image" \
    --header "oui: 123456" \
    --header "productClass: ABC" \
    --header "version: 1.0"

## DELETE /files/\<file_name\>

Delete a previously uploaded file:

	curl -i 'http://localhost:7557/files/new_firmware_v1.0.bin' -X DELETE

## GET /files/

Gets all previously uploaded files

## GET /files/?query{"filename":"\<filename\>"}

Gets the previously uploaded file with corresponding filename

# Tasks
The &connection_request in the URL tells GenieACS to initiate a connection to the CPE. If the response from GenieACS is a 202 status code, that means the CPE didn't respond to the command before the timeout. The CPE could still be processing the request (or returning the response). Task ID can be found in the JSON Response Content as "_id":

    {
        "_id": "54dcacde2acb0b10130750d9",
        "device": "00236a-96318REF-SR360NA0A4%252D0003196",
        "name": "addObject",
        "objectName": "InternetGatewayDevice.WANDevice.1.WANConnectionDevice.1.WANPPPConnection",
        "timestamp": "2015-02-12T13:38:38.256Z"
    }

If the response from GenieACS is 200, then the CPE responded before the timeout and any actions have been applied by the CPE (setParameterValues, reboot, refreshObject, etc).

## getParameterValues
        # query={
        #    "name": "getParameterValues",
        #    "parameterNames":
        #       [
        #          "InternetGatewayDevice.WANDevice.1.WANConnectionDevice.1.WANIPConnectionNumberOfEntries",
        #          "InternetGatewayDevice.Time.NTPServer1", "InternetGatewayDevice.Time.Status"
        #       ]
        # }
        
        curl -i 'http://localhost:7557/devices/00236a-96318REF-SR360NA0A4%252D0003196/tasks?timeout=3000&connection_request' \
        -X POST \
        --data '{ "name": "getParameterValues", "parameterNames": ["InternetGatewayDevice.WANDevice.1.WANConnectionDevice.1.WANIPConnectionNumberOfEntries", "InternetGatewayDevice.Time.NTPServer1", "InternetGatewayDevice.Time.Status"] }'

You can request one item, or multiple items.

Once the CPE has returned the result to GenieACS, you can then query GenieACS for the CPE and extract out the value you want from the JSON.

        # query={"_id":"00236a-96318REF-SR360NA0A4%2D0003196"}
        
        curl -i 'http://localhost:7557/devices/?query=%7B%22_id%22%3A%2200236a-96318REF-SR360NA0A4%252D0003196%22%7D'


## refreshObject
        curl -i 'http://localhost:7557/devices/00236a-SR552n-SR552NA084%252D0003269/tasks?timeout=3000&connection_request' \
        -X POST \
        --data '{ "name": "refreshObject", "objectName": "InternetGatewayDevice.WANDevice.1.WANConnectionDevice" }'

## setParameterValues
        curl -i 'http://localhost:7557/devices/00236a-SR552n-SR552NA084%252D0003269/tasks?timeout=3000&connection_request' \
        -X POST \
        --data '{ "name": "setParameterValues", "parameterValues": [["InternetGatewayDevice.ManagementServer.UpgradesManaged",false]] }'

Multiple values can be set at one time, by adding multiple arrays to the parameterValues key. For example:

        "parameterValues": [["InternetGatewayDevice.ManagementServer.UpgradesManaged", false], ["InternetGatewayDevice.Time.Enable", true], ["InternetGatewayDevice.Time.NTPServer1", "pool.ntp.org"]]

The server should reply with a 200 OK or a 202 Accepted and the parameter values as confirmation. In the latter case the task created is put in the queue. If the parameter values are not returned and the task is not placed, please note that the device ID must be URI-escaped.

## addObject
        curl -i 'http://localhost:7557/devices/00236a-SR552n-SR552NA084%252D0003269/tasks?timeout=3000&connection_request' \
        -X POST \
        --data '{"name":"addObject","objectName":"InternetGatewayDevice.WANDevice.1.WANConnectionDevice.1.WANPPPConnection"}'

## reboot
        curl -i 'http://localhost:7557/devices/00236a-SR552n-SR552NA084%252D0003269/tasks?timeout=3000&connection_request' \
        -X POST \
        --data '{ "name": "reboot" }'

## Factory Reset
        curl -i 'http://localhost:7557/devices/00236a-SR552n-SR552NA084%252D0003269/tasks?timeout=3000&connection_request' \
        -X POST \
        --data '{ "name": "factoryReset" }'
## download
         curl -i 'http://localhost:7557/devices/00236a-SR552n-SR552NA084%252D0003269/tasks?timeout=3000&connection_request' \
        -X POST \
        --data '{ "name": "download", "file": "mipsbe-6-42-lite.xml"}'

Attribute "file" is "_id" from file API `curl -i 'http://localhost:7557/files/`.

# Presets

Presets are like a configuration template. They have preconditions to which a device should match in order to get the configuration. A precondition could for example be the OUI == A1A1A1. Configuration could be that a parameter X should be set to Y.

## Precondition
The precondition is a JSON hash of any preconditions to match. Examples are {"param":"value"} or {"param":"value","param2":{"$ne":"value2"}}. Other operators that can be used are $gt, $lt, $gte and $lte.

## Configuration
The configuration is how to configure the device that matches a precondition. This is an array of hashes as shown below.

    [
           { type: "value",
             name: "InternetGatewayDevice.ManagementServer.PeriodicInformEnable", value: "true" },
           { type: "value", name: "InternetGatewayDevice.ManagementServer.PeriodicInformInterval",
              value: "300" },
           { type: "delete_object", name: "object_parent", object: "object_name"},
           { type: "add_object", name: "object_parent", object: "object_name"},
    ] 