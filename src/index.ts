import { getTopPools, getPoolTicks, getPoolsHistory } from './extract';
import { clearDbData, addPoolsDb, addPoolTicksDb, addPoolHistoryDb } from './database';
import { logger } from './logger';
import { processPoolEvents } from './extractRPC';
import config from './config';

export async function main() {
  // clear database data
  logger.info(`Refresh db data...`);
  await clearDbData();

  // get top pools and adds to db
  logger.info(`Fetching top pools for analysis...`);
  const pollsData = await getTopPools();
  logger.debug(pollsData);
  if (!pollsData) {
    logger.error(`No pools data fetched.\nPlease check source endpoint.\nExiting...`);
    return;
  }
  if (!(await addPoolsDb(pollsData))) {
    logger.error(
      `Not able to add pools data properly.\nPlease check db connection/insert.\nExiting...`
    );
    return;
  }

  // get ticks and history data and adds to database
  for (const pool of pollsData) {
    const tokens = pool.token0.symbol + '/' + pool.token1.symbol;
    logger.info(`Fetching ticks and history data for pool ${tokens} (${pool.id})...`);
    const poolTicksData = await getPoolTicks(pool.id);
    logger.debug(poolTicksData);
    await addPoolTicksDb(pool.id, poolTicksData);
    const poolHistoryData = await getPoolsHistory(pool.id);
    logger.debug(poolHistoryData);
    await addPoolHistoryDb(pool.id, poolHistoryData);
    // fetch specific events from RPC or load from cached data
    logger.info(`Fetching detailed swap events history data for pool ${tokens} (${pool.id})...`);
    await processPoolEvents(pool.id, true, config.LOAD_FROM_CACHE);
  }
}

main();
