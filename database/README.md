# Postgres Data Management

This is a database for time series data storage, which is not ideal but a fast start to handle data organization for graph display.

Other good option are [TimescaleDB](https://www.timescale.com/) options are [Graphite](https://graphiteapp.org/).

## Database design

[insert here]

## Startup

Install `psql` locally to be able to use standard postgres and run migration processes.

External reference: <https://blog.timescale.com/blog/how-to-install-psql-on-mac-ubuntu-debian-windows/>

Alternatively, postgres can be installed locally, mac option is `brew install postgresql`

Copy `.env.example` to `.env` and modify connection settings if needed.

## Initiate / refresh db

**ATTENTION**: Execution of below steps will wipe out local database data.

```shell
cd ./data
source .env
# startup
docker-compose up -d
# or refresh (erase all data) with..
docker-compose down && docker volume rm data_db && docker-compose up -d
# install or refresh (2nd run onwards) all tables
psql -f init.sql
```

## Sample data

Pools:

```txt
                     id                     | id_tokens | fee  |           current_tvl_usd           | current_tick |                 token0_id                  | token0_symbol |  token0_name   |                 token1_id                  | token1_symbol |  token1_name  |          created_at
--------------------------------------------+-----------+------+-------------------------------------+--------------+--------------------------------------------+---------------+----------------+--------------------------------------------+---------------+---------------+-------------------------------
 0x5777d92f208679db4b9778590fa3cab3ac9e2168 | DAI/USDC  |  100 |        883742013.163731011259337721 | -276324      | 0x6b175474e89094c44da98b954eedeac495271d0f | DAI           | Dai Stablecoin | 0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48 | USDC          | USD Coin      | 2022-09-15 13:21:44.748848+00
 0x6c6bc977e13df9b0de53b251522280bb72383700 | DAI/USDC  |  500 | 413800368.0112416710854421080940297 | -276325      | 0x6b175474e89094c44da98b954eedeac495271d0f | DAI           | Dai Stablecoin | 0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48 | USDC          | USD Coin      | 2022-09-15 13:21:44.753394+00
 0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8 | USDC/WETH | 3000 | 301679905.5800094651936380854499185 | 202629       | 0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48 | USDC          | USD Coin       | 0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2 | WETH          | Wrapped Ether | 2022-09-15 13:21:44.759311+00
```

History:

```txt

```
