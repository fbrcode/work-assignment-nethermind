import config from './config';

// GraphQL query to get top pools
export const topPoolsQuery = `
query GetTopPools(
  $numberOfPools: Int!
) {
  pools(
      orderBy: totalValueLockedUSD
      orderDirection: desc
      first: $numberOfPools
      skip: 1
  ) {
    id
    feeTier
    totalValueLockedUSD
    tick
    token0 {
      id
      symbol
      name
      decimals
    }
    token1 {
      id
      symbol
      name
      decimals
    }
  }          
}
`;

export const topPoolsVariables = {
  numberOfPools: config.NUMBER_OF_POOLS,
};

export const ticksByPoolQuery = `
query GetTicksByPool(
  $poolId: String!, 
  $skipPagination: Int!
) {
  ticks(
    skip: $skipPagination
    where: { pool: $poolId }
  ) {
    id
    tickIdx
    price0
    price1
  }
}
`;

export const ticksByPoolVariables = {
  poolId: '0x...',
  skipPagination: 0,
};

export const poolHistoryQuery = `
query GetHistoryByPool(
  $poolId: String!, 
  $skipPagination: Int!,
  $unixStartTimestamp: Int!
) {
  poolDayDatas(
    skip: $skipPagination
    orderBy: date
    orderDirection: asc
    where: { 
      pool: $poolId, 
      date_gt: $unixStartTimestamp
    }
  ) {
    id
    date
    tick
    volumeToken0
    volumeToken1
    token0Price
    token1Price
    volumeUSD
    tvlUSD
    txCount
    sqrtPrice
    liquidity
    feesUSD
  }
}
`;

export const poolHistoryVariables = {
  poolId: '0x...',
  skipPagination: 0,
  unixStartTimestamp: config.UNIX_TIMESTAMP_START_PERIOD,
};
