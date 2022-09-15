import { getPools } from './extract';

// type PoolType

async function main() {
  console.log(`main test...`);
  const res = await getPools();
  for (const pool of res.data.pools) {
    console.log('Pool Id: ' + pool.id);
    console.log('Pool Fee: ' + pool.feeTier);
    console.log('Pool Locked Value USD: ' + pool.totalValueLockedUSD);
    console.log('Pool Tokens: ' + pool.token0.symbol + ' <--> ' + pool.token1.symbol);
    console.log('---------');
  }
}

main();
