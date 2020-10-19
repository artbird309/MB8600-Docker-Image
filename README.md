## README

Runs a the handy script from https://github.com/mattund/modem-statistics that Matt Colyer converted to Go https://github.com/mcolyer/mb8600 and then Charlie Hedlin updated to support both https and https https://github.com/chedlin/mb8600. Currently only supports the mb8600 modem from Motorola.

I then converted Matt Colyer docker image to run standalone with alpine and removed the need for config files as the environment variables as passed to the container. This image pulls the v1.1.3 tag from https://github.com/artbird309/mb8600

### Command to compile docker image:
```
docker build --tag artbird309/mb8600-docker-image:1.0 https://github.com/artbird309/MB8600-Docker-Image.git
```

### Command to deploy container:
```
docker run -d \
--name=cable-modem-stats \
-e INFLUXDB_ADDRESS="http://192.168.1.1:8086" \
-e INFLUXDB_DATABASE="cable-modem" \
-e MODEM_PROTOCOL="http" \
--restart unless-stopped \
artbird309/mb8600-docker-image:1.0
```

## Parameters

Container images are configured using parameters passed at runtime (such as those above). These parameters are separated by a colon and indicate <external>:<internal> respectively. For example, -e MODEM_PROTOCOL="https" would change the script to run using https to connect to the modem.

| Parameter | Function |
| :----: | --- |
| `-e INFLUXDB_ADDRESS="http://192.168.1.1:8086"` | The InfluxDB server that you want to push the data too |
| `-e INFLUXDB_DATABASE="cable-modem"` | The InfluxDB database that you want to push the data too |
| `-e MODEM_PROTOCOL="http"` | The protocol that the script will use to connect to the modem, either https or http |