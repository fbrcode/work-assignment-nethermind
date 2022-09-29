import { ethers } from 'ethers';
import { mkdirSync, existsSync, rmSync, writeFileSync, readFileSync } from 'fs';

function unixDateTimeConverter(unix_timestamp: number): string {
  return new Date(unix_timestamp * 1000).toISOString();
}

function humanNumber(value: number) {
  return value.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
}

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
  logFile = `${directory}/${logFile}`;
  dropFile(logFile);
  const file = typeof data === 'string' ? data : JSON.stringify(data, null, 2);
  writeFileSync(logFile, file, {
    encoding: 'utf8',
    flag: 'a+',
    mode: 0o666,
  });
  console.log(`> saved file: ${logFile}`);
}

const RPC_PROVIDER = 'https://mainnet.infura.io/v3/7e4dca97aa4c44899a59fdb27c374fae';

async function main() {
  const provider = new ethers.providers.JsonRpcProvider(RPC_PROVIDER);
  console.log(`RPC Provider: ${RPC_PROVIDER}`);

  const network = await provider.getNetwork();
  console.log(`Chain id: ${network.chainId}`);

  // const theBlock = 'latest';
  const theBlock = 15301758;
  const blockData = await provider.getBlock(theBlock);
  console.log(`Latest block number: ${humanNumber(blockData.number)}`);
  const latestTimestamp = blockData.timestamp;
  console.log(`Latest unix timestamp: ${latestTimestamp}`);
  console.log(`Latest date/time: ${unixDateTimeConverter(latestTimestamp)}`);
  console.log(`All block data...`);
  // console.log(blockData);
  writeFile('cache', '_blockData.json', blockData);

  // block swap events
  const contractAddress = '0x6c6bc977e13df9b0de53b251522280bb72383700';
  const contractABI = [
    'function factory() external view returns (address)',
    'function token0() external view returns (address)',
    'function token1() external view returns (address)',
    'function fee() external view returns (uint24)',
    'function tickSpacing() external view returns (int24)',
    'function maxLiquidityPerTick() external view returns (uint128)',
    'event Initialize(uint160 sqrtPriceX96, int24 tick)',
    'event Swap(address indexed sender,address indexed recipient,int256 amount0,int256 amount1,uint160 sqrtPriceX96,uint128 liquidity,int24 tick)',
  ];
  const contract = new ethers.Contract(contractAddress, contractABI, provider);
  const filterEvent = contract.filters.Swap(null);
  console.log(`Filter event topics...`);
  console.log(filterEvent);
  console.log(`All event data for filter topics...`);
  const eventData = await contract.queryFilter(filterEvent, blockData.number, blockData.number);
  // console.log(eventData);
  writeFile('cache', '_eventData.json', eventData);
}

main();
