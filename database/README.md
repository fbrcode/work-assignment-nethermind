# Postgres Data Management

This is a database for time series data storage, which is not ideal but a fast start to handle data organization for graph display.

Other good option are [TimescaleDB](https://www.timescale.com/) options are [Graphite](https://graphiteapp.org/).

## Basic structure

This database holds 3 tables to accommodate fetches from Uniswap V3 protocol data.

```txt
               ┌─────────────┐
               │             │
         ┌────►│  POOLS_TOP  │◄─────┐
         │     │             │      │
         │     └─────────────┘      │
         │                          │
         │                          │
┌────────┴────────┐        ┌────────┴────────┐
│                 │        │                 │
│   POOLS_TICKS   │        │  POOLS_HISTORY  │
│                 │        │                 │
└─────────────────┘        └─────────────────┘
```

- `POOLS_TOP`: Has top pools data ordered by Total Value Locked (USD) in descended.
- `POOLS_TICKS`: All ticks for the given pool representing possible pool pricing variances.
- `POOLS_HISTORY`: Daily data collection for each pool, including token amount and price at the end of each captured day.

All project objects are on `univ3` postgres schema.

## Startup

Install `psql` locally to be able to use standard postgres and run migration processes.

External reference: <https://blog.timescale.com/blog/how-to-install-psql-on-mac-ubuntu-debian-windows/>

Alternatively, postgres can be installed locally, mac option is `brew install postgresql`

Copy `.env.example` to `.env` and modify connection settings if needed.

## Initiate / refresh db

**ATTENTION**: Execution of below steps will wipe out local database data.

```shell
cd ./database
source .env
# startup
docker-compose up -d
# or refresh (erase all data) with..
docker-compose down && docker volume rm data_db && docker-compose up -d
# install or refresh (2nd run onwards) all tables
psql -f init.sql
```

## Backup and restore

In order to load latest data extracted frm Uniswap V3, run the following command:

```shell
psql -f full_extraction.sql
```

To take another backup, run:

```shell
pg_dump > full_extraction.sql
```
