curl 'https://api.thegraph.com/subgraphs/name/uniswap/uniswap-v3' \
-H 'Content-Type: application/json' \
-H 'Accept: application/json' \
-H 'Connection: keep-alive' \
-H 'DNT: 1' \
-H 'Origin: https://www.graphqlbin.com' \
--data-binary '{"query":"{\n  pools(orderBy: totalValueLockedUSD, orderDirection: desc, first: 3, skip: 1) {\n    id # pool address\n    feeTier # fee amount\n    totalValueLockedUSD # tvl USD\n    tick # current tick\n    token0 {\n      id\n      symbol\n      name\n    }\n    token1 {\n      id\n      symbol\n      name\n    }\n    ticks {\n      # array of ticks linked to the pool\n      id # tick id, format = <pool address>#<tick index>\n      tickIdx\n      liquidityGross # total liquidity pool has as tick lower or upper\n      liquidityNet # how much liquidity changes when tick crossed\n      price0 # calculated price of token0 of tick within this pool - constant\n      price1 # calculated price of token1 of tick within this pool - constant\n      createdAtTimestamp # created time\n      createdAtBlockNumber # created block\n    }\n  }\n}"}' \
--compressed > getPoolsSample.json
