# Nethermind Work Assignment - Uniswap V3 Protocol

This small PoC for [nethermind.io](https://nethermind.io/) has the intent to capture events from crypto ecosystem, more specifically observing Uniswap V3 Protocol historical data.

## Prerequisites

In order to run the project locally, the following needs to be installed in your local host for your specific platform:

- [Node.Js](https://nodejs.org/en/) (ideally through [NVM](https://github.com/nvm-sh/nvm))
- [Yarn](https://classic.yarnpkg.com/en/)
- [Postgres Client](https://www.compose.com/articles/postgresql-tips-installing-the-postgresql-client/) (psql)
- [Docker / Docker Compose](https://docs.docker.com/compose/install/)

## How it works

This is a summary on how the process works:

1. Data is [fetched](https://thegraph.com/hosted-service/subgraph/uniswap/uniswap-v3) from the Uniswap V3 (via [The Graph](https://thegraph.com/en/)) graphql endpoint, which allows to get [certain data nodes and combinations](https://github.com/Uniswap/v3-subgraph/blob/main/schema.graphql).
2. This data is then loaded in a PostgreSQL schema with some predefined tables to accommodate the data and views to perform certain transformations.
3. Once this data is in the database, we can view data plotted in [Grafana Open Source](https://grafana.com/oss/) tool on dashboard visualization.

## Installation steps

In order tp run this small PoC, please follow these steps (Linux/Mac):

1. `git clone <https://github.com/fbrcode/work-assignment-nethermind.git>`
2. `cd work-assignment-nethermind/database` (for detailed information go to [database readme](./database/README.md))
3. `source .env`
4. `cp .env.example .env`
5. `docker compose up -d`
6. `psql -f init.sql`
7. `cd ..`
8. `yarn`
9. `cp .env.example .env`
10. `yarn test`
11. `yarn dev`
12. `cd grafana` (for detailed information go to [grafana readme](./grafana/README.md))
13. `chmod -R 777 grafana`
14. `docker compose up -d`

Then, import the dashboard data from file `./grafana/uniswap-v3-dashboard-grafana.json`

## Going forward

These are some action points that would enhance the project:

- Other databases (i.e. [TimescaleDB](https://www.timescale.com/))
- Other graph options (i.e. [Chart.js](https://www.chartjs.org/))
- Time period selection and automated fetching
- API and Interface interactions
- Dynamic and automated graph generation of pool data
- Insights/Trends analysis and/or generation
