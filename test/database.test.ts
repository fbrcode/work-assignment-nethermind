import { Client } from 'pg';
import { getTables } from '../src/data-read';

jest.mock('pg', () => {
  const mClient = {
    connect: jest.fn(),
    query: jest.fn(),
    end: jest.fn(),
  };
  return { Client: jest.fn(() => mClient) };
});

describe('postgres', () => {
  let client;
  beforeEach(() => {
    client = new Client();
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('database success', async () => {
    client.query.mockResolvedValueOnce({ rows: [], rowCount: 0 });
    await getTables();
    expect(client.connect).toBeCalledTimes(1);
    expect(client.query).toBeCalledWith(
      `select tablename from pg_catalog.pg_tables where schemaname = 'univ3'`
    );
    expect(client.end).toBeCalledTimes(1);
  });

  it('database failure', async () => {
    const mError = new Error('dead lock');
    client.query.mockRejectedValueOnce(mError);
    await getTables();
    expect(client.connect).toBeCalledTimes(1);
    expect(client.query).toBeCalledWith(
      `select tablename from pg_catalog.pg_tables where schemaname = 'univ3'`
    );
    expect(client.end).toBeCalledTimes(1);
  });
});
