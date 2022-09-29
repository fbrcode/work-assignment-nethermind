import { ethers } from 'ethers';
import config from './config';

function unixDateTimeConverter(unix_timestamp: number): string {
  return new Date(unix_timestamp * 1000).toISOString();
}

function humanNumber(value: number) {
  return value.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
}

async function main() {
  const provider = new ethers.providers.JsonRpcProvider(config.RPC_PROVIDER);
  console.log(`RPC Provider: ${config.RPC_PROVIDER}`);

  const network = await provider.getNetwork();
  console.log(`Chain id: ${network.chainId}`);

  const latestBlock = await provider.getBlock('latest');
  console.log(`Latest block number: ${humanNumber(latestBlock.number)}`);

  const latestTimestamp = latestBlock.timestamp;
  console.log(`Latest unix timestamp: ${latestTimestamp}`);
  console.log(`Latest date/time: ${unixDateTimeConverter(latestTimestamp)}`);
}

main();
