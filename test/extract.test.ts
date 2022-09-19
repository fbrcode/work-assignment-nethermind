import { topPoolsQuery, topPoolsVariables } from '../src/queries';
import { fetchGql, getTopPools, getPoolTicks, getPoolsHistory } from '../src/extract';
import fetch from 'node-fetch';

jest.mock('node-fetch');

// describe('dummy', () => {
//   it('dummy test', async () => {
//     expect(true).toBeTruthy();
//   });
// });

describe('extract tests', () => {
  beforeEach(() => {
    jest.clearAllMocks();
    jest.resetModules();
  });

  it('fetch general data response (mock)', async () => {
    const mockData = {
      data: {
        pools: [
          {
            id: '0x5777d92f208679db4b9778590fa3cab3ac9e2168',
            feeTier: '100',
            totalValueLockedUSD: '879507518.550132520685410617',
            tick: '-276324',
            token0: {
              id: '0x6b175474e89094c44da98b954eedeac495271d0f',
              symbol: 'DAI',
              name: 'Dai Stablecoin',
              decimals: '18',
            },
            token1: {
              id: '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48',
              symbol: 'USDC',
              name: 'USD Coin',
              decimals: '6',
            },
          },
        ],
      },
    };

    (fetch as jest.MockedFunction<any>).mockImplementation(() => {
      return new Promise((resolve) =>
        resolve({
          json: () => {
            return new Promise((resolve) => resolve(mockData));
          },
        })
      );
    });

    const responseData = {
      data: {
        pools: [
          {
            id: '0x5777d92f208679db4b9778590fa3cab3ac9e2168',
            feeTier: '100',
            totalValueLockedUSD: '879507518.550132520685410617',
            tick: '-276324',
            token0: {
              id: '0x6b175474e89094c44da98b954eedeac495271d0f',
              symbol: 'DAI',
              name: 'Dai Stablecoin',
              decimals: '18',
            },
            token1: {
              id: '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48',
              symbol: 'USDC',
              name: 'USD Coin',
              decimals: '6',
            },
          },
        ],
      },
    };

    const response = await fetchGql(topPoolsQuery, topPoolsVariables);
    expect(response).toEqual(responseData);
    expect(fetch).toBeCalledTimes(1);
  });

  it('fetch top pools (mock)', async () => {
    const mockData = {
      data: {
        pools: [
          {
            id: '0x5777d92f208679db4b9778590fa3cab3ac9e2168',
            feeTier: '100',
            totalValueLockedUSD: '879507518.550132520685410617',
            tick: '-276324',
            token0: {
              id: '0x6b175474e89094c44da98b954eedeac495271d0f',
              symbol: 'DAI',
              name: 'Dai Stablecoin',
              decimals: '18',
            },
            token1: {
              id: '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48',
              symbol: 'USDC',
              name: 'USD Coin',
              decimals: '6',
            },
          },
        ],
      },
    };

    (fetch as jest.MockedFunction<any>).mockImplementation(() => {
      return new Promise((resolve) =>
        resolve({
          json: () => {
            return new Promise((resolve) => resolve(mockData));
          },
        })
      );
    });

    const responseData = [
      {
        id: '0x5777d92f208679db4b9778590fa3cab3ac9e2168',
        feeTier: '100',
        totalValueLockedUSD: '879507518.550132520685410617',
        tick: '-276324',
        token0: {
          id: '0x6b175474e89094c44da98b954eedeac495271d0f',
          symbol: 'DAI',
          name: 'Dai Stablecoin',
          decimals: '18',
        },
        token1: {
          id: '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48',
          symbol: 'USDC',
          name: 'USD Coin',
          decimals: '6',
        },
      },
    ];

    const response = await getTopPools();
    expect(response).toEqual(responseData);
    expect(fetch).toBeCalledTimes(1);
  });

  // TODO: pending checking multiple fetches to exist while loop
  it('fetch pool ticks (mock)', async () => {
    const mockData1 = {
      data: {
        ticks: [
          {
            id: '0x5777d92f208679db4b9778590fa3cab3ac9e2168#-254218',
            tickIdx: '-254218',
            price0: '0.000000000009120203534308227991484808095711512',
            price1: '109646675782.8612978573535762324127',
          },
          {
            id: '0x5777d92f208679db4b9778590fa3cab3ac9e2168#-262460',
            tickIdx: '-262460',
            price0: '0.000000000004000155872351152427378106265698406',
            price1: '249990258357.6661469547918695185509',
          },
        ],
      },
    };

    const mockData2 = {
      data: {
        ticks: [],
      },
    };

    (fetch as jest.MockedFunction<any>).mockImplementation(() => {
      return new Promise((resolve) =>
        resolve({
          json: () => {
            return new Promise((resolve) => resolve(mockData2));
          },
        })
      );
    });

    const responseData1 = [
      {
        id: '0x5777d92f208679db4b9778590fa3cab3ac9e2168#-254218',
        tickIdx: '-254218',
        price0: '0.000000000009120203534308227991484808095711512',
        price1: '109646675782.8612978573535762324127',
      },
      {
        id: '0x5777d92f208679db4b9778590fa3cab3ac9e2168#-262460',
        tickIdx: '-262460',
        price0: '0.000000000004000155872351152427378106265698406',
        price1: '249990258357.6661469547918695185509',
      },
    ];

    const responseData2 = [];

    const response = await getPoolTicks('mockPoolId');
    expect(response).toEqual(responseData2);
    expect(fetch).toBeCalledTimes(1);
  });

  // TODO: pending checking multiple fetches to exist while loop
  it('fetch pool history (mock)', async () => {
    const mockData1 = {
      data: {
        poolDayDatas: [
          {
            id: '0x5777d92f208679db4b9778590fa3cab3ac9e2168-19158',
            date: 1655251200,
            tick: '-276324',
            volumeToken0: '60816134.12324959225916437',
            volumeToken1: '60817751.151382',
            token0Price: '0.9999560139000686294111437954192768',
            token1Price: '1.000043988034793464798805266060763',
            volumeUSD: '60813964.50080633117839222191809608',
            tvlUSD: '640192277.383639423664612615',
            txCount: '1349',
            sqrtPrice: '79229905040686621459013',
            liquidity: '3193895844173394320648765',
            feesUSD: '6081.396450080633117839222191809608',
          },
          {
            id: '0x5777d92f208679db4b9778590fa3cab3ac9e2168-19159',
            date: 1655337600,
            tick: '-276324',
            volumeToken0: '26273666.436442048473840387',
            volumeToken1: '26274495.989439',
            token0Price: '0.9999578037076141283332508453189938',
            token1Price: '1.000042198072988097592868465375589',
            volumeUSD: '26272568.41212761049031819075852243',
            tvlUSD: '681790497.988682253309955001',
            txCount: '835',
            sqrtPrice: '79229834134521981600589',
            liquidity: '3401894300457591194958746',
            feesUSD: '2627.256841212761049031819075852243',
          },
        ],
      },
    };

    const mockData2 = {
      data: {
        poolDayDatas: [],
      },
    };

    (fetch as jest.MockedFunction<any>).mockImplementation(() => {
      return new Promise((resolve) =>
        resolve({
          json: () => {
            return new Promise((resolve) => resolve(mockData2));
          },
        })
      );
    });

    const responseData1 = [
      {
        id: '0x5777d92f208679db4b9778590fa3cab3ac9e2168-19158',
        date: 1655251200,
        tick: '-276324',
        volumeToken0: '60816134.12324959225916437',
        volumeToken1: '60817751.151382',
        token0Price: '0.9999560139000686294111437954192768',
        token1Price: '1.000043988034793464798805266060763',
        volumeUSD: '60813964.50080633117839222191809608',
        tvlUSD: '640192277.383639423664612615',
        txCount: '1349',
        sqrtPrice: '79229905040686621459013',
        liquidity: '3193895844173394320648765',
        feesUSD: '6081.396450080633117839222191809608',
      },
      {
        id: '0x5777d92f208679db4b9778590fa3cab3ac9e2168-19159',
        date: 1655337600,
        tick: '-276324',
        volumeToken0: '26273666.436442048473840387',
        volumeToken1: '26274495.989439',
        token0Price: '0.9999578037076141283332508453189938',
        token1Price: '1.000042198072988097592868465375589',
        volumeUSD: '26272568.41212761049031819075852243',
        tvlUSD: '681790497.988682253309955001',
        txCount: '835',
        sqrtPrice: '79229834134521981600589',
        liquidity: '3401894300457591194958746',
        feesUSD: '2627.256841212761049031819075852243',
      },
    ];

    const responseData2 = [];

    const response = await getPoolsHistory('mockPoolId');
    expect(response).toEqual(responseData2);
    expect(fetch).toBeCalledTimes(1);
  });

  // TODO: pending test for fetch rejects
});
