# Nethermind Assignment

nethermind.io

Pre-requisites

- Node (nvm package manager)
- Yarn
- Postgres Client (psql)

Introduction

How it works

- build relational structure for uniswap v3 data
- grab blockchain event data from **the graph** endpoint provided by uniswap protocol (https://thegraph.com/hosted-service/subgraph/uniswap/uniswap-v3) (https://api.thegraph.com/subgraphs/name/uniswap/uniswap-v3/graphql) (https://github.com/Uniswap/v3-subgraph/blob/main/schema.graphql)

Steps and sequence...

-- (database) startup docker
-- (database) psql -f init.sql

-- yarn dev (wipe data and load)

Conclusions

Going forward

- Other databases (TimescaleDB)
- Other graph options
- Period selection
- API
- Interface
- Dynamic graph generation of pool data (i.e.: <https://www.chartjs.org/>)
- Insights/Trends analysis/generation
