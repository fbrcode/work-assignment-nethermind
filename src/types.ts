type Token = {
  id: string;
  symbol: string;
  name: string;
  decimals: number;
};

type Pool = {
  id: string;
  feeTier: number;
  totalValueLockedUSD: number;
  tick: number;
  token0: Token;
  token1: Token;
};

export type PoolGroup = Pool[];

export type PoolData = {
  data: {
    pools: PoolGroup;
  };
};

// const x: PoolGroup = [
//   {
//     id: 'test',
//     feeTier: 100,
//     totalValueLockedUSD: 123456,
//     tick: -2222,
//     token0: {
//       id: 'x01',
//       symbol: 'ABC',
//       name: 'token A',
//       decimals: 6,
//     },
//     token1: {
//       id: 'x02',
//       symbol: 'XYZ',
//       name: 'token X',
//       decimals: 18,
//     },
//   },
// ];
// console.log(x);

type Tick = {
  id: string;
  tickIdx: number;
  price0: number;
  price1: number;
};

export type TickGroup = Tick[];

export type TickPoolData = {
  data: {
    ticks: TickGroup;
  };
};

// const y: TickGroup = [
//   {
//     id: 'test',
//     tickIdx: -2222,
//     price0: 0.9,
//     price1: 1.1,
//   },
// ];
// console.log(y);

type PoolDayHistory = {
  id: string;
  date: number;
  tick: number;
  volumeToken0: number;
  volumeToken1: number;
  token0Price: number;
  token1Price: number;
  volumeUSD: number;
  tvlUSD: number;
  txCount: number;
  sqrtPrice: number;
  liquidity: number;
  feesUSD: number;
};

export type PoolDayHistoryGroup = PoolDayHistory[];

export type PoolDayHistoryData = {
  data: {
    poolDayDatas: PoolDayHistoryGroup;
  };
};

// const z: PoolDayHistoryGroup = [
//   {
//     id: '',
//     date: 1,
//     tick: 1,
//     volumeToken0: 1,
//     volumeToken1: 1,
//     token0Price: 1,
//     token1Price: 1,
//     volumeUSD: 1,
//     tvlUSD: 1,
//     txCount: 1,
//     sqrtPrice: 1,
//     liquidity: 1,
//     feesUSD: 1,
//   },
// ];
// console.log(z);
