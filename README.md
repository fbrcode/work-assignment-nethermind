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

> Note: v2 branch fetches additional blockchain data from RPC provider or a local node to more data history insights.

## Environment variables

- `LOG_LEVEL` : Logging level for the execution (options = info / debug / silent...)
- `GRAPHQL_API_ENDPOINT` : URL endpoint for Uniswap Subgraph (GraphQL) data
- `UNIX_TIMESTAMP_START_PERIOD` : Starting unix timestamp for Uniswap Subgraph pool history
- `NUMBER_OF_POOLS` : Number of pools to grab from Uniswap Subgraph (as of now we are sipping first 4 ones due to non-realistic data)
- `PG_HOST` : Postgres connection host
- `PG_USER` : Postgres user
- `PG_DATABASE` : Postgres database name
- `PG_PASSWORD` : Postgres user password
- `PG_PORT` : Postgres connection port
- `RPC_PROVIDER` : RPC API endpoint for data reading
- `ETHERSCAN_ENDPOINT` : Etherscan API endpoint (not used at the moment)
- `ETHERSCAN_API_KEY` : Etherscan API key (not used at the moment)
- `BLOCK_NUMBER_START` : Staring block number to fetch blocks, receipts, etc
- `BLOCKS_FETCH_AMOUNT` : How many blocks will be fetched on every iteration
- `CACHE_DIRECTORY` : Cache directory assigned to store blockchain data for further usage (or reload)
- `LOAD_FROM_CACHE` : If yes or true, use cached data if they exist for each pool
- `TIMESTAMP_PARALLEL_COUNT_FETCH` : How many parallel fetching processes will be triggered in parallel to get timestamp data from blocks

## Installation steps

In order tp run this small PoC, please follow these steps (Linux/Mac):

1. `git clone <https://github.com/fbrcode/work-assignment-nethermind.git>`
2. `cd work-assignment-nethermind/database` (for detailed information go to [database readme](./database/README.md))
3. `source .env`
4. `cp .env.example .env` (and change accordingly)
5. `docker compose up -d`
6. `psql -f init.sql` (create and recreate database structures)
7. `cd ..`
8. `yarn`
9. `cp .env.example .env`
10. `yarn test` (run simple validation)
11. `yarn dev` (execute the whole process)
12. `cd grafana` (for detailed information go to [grafana readme](./grafana/README.md))
13. `chmod -R 777 grafana`
14. `docker compose up -d`

Then, import the dashboard data from file `./grafana/uniswap-v3-dashboard-grafana.json`

## On v2 Only

There is an option to reload cached events from previous data fetching. This is useful to avoid fetching lots of data again from RPC provider or local node.

- `yarn load` will trigger the data fetching from cache and load into `univ3.swap_history` table.

## Going forward

These are some action points that would enhance the project:

- Other databases (i.e. [TimescaleDB](https://www.timescale.com/))
- Other graph options (i.e. [Chart.js](https://www.chartjs.org/))
- Time period selection and automated fetching
- API and Interface interactions
- Dynamic and automated graph generation of pool data
- Insights/Trends analysis and/or generation
