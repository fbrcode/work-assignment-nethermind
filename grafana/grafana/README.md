# Grafana

Grafana is an open source tool built primarily for time-series data analysis which is this project use-case.

Aiming for a better visualization, it allows to build multiple dashboard graphs and compare them side-by-side.

## Initiate and run

By running the docker command, a grafana instance will run on port 3000 by default.

```shell
cd ./database
# startup
docker-compose up -d
```

To change the target port, please modify the `docker-compose.yml` file accordingly.

To stop the container, just run `docker-compose down`
