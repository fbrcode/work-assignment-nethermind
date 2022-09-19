import { getDbClient } from './database';
import { logger } from './logger';

export async function getTables() {
  const client = getDbClient();
  await client.connect();
  try {
    const sql = `select tablename from pg_catalog.pg_tables where schemaname = 'univ3'`;
    const result = await client.query(sql);
    logger.info(result.rows);
    client.end();
    return { 'row-count': result.rowCount };
  } catch (e) {
    logger.error(e.stack);
    client.end();
    return { message: e };
  }
}
