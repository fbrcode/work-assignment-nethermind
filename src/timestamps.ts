import { ethers } from 'ethers';
import config from './config';
import { logger } from './logger';
import { humanNumber } from './utils';

export async function getTimestampsParallel(blockNumberList: number[], amountParallelism: number) {
  const uniqueBlockNumberList = [...new Set(blockNumberList)];
  logger.info(
    `Getting timestamps for ${humanNumber(
      uniqueBlockNumberList.length
    )} block numbers with parallelism of ${amountParallelism} at a time (be patient, this will take a while)...`
  );
  const provider = new ethers.providers.JsonRpcProvider(config.RPC_PROVIDER);
  const blockKV = {};

  let rangeStart = 0;
  let rangeEnd: number = 0;
  let fetches = {};
  let errorArray = [];
  let countFetches = 0;
  do {
    countFetches++;
    if (countFetches % 10 === 0) {
      logger.info(`> Processed ${((rangeEnd * 100) / uniqueBlockNumberList.length).toFixed(1)} %`);
    }
    logger.debug(
      `> getting ${humanNumber(rangeEnd)} timestamps of ${humanNumber(
        uniqueBlockNumberList.length
      )}...`
    );
    rangeEnd = rangeStart + amountParallelism;
    const fragment = uniqueBlockNumberList.slice(rangeStart, rangeEnd);
    try {
      fetches = await Promise.all(
        fragment.map((number) =>
          provider.getBlock(number).then((block) => (blockKV[number] = block.timestamp))
        )
      ).then(() => blockKV);
    } catch (e) {
      if (e.code === 'TIMEOUT') {
        logger.error(
          `** ignore this TIMEOUT error ** it will fallback to reprocess with single fetch process >> ${e}`
        );
      } else {
        logger.error(`** ${e.code} >> ${e}`);
      }
      if (fragment.length > 1) {
        errorArray = [...errorArray, ...fragment];
      } else {
        logger.error(`Block number erroring on timestamp: ${fragment[0]}`);
      }
    }
    rangeStart = rangeStart + amountParallelism;
  } while (rangeEnd <= uniqueBlockNumberList.length);

  // reprocess failed mass fetches as individual fetch
  let pending = undefined;
  if (errorArray.length > 0) {
    pending = await getTimestampsParallel(errorArray, 1);
  }

  return fetches;
}
