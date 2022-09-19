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

async function fetchGql(query: string, variables: any) {
  const result = await fetch(config.GRAPHQL_API_ENDPOINT, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({ query, variables }),
  }).then((res) => res.json());
  return result;
}

// skipping the first one, since it doesn't match Uniswap interface (UMIIE/UMIIE2)
export async function getTopPools() {
  let resContent: any[] = [];
  try {
    const res = await fetchGql(topPoolsQuery, topPoolsVariables);
    resContent = res.data.pools;
  } catch (e) {
    logger.error(e);
  }
  return resContent;
}

export async function getPoolTicks(poolId: string) {
  ticksByPoolVariables.poolId = poolId;
  let resContent: any[] = [];
  let ticksData: any[] = [];
  ticksByPoolVariables.skipPagination = 0;

  try {
    do {
      const res = await fetchGql(ticksByPoolQuery, ticksByPoolVariables);
      resContent = res.data.ticks;
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

export async function getPoolsHistory(poolId: string) {
  poolHistoryVariables.poolId = poolId;
  let resContent: any[] = [];
  let poolDayDatas: any[] = [];
  poolHistoryVariables.skipPagination = 0;
  try {
    do {
      const res = await fetchGql(poolHistoryQuery, poolHistoryVariables);
      resContent = res.data.poolDayDatas;
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
