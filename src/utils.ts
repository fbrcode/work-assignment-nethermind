import { mkdirSync, existsSync, rmSync, writeFileSync, readFileSync } from 'fs';
import { logger } from './logger';

function createDirectory(directory: string) {
  if (!existsSync(directory)) {
    mkdirSync(directory, { recursive: true });
  }
}

function dropFile(logFile: string) {
  if (existsSync(logFile)) {
    rmSync(logFile);
  }
}

export function writeFile(directory: string, logFile: string, data: object | string) {
  createDirectory(directory);
  dropFile(logFile);
  const file = typeof data === 'string' ? data : JSON.stringify(data, null, 2);
  writeFileSync(logFile, file, {
    encoding: 'utf8',
    flag: 'a+',
    mode: 0o666,
  });
  logger.info(`> saved file: ${logFile}`);
}

export function readFile(logFile: string) {
  return readFileSync(logFile, { encoding: 'utf8' });
}

export function unixDateTimeConverter(unix_timestamp: number): string {
  return new Date(unix_timestamp * 1000).toISOString();
}

export function humanNumber(value: number) {
  return value.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
}
