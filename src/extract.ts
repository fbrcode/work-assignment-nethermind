import fetch from 'cross-fetch';
import { ApolloClient, InMemoryCache, gql, HttpLink } from '@apollo/client';
import config from './config';
import { logger } from './logger';

export function getGraphQLClient() {
  return new ApolloClient({
    link: new HttpLink({ uri: config.GRAPHQL_API_ENDPOINT, fetch }),
    cache: new InMemoryCache(),
  });
}

// skipping the first one, since it doesn't match Uniswap interface (UMIIE/UMIIE2)
export async function getPools() {
  let resContent: any[] = [];
  const top3PoolsQuery = gql`
    query {
      pools(orderBy: totalValueLockedUSD, orderDirection: desc, first: ${config.NUMBER_OF_POOLS}, skip: 1) {
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

  try {
    const res = await getGraphQLClient().query({ query: top3PoolsQuery });
    resContent = res.data.pools;
  } catch (e) {
    logger.error(e);
  }
  return resContent;
}

export async function getPoolTicks(poolId: string) {
  let resContent: any[] = [];
  let ticksData: any[] = [];
  let skipPagination = 0;
  try {
    do {
      if (skipPagination > 0) logger.info(`Fetching +100 (ticks)...`);
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

      const res = await getGraphQLClient().query({ query: poolsTicksQuery });
      resContent = res.data.ticks;
      if (resContent.length === 0) {
        return ticksData;
      }
      ticksData = ticksData.concat(resContent);
      skipPagination += 100;
    } while (resContent.length > 0);
  } catch (e) {
    logger.error(e);
  }
  return ticksData;
}

export async function getPoolsHistory(poolId: string) {
  let resContent: any[] = [];
  let poolDayDatas: any[] = [];
  let poolsHistoryQuery: any;
  let skipPagination = 0;
  try {
    do {
      if (skipPagination > 0) logger.info(`Fetching +100 (history)...`);
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

      const res = await getGraphQLClient().query({ query: poolsHistoryQuery });
      resContent = res.data.poolDayDatas;
      if (resContent.length === 0) {
        return poolDayDatas;
      }
      poolDayDatas = poolDayDatas.concat(resContent);
      skipPagination += 100;
    } while (resContent.length > 0);
  } catch (e) {
    logger.error(e);
  }

  return poolDayDatas;
}
