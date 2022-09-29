import { Pool } from 'pg';
import * as pgCopy from 'pg-copy-streams';
import { Readable } from 'readable-stream';
import config from './config';
import { logger } from './logger';

const pool = new Pool({
  user: config.PG_USER,
  host: config.PG_HOST,
  database: config.PG_DATABASE,
  password: config.PG_PASSWORD,
  port: config.PG_PORT,
});

const targetTable = 'univ3.swap_history';

function wipePoolEventsDb(poolId: string) {
  pool.connect(function (err, client, done) {
    try {
      client.query(`delete from ${targetTable} where pool_id = '${poolId}'`);
    } catch (error) {
      logger.error(error);
    } finally {
      client.release(); // release connection
    }
  });
}

export function swapHistoryBulkInsert(poolId: string, dataArray: any[]) {
  wipePoolEventsDb(poolId);
  logger.info(`Adding ${poolId} events to ${targetTable} table...`);
  pool.connect(function (err, client, done) {
    const stream = client.query(
      pgCopy.from(
        `COPY ${targetTable} (pool_id, block_number, unix_timestamp, hist_timestamp, transaction_hash, amount0, amount1, tick, sqrt_price_x96) FROM STDIN DELIMITER E'\t' CSV`
      )
    );
    stream.on('error', (e) => logger.error(e));
    stream.on('finish', done);
    // streamline the data array
    const readable = new Readable();
    dataArray
      .filter((e) => !!e.timestamp) // skip if timestamp is not found
      .map((d) => {
        const ts = new Date(d.timestamp * 1000).toString().substring(0, 24);
        const row = `${poolId}\t${d.blockNumber}\t${d.timestamp}\t${ts}\t${d.txHash}\t${d.amount0}\t${d.amount1}\t${d.tick}\t${d.sqrtPriceX96}`;
        readable.push(row + '\n');
      });
    readable.push(null);
    // pipe stream array to postgres /copy from
    readable.pipe(stream); // readable.pipe(process.stdout);
  });
}
