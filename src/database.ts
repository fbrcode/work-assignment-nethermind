import { Client } from 'pg';

// TODO: clear text just for demo purposes
function getDbClient() {
  return new Client({
    host: 'localhost',
    user: 'postgres',
    database: 'db',
    password: 'postgres',
    port: 5430,
  });
}

export async function clearDbData() {
  const client = getDbClient();
  try {
    await client.connect();
    await client.query(`delete from univ3.pool_history`);
    await client.query(`delete from univ3.pool_ticks`);
    await client.query(`delete from univ3.pools_top`);
    return true;
  } catch (error) {
    console.error(error);
    return false;
  } finally {
    await client.end(); // closes connection
  }
}

// TODO: not ideal implementation of connection handling
// TODO: use bulk commit for better performance
export async function addPoolsDb(pollsData: any) {
  const client = getDbClient();
  try {
    await client.connect();
    for (const pool of pollsData) {
      const tokens = pool.token0.symbol + '/' + pool.token1.symbol;
      await client.query(
        `insert into univ3.pools_top (
          id, 
          id_tokens, 
          fee, 
          current_tvl_usd, 
          current_tick, 
          token0_id, 
          token0_symbol, 
          token0_name, 
          token1_id, 
          token1_symbol, 
          token1_name
        ) 
        values ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)`,
        [
          pool.id,
          tokens,
          pool.feeTier,
          pool.totalValueLockedUSD,
          pool.tick,
          pool.token0.id,
          pool.token0.symbol,
          pool.token0.name,
          pool.token1.id,
          pool.token1.symbol,
          pool.token1.name,
        ]
      );
    }
    console.log(`Top pools inserted on db (${pollsData.length} entries)`);
    return true;
  } catch (error) {
    console.error(error);
    return false;
  } finally {
    await client.end();
  }
}

// TODO: not ideal implementation of connection handling
// TODO: use bulk commit for better performance
export async function addPoolTicksDb(poolId: string, poolTicksData: any) {
  const client = getDbClient();
  try {
    await client.connect();
    for (const tick of poolTicksData) {
      await client.query(
        `insert into univ3.pool_ticks (
          id,
          pool_id,
          tick_index,
          constant_price0,
          constant_price1
        ) values ($1, $2, $3, $4, $5)`,
        [tick.id, poolId, tick.tickIdx, tick.price0, tick.price1]
      );
    }
    console.log(`Pool ticks inserted on db (${poolTicksData.length} entries)`);
    return true;
  } catch (error) {
    console.error(error);
    return false;
  } finally {
    await client.end();
  }
}

// TODO: not ideal implementation of connection handling
// TODO: use bulk commit for better performance
export async function addPoolHistoryDb(poolId: string, poolHistoryData: any) {
  const client = getDbClient();
  try {
    await client.connect();
    for (const hist of poolHistoryData) {
      const dt = new Date(hist.date * 1000).toLocaleString();
      await client.query(
        `insert into univ3.pool_history (
          id,
          pool_id,
          unix_date,
          hist_date,
          tick_id,
          volumeToken0,
          volumeToken1,
          tokenPrice0,
          tokenPrice1,
          volumeUSD,
          tvlUSD,
          txCount,
          sqrtPrice,
          liquidity,
          feesUSD
        ) values ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15)`,
        [
          hist.id,
          poolId,
          hist.date,
          dt,
          hist.tick,
          hist.volumeToken0,
          hist.volumeToken1,
          hist.token0Price,
          hist.token1Price,
          hist.volumeUSD,
          hist.tvlUSD,
          hist.txCount,
          hist.sqrtPrice,
          hist.liquidity,
          hist.feesUSD,
        ]
      );
    }
    console.log(`Pool history inserted on db (${poolHistoryData.length} entries)`);
    return true;
  } catch (error) {
    console.error(error);
    return false;
  } finally {
    await client.end();
  }
}
