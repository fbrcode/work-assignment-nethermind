import { readdirSync, existsSync } from 'fs';
import config from './config';
import { readFile, humanNumber } from './utils';
import { swapHistoryBulkInsert } from './dbStream';
import { logger } from './logger';

export function cachedEventsExists(poolId: string): boolean {
  if (!existsSync(config.CACHE_DIRECTORY)) {
    return false;
  }
  const fileSourceFullPath = `${config.CACHE_DIRECTORY}/${poolId}-swap-events.json`;
  return existsSync(fileSourceFullPath);
}

export async function loadFromCachedData(poolId?: string) {
  if (!existsSync(config.CACHE_DIRECTORY)) {
    logger.error(`Cache directory ${config.CACHE_DIRECTORY} does not exist`);
    return;
  }

  const cachedFiles = readdirSync(config.CACHE_DIRECTORY);
  const eventsCachedFiles = cachedFiles.filter(
    (f) => f.toLocaleLowerCase().startsWith('0x') && f.toLocaleLowerCase().endsWith('events.json')
  );

  if (eventsCachedFiles.length === 0) {
    logger.error(`Valid files were not found in the directory ${config.CACHE_DIRECTORY}`);
    return;
  }

  for (const fileSource of eventsCachedFiles) {
    const pool = fileSource.substring(0, fileSource.indexOf('-'));
    logger.info(`Processing pool ${pool}`);
    logger.info(`Loading data from cached: ${fileSource}...`);
    const fileSourceFullPath = `${config.CACHE_DIRECTORY}/${fileSource}`;
    try {
      const data = readFile(fileSourceFullPath);
      const events = JSON.parse(data);
      let eventList = [];
      events['EventBody'].map((e: any) => {
        eventList.push({
          blockNumber: e.blockNumber,
          timestamp: e.timestamp,
          amount0: e.data.amount0,
          amount1: e.data.amount1,
          tick: e.data.tick,
          sqrtPriceX96: e.data.sqrtPriceX96,
        });
      });
      logger.debug(`Generated ${humanNumber(eventList.length)} event items to load`);
      // refresh and add data again from cache...
      swapHistoryBulkInsert(pool, eventList);
    } catch (e) {
      logger.error(e);
    }
  }
}

loadFromCachedData();
