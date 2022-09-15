import { getPools, getPoolsHistory } from './extract';
import { clearDbData, addPoolsDb, addPoolHistoryDb } from './database';

async function main() {
  // clear database data
  console.log(`Refresh db data...`);
  await clearDbData();

  // get top pools and adds to db
  console.log(`Fetching top pools for analysis...`);
  const pollsData = await getPools();
  if (!(await addPoolsDb(pollsData))) {
    console.error(
      `Not able to add pools data properly.\nPlease check db connection/insert.\nExiting...`
    );
    return;
  }

  // get history data and adds to database
  for (const pool of pollsData) {
    const tokens = pool.token0.symbol + '/' + pool.token1.symbol;
    console.log(`Fetching history data for pool ${tokens} (${pool.id})...`);
    const poolHistoryData = await getPoolsHistory(pool.id);
    await addPoolHistoryDb(pool.id, poolHistoryData);
  }
}

main();
