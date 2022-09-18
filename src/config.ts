import path from 'path';
import dotenv from 'dotenv';

// Parsing the env file.
dotenv.config({ path: path.resolve(process.cwd(), '.env') });

interface ENV {
  LOG_LEVEL: string | undefined;
  GRAPHQL_API_ENDPOINT: string | undefined;
  UNIX_TIMESTAMP_START_PERIOD: number | undefined;
}

interface Config {
  LOG_LEVEL: string;
  GRAPHQL_API_ENDPOINT: string;
  UNIX_TIMESTAMP_START_PERIOD: number;
}

// Loading process.env as ENV interface
const getConfig = (): ENV => {
  return {
    LOG_LEVEL: process.env.LOG_LEVEL,
    GRAPHQL_API_ENDPOINT: process.env.GRAPHQL_API_ENDPOINT,
    UNIX_TIMESTAMP_START_PERIOD: process.env.UNIX_TIMESTAMP_START_PERIOD
      ? Number(process.env.UNIX_TIMESTAMP_START_PERIOD)
      : undefined,
  };
};

// Throwing an error if any field was undefined. If all is good return it as Config
const getSanitizedConfig = (config: ENV): Config => {
  for (const [key, value] of Object.entries(config)) {
    if (value === undefined) {
      throw new Error(`Missing key ${key} in .env`);
    }
  }
  return config as Config;
};

const config = getConfig();

const sanitizedConfig = getSanitizedConfig(config);

export default sanitizedConfig;
