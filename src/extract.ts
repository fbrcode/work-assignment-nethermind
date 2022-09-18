import fetch from 'cross-fetch';
import { ApolloClient, InMemoryCache, gql, HttpLink } from '@apollo/client';
import config from './config';

function getGraphQLClient() {
  return new ApolloClient({
    link: new HttpLink({ uri: config.GRAPHQL_API_ENDPOINT, fetch }),
    cache: new InMemoryCache(),
  });
}

const client = getGraphQLClient();

export async function getPools() {
  const top3PoolsQuery = gql`
    query {
      pools(orderBy: totalValueLockedUSD, orderDirection: desc, first: 3, skip: 1) {
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
  const res = await client.query({ query: top3PoolsQuery });
  const resContent = res.data.pools;
  return resContent;
}

export async function getPoolTicks(poolId: string) {
  let resContent: any[] = [];
  let ticksData: any[] = [];
  let skipPagination = 0;

  do {
    const poolsTicksQuery = gql`
    query {
      ticks(
        skip: ${skipPagination}
        where: { pool: "${poolId}" }
      ) {
        id
        tickIdx
        price0
        price1
      }
    }
  `;
    const res = await client.query({ query: poolsTicksQuery });
    resContent = res.data.ticks;
    if (resContent.length === 0) {
      return ticksData;
    }
    ticksData = ticksData.concat(resContent);
    console.log(`Fetching +100...`);
    skipPagination += 100;
  } while (resContent.length > 0);

  return ticksData;
}

export async function getPoolsHistory(poolId: string) {
  let resContent: any[] = [];
  let poolDayDatas: any[] = [];
  let poolsHistoryQuery: any;
  let skipPagination = 0;

  do {
    poolsHistoryQuery = gql`
      query {
        poolDayDatas(
          skip: ${skipPagination}
          orderBy: date
          orderDirection: asc
          where: { 
            pool: "${poolId}", 
            date_gt: ${config.UNIX_TIMESTAMP_START_PERIOD} 
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

    const res = await client.query({ query: poolsHistoryQuery });
    resContent = res.data.poolDayDatas;
    if (resContent.length === 0) {
      return poolDayDatas;
    }
    poolDayDatas = poolDayDatas.concat(resContent);
    console.log(`Fetching +100...`);
    skipPagination += 100;
  } while (resContent.length > 0);

  return poolDayDatas;
}
