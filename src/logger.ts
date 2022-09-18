import pino from 'pino';
import config from './config';

// Log level can be: silent | debug | info | warn | error | fatal
export const loggerOptions = {
  level: config.LOG_LEVEL || 'info',
};

export const logger = pino(loggerOptions);
