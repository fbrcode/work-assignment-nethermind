import { PoolGroup } from '../src/types';
import * as index from '../src/index';
import * as extract from '../src/extract';
import * as database from '../src/database';

describe('index flow', () => {
  beforeEach(() => {
    jest.clearAllMocks();
    jest.resetModules();
  });

  it('main successful', async () => {
    const mockedTopPools: PoolGroup = [
      {
        id: 'x0123',
        feeTier: 100,
        totalValueLockedUSD: 123456,
        tick: -2222,
        token0: {
          id: 'x01',
          symbol: 'ABC',
          name: 'token A',
          decimals: 6,
        },
        token1: {
          id: 'x02',
          symbol: 'XYZ',
          name: 'token X',
          decimals: 18,
        },
      },
    ];

    const clearDBSpy = jest.spyOn(database, 'clearDbData').mockImplementation();

    const fetchTopPoolsSpy = jest
      .spyOn(extract, 'getTopPools')
      .mockImplementation()
      .mockResolvedValueOnce(mockedTopPools);
    const addPoolsDbSpy = jest
      .spyOn(database, 'addPoolsDb')
      .mockImplementation()
      .mockResolvedValueOnce(true);

    const fetchPoolTickSpy = jest.spyOn(extract, 'getPoolTicks').mockImplementation();
    const addPoolTicksDbSpy = jest.spyOn(database, 'addPoolTicksDb').mockImplementation();

    const fetchPoolHistorySpy = jest.spyOn(extract, 'getPoolsHistory').mockImplementation();
    const addPoolHistoryDbSpy = jest.spyOn(database, 'addPoolHistoryDb').mockImplementation();

    await index.main();
    expect(clearDBSpy).toBeCalled();
    expect(fetchTopPoolsSpy).toBeCalled();
    expect(addPoolsDbSpy).toBeCalled();
    expect(fetchPoolTickSpy).toBeCalled();
    expect(fetchPoolHistorySpy).toBeCalled();
    expect(addPoolTicksDbSpy).toBeCalled();
    expect(addPoolHistoryDbSpy).toBeCalled();
  });

  it('main fetch failure', async () => {
    jest.spyOn(extract, 'getTopPools').mockImplementation().mockRejectedValueOnce('fetch failure');

    try {
      await index.main();
    } catch (e) {
      expect(e.toString()).toEqual('fetch failure');
    }
  });

  it('main database failure', async () => {
    jest.spyOn(database, 'addPoolsDb').mockImplementation().mockRejectedValueOnce('db failure');

    try {
      await index.main();
    } catch (e) {
      expect(e.toString()).toEqual('db failure');
    }
  });
});
