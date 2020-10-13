# influxdb-setup
Docker script to programmatically setup an InfluxDB 2.0

The script was created for usage in `docker-compose.yml` files (see [Usage in Docker Compose](#usage-in-docker-compose)).
However, you can use it in any environment you want.

The script uses the [official InfluxDB 2.0 image](https://quay.io/repository/influxdb/influxdb) which ensures compatibility to the specified InfluxDB version.
Currently, **only InfluxDB 2.0.0-rc** is supported, more versions are planned.

The script will wait for a user-defined amount of time until the InfluxDB is available and execute the setup command. If the DB is already set up, it will terminate with exit code 1.

## Environment Variables
The script has to be configured via the following (required) environment variables:

-  `$TIMEOUT`            - The amount of seconds, the script should try to connect to the database
-  `$INFLUXDB_SCHEMA`       - Schema (`http` or `https`) of the InfluxDB instance
-  `$INFLUXDB_HOST`       - Host of the InfluxDB instance
-  `$INFLUXDB_PORT`       - Port of the InfluxDB instance
-  `$INFLUXDB_USER`      - The new username
-  `$INFLUXDB_PW`        - The new password
-  `$INFLUXDB_ORG`       - The new organization 
-  `$INFLUXDB_TOKEN`     - Access token for the new user
-  `$INFLUXDB_BUCKETID`  - Initial BucketID for the new user
-  `$INFLUXDB_RETENTION` - Retention Policy for that bucket - see the [InfluxDB Documentation](https://docs.influxdata.com/influxdb/v2.0/get-started/#set-up-influxdb) for details

## Usage in Docker Compose
```YAML
version: '3'
services:
    influx:
        image: "quay.io/influxdb/influxdb:2.0.0-rc"
        expose:
        - "8086"
        volumes:
        - ./influxdb-data:/var/lib/influxdb2
        command: influxd run --bolt-path /var/lib/influxdb2/influxd.bolt --engine-path /var/lib/influxdb2/engine --store bolt

    influx-setup:
        image: "julianfh/influxdb-setup:latest"
        depends_on:
        - influx
        environment:
            TIMEOUT: 20
            INFLUXDB_SCHEMA: "http"
            INFLUXDB_HOST: "influx"
            INFLUXDB_PORT: "8086"
            INFLUXDB_TOKEN: "some-token"
            INFLUXDB_BUCKETID: "some-bucket"
            INFLUXDB_ORG: "organization"
            INFLUXDB_USER: "user"
            INFLUXDB_PW: "verysecurepassword1"
```