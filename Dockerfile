FROM alpine:latest

ENV MB8600_VERSION=v1.1.3
ENV MB8600_VERSION_PATH=1.1.3

LABEL \
  Description="Record mb8600 modem statistics in influxdb" \
  maintainer="ARTbird309" \
  org.opencontainers.image.source="https://github.com/artbird309/MB8600-Docker-Image"

# Build step
ENV GOPATH="/go"
ENV GO111MODULE=on

RUN apk add --no-cache --virtual build-dependencies go wget git musl-dev && \
  wget -O /mb8600.tar.gz https://github.com/artbird309/mb8600/archive/$MB8600_VERSION.tar.gz && \
  tar xf /mb8600.tar.gz && \
  mkdir -p $GOPATH && mkdir -p $GOPATH/src/matt.colyer.name/ && \
  mv /mb8600-$MB8600_VERSION_PATH $GOPATH/src/matt.colyer.name/mb8600 && \
  cd $GOPATH/src/matt.colyer.name/mb8600 && \
  go get && go build -o /mb8600 main.go && \
  rm -fr /mb8600.tar.gz /go && \
  apk del build-dependencies && \
  apk add --no-cache jq

# ENV for script to get rid of the options.json and pass it stright to the compiled file
ENV INFLUXDB_ADDRESS="http://192.168.1.1:8086"
ENV INFLUXDB_DATABASE="cable-modem"
ENV MODEM_PROTOCOL="https"

ENTRYPOINT ./mb8600 -influxdb-address $INFLUXDB_ADDRESS -influxdb-database $INFLUXDB_DATABASE -protocol $MODEM_PROTOCOL