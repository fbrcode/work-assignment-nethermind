import fetch from 'node-fetch';
import config from './config';
import { logger } from './logger';
import {
  topPoolsQuery,
  topPoolsVariables,
  ticksByPoolQuery,
  ticksByPoolVariables,
  poolHistoryQuery,
  poolHistoryVariables,
} from './queries';
import {
  PoolGroup,
  PoolData,
  TickGroup,
  TickPoolData,
  PoolDayHistoryGroup,
  PoolDayHistoryData,
} from './types';

export async function fetchGql(query: string, variables: any) {
  const result = await fetch(config.GRAPHQL_API_ENDPOINT, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({ query, variables }),
  });
  return await result.json();
}

// getTopPools skips the first item, since it doesn't match Uniswap UI (UMIIE/UMIIE2 is the first fetching with graphql)
export async function getTopPools(): Promise<PoolGroup> {
  let resContent: PoolGroup = [];
  try {
    const response: PoolData = await fetchGql(topPoolsQuery, topPoolsVariables);
    resContent = response.data.pools;
  } catch (e) {
    logger.error(e);
  }
  return resContent;
}

export async function getPoolTicks(poolId: string): Promise<TickGroup> {
  ticksByPoolVariables.poolId = poolId;
  let resContent: TickGroup = [];
  let ticksData: TickGroup = [];
  ticksByPoolVariables.skipPagination = 0;

  try {
    do {
      const response: TickPoolData = await fetchGql(ticksByPoolQuery, ticksByPoolVariables);
      resContent = response.data.ticks;
      if (resContent.length === 0) {
        return ticksData;
      }
      logger.info(`Fetching +100 (ticks)...`);
      ticksData = ticksData.concat(resContent);
      ticksByPoolVariables.skipPagination += 100;
    } while (resContent.length > 0);
  } catch (e) {
    logger.error(e);
  }
  return ticksData;
}

export async function getPoolsHistory(poolId: string): Promise<PoolDayHistoryGroup> {
  poolHistoryVariables.poolId = poolId;
  let resContent: PoolDayHistoryGroup = [];
  let poolDayDatas: PoolDayHistoryGroup = [];
  poolHistoryVariables.skipPagination = 0;
  try {
    do {
      const response: PoolDayHistoryData = await fetchGql(poolHistoryQuery, poolHistoryVariables);
      resContent = response.data.poolDayDatas;
      if (resContent.length === 0) {
        return poolDayDatas;
      }
      logger.info(`Fetching +100 (history)...`);
      poolDayDatas = poolDayDatas.concat(resContent);
      poolHistoryVariables.skipPagination += 100;
    } while (resContent.length > 0);
  } catch (e) {
    logger.error(e);
  }

  return poolDayDatas;
}
