import { ethers } from 'ethers';
import config from './config';
import { logger } from './logger';
import { writeFile } from './utils';
import { getTimestampsParallel } from './timestamps';
import { unixDateTimeConverter, humanNumber } from './utils';
import { swapHistoryBulkInsert } from './dbStream';
import { loadFromCachedData, cachedEventsExists } from './loadFromCache';

const poolImmutablesAbi = [
  'function factory() external view returns (address)',
  'function token0() external view returns (address)',
  'function token1() external view returns (address)',
  'function fee() external view returns (uint24)',
  'function tickSpacing() external view returns (int24)',
  'function maxLiquidityPerTick() external view returns (uint128)',
  'event Initialize(uint160 sqrtPriceX96, int24 tick)',
  'event Swap(address indexed sender,address indexed recipient,int256 amount0,int256 amount1,uint160 sqrtPriceX96,uint128 liquidity,int24 tick)',
];

// get all swap events from start block to end block
async function filterSwapEvents(
  contract: ethers.Contract,
  filter: ethers.EventFilter,
  startBlockNumber: number,
  blocksPagination: number,
  stopBlockNumber: number
) {
  const provider = new ethers.providers.JsonRpcProvider(config.RPC_PROVIDER);
  let fetchesCount = 1;
  let swapEventHeader = undefined;
  let swapEvents = [];
  let endBlockNumber = startBlockNumber + blocksPagination - 1;
  const initialBlockNumber = startBlockNumber;
  logger.info(
    `[swap events] Scanning block range ${humanNumber(initialBlockNumber)}...${humanNumber(
      stopBlockNumber
    )} (block amount = ${humanNumber(stopBlockNumber - initialBlockNumber)})`
  );
  do {
    const startTimestamp = (await provider.getBlock(startBlockNumber)).timestamp;
    let pctProgress: number | string =
      ((endBlockNumber - initialBlockNumber) * 100) / (stopBlockNumber - initialBlockNumber);
    pctProgress = pctProgress > 100 ? '100.00' : pctProgress.toFixed(2);
    logger.info(
      `[swap event #${fetchesCount}] Fetching blocks from ${humanNumber(
        startBlockNumber
      )} to ${humanNumber(
        endBlockNumber
      )} (${pctProgress}%) [time: ${startTimestamp} / ${unixDateTimeConverter(startTimestamp)}]...`
    );
    try {
      const fragmentSwapEvents = await contract.queryFilter(
        filter,
        startBlockNumber,
        endBlockNumber
      );
      if (fragmentSwapEvents && !swapEventHeader) {
        // fetch the swap header only once
        swapEventHeader = {
          event: fragmentSwapEvents[0].event,
          eventSignature: fragmentSwapEvents[0].eventSignature,
        };
      }
      const fragment = fragmentSwapEvents.map((e) => {
        return {
          blockNumber: e.blockNumber,
          timestamp: -1, // need to fetch this information faster, reding one by one will delay the process
          address: e.address,
          transactionHash: e.transactionHash,
          data: {
            sender: e.args[0].toString(),
            recipient: e.args[1].toString(),
            amount0: e.args[2].toString(),
            amount1: e.args[3].toString(),
            sqrtPriceX96: e.args[4].toString(),
            liquidity: e.args[5].toString(),
            tick: e.args[6].toString(),
          },
        };
      });
      swapEvents = [...swapEvents, ...fragment];
    } catch (e) {
      console.error(e);
      return [{}];
    } finally {
      startBlockNumber = endBlockNumber + 1;
      endBlockNumber = startBlockNumber + blocksPagination - 1;
      fetchesCount++;
    }
  } while (startBlockNumber < stopBlockNumber);

  // fetch all block numbers and fill up their timestamps from block number
  const blockNumberList = [];
  swapEvents.map((e) => {
    blockNumberList.push(e.blockNumber);
  });
  const uniqueBlockNumberList = [...new Set(blockNumberList)];
  const blockNumberTimestamp = await getTimestampsParallel(
    uniqueBlockNumberList,
    config.TIMESTAMP_PARALLEL_COUNT_FETCH
  );
  swapEvents.map((e) => (e.timestamp = blockNumberTimestamp[e.blockNumber]));

  return {
    EventHeader: swapEventHeader,
    EventBody: swapEvents,
  };
}

export async function processPoolEvents(
  poolId: string,
  performCache?: boolean,
  useCachedEvents?: boolean
) {
  if (useCachedEvents && cachedEventsExists(poolId)) {
    logger.info(`Using cached events for pool ${poolId}...`);
    loadFromCachedData(poolId);
    return;
  }

  const provider = new ethers.providers.JsonRpcProvider(config.RPC_PROVIDER);
  const poolContract = new ethers.Contract(poolId, poolImmutablesAbi, provider);
  const filterSwap = poolContract.filters.Swap(null);
  const latestBlockNumber = (await provider.getBlock('latest')).number;
  let eventList = {};
  eventList = await filterSwapEvents(
    poolContract,
    filterSwap,
    config.BLOCK_NUMBER_START,
    config.BLOCKS_FETCH_AMOUNT,
    latestBlockNumber
  );

  // save log file for later
  if (performCache) {
    const fileTarget = `${poolId}-swap-events.json`;
    const swapCacheFile = `${config.CACHE_DIRECTORY}/${fileTarget}`;
    writeFile(config.CACHE_DIRECTORY, swapCacheFile, eventList);
  }
  logger.info(`Fetched ${eventList['EventBody'].length} swap events.`);

  // streamline events to database
  console.log('first item after fetching...');
  console.log(eventList['EventBody'][0]);
  swapHistoryBulkInsert(poolId, eventList['EventBody']);
}
