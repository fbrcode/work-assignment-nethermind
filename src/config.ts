import 'dotenv/config';

interface ENV {
  LOG_LEVEL: string | undefined;
  GRAPHQL_API_ENDPOINT: string | undefined;
  UNIX_TIMESTAMP_START_PERIOD: number | undefined;
  NUMBER_OF_POOLS: number | undefined;
  PG_HOST: string | undefined;
  PG_USER: string | undefined;
  PG_DATABASE: string | undefined;
  PG_PASSWORD: string | undefined;
  PG_PORT: number | undefined;
  RPC_PROVIDER: string | undefined;
  ETHERSCAN_ENDPOINT: string | undefined;
  ETHERSCAN_API_KEY: string | undefined;
  BLOCK_NUMBER_START: number | undefined;
  BLOCKS_FETCH_AMOUNT: number | undefined;
  CACHE_DIRECTORY: string | undefined;
  TIMESTAMP_PARALLEL_COUNT_FETCH: number | undefined;
  LOAD_FROM_CACHE: boolean | undefined;
}

interface Config {
  LOG_LEVEL: string;
  GRAPHQL_API_ENDPOINT: string;
  UNIX_TIMESTAMP_START_PERIOD: number;
  NUMBER_OF_POOLS: number;
  PG_HOST: string;
  PG_USER: string;
  PG_DATABASE: string;
  PG_PASSWORD: string;
  PG_PORT: number;
  RPC_PROVIDER: string;
  ETHERSCAN_ENDPOINT: string;
  ETHERSCAN_API_KEY: string;
  BLOCK_NUMBER_START: number;
  BLOCKS_FETCH_AMOUNT: number;
  CACHE_DIRECTORY: string;
  TIMESTAMP_PARALLEL_COUNT_FETCH: number;
  LOAD_FROM_CACHE: boolean;
}

// Loading process.env as ENV interface
export const getConfig = (): ENV => {
  return {
    LOG_LEVEL: process.env.LOG_LEVEL,
    GRAPHQL_API_ENDPOINT: process.env.GRAPHQL_API_ENDPOINT,
    UNIX_TIMESTAMP_START_PERIOD: process.env.UNIX_TIMESTAMP_START_PERIOD
      ? Number(process.env.UNIX_TIMESTAMP_START_PERIOD)
      : undefined,
    NUMBER_OF_POOLS: process.env.NUMBER_OF_POOLS ? Number(process.env.NUMBER_OF_POOLS) : undefined,
    PG_HOST: process.env.PG_HOST,
    PG_USER: process.env.PG_USER,
    PG_DATABASE: process.env.PG_DATABASE,
    PG_PASSWORD: process.env.PG_PASSWORD,
    PG_PORT: process.env.PG_PORT ? Number(process.env.PG_PORT) : undefined,
    RPC_PROVIDER: process.env.RPC_PROVIDER,
    ETHERSCAN_ENDPOINT: process.env.ETHERSCAN_ENDPOINT,
    ETHERSCAN_API_KEY: process.env.ETHERSCAN_API_KEY,
    BLOCK_NUMBER_START: process.env.BLOCK_NUMBER_START
      ? Number(process.env.BLOCK_NUMBER_START)
      : undefined,
    BLOCKS_FETCH_AMOUNT: process.env.BLOCKS_FETCH_AMOUNT
      ? Number(process.env.BLOCKS_FETCH_AMOUNT)
      : undefined,
    CACHE_DIRECTORY: process.env.CACHE_DIRECTORY,
    TIMESTAMP_PARALLEL_COUNT_FETCH: process.env.TIMESTAMP_PARALLEL_COUNT_FETCH
      ? Number(process.env.TIMESTAMP_PARALLEL_COUNT_FETCH)
      : undefined,
    LOAD_FROM_CACHE: process.env.LOAD_FROM_CACHE
      ? Boolean(
          process.env.LOAD_FROM_CACHE.toLocaleUpperCase() === 'TRUE' ||
            process.env.LOAD_FROM_CACHE.toLocaleUpperCase() === 'YES'
        )
      : undefined,
  };
};

// Throwing an error if any field was undefined. If all is good return it as Config
export const getSanitizedConfig = (config: ENV): Config => {
  for (const [key, value] of Object.entries(config)) {
    if (value === undefined) {
      throw new Error(`Missing key ${key} in .env`);
    }
  }
  return config as Config;
};

export default getSanitizedConfig(getConfig());
