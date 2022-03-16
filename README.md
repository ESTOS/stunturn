# estos UCServer STUN/TURN server

## Purpose
Provide self hosted STUN and TURN services in order to allow SIPSoftphone calls, AudioChat, VideoChat, DesktopSharing sessions for ProCall Enterprise clients (Windows and Mobile) to function regardless of firewall limitations.

## Requisites

- a Docker Enabled Linux Machine with min. 2 vCPU, 4GB RAM and 20GB Disk
- a public IP address assigned directly to the Machine or via a 1:1 NAT
- The following open/forwarded firewall ports:
    - 3478/TCP
    - 3478/UDP
    - 49152-65535/UDP


## Enable Docker
Quick start:
```
# curl -sSL https://get.docker.com | sudo bash -
```

## Run the application
```
docker run -d --name stunturn --network host --restart always \
-e EXTERNAL_IP_ADDRESS=YourExternalIPAddress \ 
-e LISTENING_IP_ADDRESS=YourLocalIPAddress \
-e TURN_PORT=3478 \
-e TURN_USERNAME=YourTurnUsername \
-e TURN_PASSWORD=YourTurnPassword \
estos/stunturn

```

## Get UCServer configuration info
In order to get configuration info, use the following command:
```
docker logs stunturn
```

The first ~10 lines will contain useful configuration information for your UCServer. E.g.
```
No TURN_PORT env variable set. Default 3478 UDP and TCP will be used
No TURN_USERNAME env variable set, user will be set to 'stunturn' and password will be randomly generated
Created TURN user 'stunturn' with password 'RLYmta9lTFQM0ClqECWq'. Please use said credentials into your estos application
Executing TURN service... 
Your STUN and TURN server is now running
Please configure your estos UCServer own STUN and TURN servers according to the following template: 
STUN Server --> stun:1.123.456.254:3478
TURN Server --> turn:1.123.456.254:3478
TURN username: stunturn
TURN password: RLYmta9lTFQM0ClqECWq
```

## Diagnostic logs
Logs are stored in local file within the container in the following name format: `/var/tmp/stunturn_DD_MM_YYYY.log`

To list them run:

```
docker exec stunturn ls /var/tmp/
```

to print out a specific one (e.g. from 26/04/2022):

```
docker exec stunturn cat /var/tmp/stunturn_26_04_2022.log
```


## Parameters

| Parameter | Mandatory | Default | Description |
|---|---|---|---|
| LISTENING_IP_ADDRESS | No | All interfaces | Local IP for STUN/TURN to listen on. If not set: will listen to all local Network interfaces
| EXTERNAL_IP_ADDDRESS | No | Autodetected | Public IP address the STUN/TURN will use as relay address. Useful in NATted scenarios. Will be autodetected if not set.
| TURN_PORT | No | 3478 | TCP port (for TURN) and UDP port (for STUN) the STUN/TURN server will listen to
| TURN_USERNAME| No | stunturn | Username for TURN authentication
| TURN_PASSWORD | No| random_string | Password for TURN authentication
| LOG_LEVEL | No | normal | allowed values: 'moderate','debug'
