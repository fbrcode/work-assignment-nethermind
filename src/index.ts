import { getTopPools, getPoolTicks, getPoolsHistory } from './extract';
import { clearDbData, addPoolsDb, addPoolTicksDb, addPoolHistoryDb } from './database';
import { logger } from './logger';

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
    const poolHistoryData = await getPoolsHistory(pool.id);
    logger.debug(poolHistoryData);
    await addPoolTicksDb(pool.id, poolTicksData);
    await addPoolHistoryDb(pool.id, poolHistoryData);
  }
}

main();
