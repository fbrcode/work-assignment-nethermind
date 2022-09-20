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

## Access

To access Grafana tool, go to <http://localhost:3000> and login with `admin/admin`.

If the dashboard don't display correctly, it can be imported again with by going to the **dashboards menu** and picking the option **import**.

Then the file `uniswap-v3-dashboard-grafana.json` can be loaded with all the existing graphs.
