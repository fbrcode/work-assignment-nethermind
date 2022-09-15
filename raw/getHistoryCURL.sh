curl 'https://api.thegraph.com/subgraphs/name/uniswap/uniswap-v3' \
-H 'Content-Type: application/json' \
-H 'Accept: application/json' \
-H 'Connection: keep-alive' \
-H 'DNT: 1' \
-H 'Origin: https://www.graphqlbin.com' \
--data-binary '{"query":"{\n  poolHourDatas(\n    orderBy: periodStartUnix\n    orderDirection: asc\n    where: { pool: \"0x5777d92f208679db4b9778590fa3cab3ac9e2168\", periodStartUnix_gt: 1655164800 }\n  ) {\n    id\n    periodStartUnix\n    tick # current tick at end of period\n    volumeToken0 # volume in token0\n    volumeToken1 # volume in token1\n    sqrtPrice # current price tracker at end of period\n    token0Price # price of token0 - derived from sqrtPrice\n    token1Price # price of token1 - derived from sqrtPrice\n  }\n}\n"}' \
--compressed > getHistorySample.json