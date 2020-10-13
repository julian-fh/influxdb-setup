FROM quay.io/influxdb/influxdb:2.0.0-rc

ADD setup.sh ./

RUN chmod +x setup.sh

RUN apt-get update

RUN apt-get install -y netcat

CMD ["./setup.sh"]