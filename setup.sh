#!/bin/sh

set -eu

echo "Checking InfluxDB connection ..."

i=0
until [ $i -ge $TIMEOUT ]
do
  nc -z $1 $2 && break

  i=$(( i + 1 ))

  echo "$i: Waiting for InfluxDB 1 second ..."
  sleep 1
done

if [ $i -eq $TIMEOUT ]
then
  echo "InfluxDB connection refused, terminating ..."
  exit 1
fi

echo "InfluxDB is up ..."

influx setup -f --host $INFLUXDB_URL  -u $INFLUXDB_USER -p $INFLUXDB_PW -o $INFLUXDB_ORG -t $INFLUXDB_TOKEN -b $INFLUXDB_BUCKETID -r $INFLUXDB_RETENTION
