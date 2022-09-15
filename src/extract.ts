import fetch from 'cross-fetch';
import { ApolloClient, InMemoryCache, gql, HttpLink } from '@apollo/client';

function getGraphQLClient() {
  const THE_GRAPH_API_ENDPOINT = 'https://api.thegraph.com/subgraphs/name/uniswap/uniswap-v3';
  return new ApolloClient({
    link: new HttpLink({ uri: THE_GRAPH_API_ENDPOINT, fetch }),
    cache: new InMemoryCache(),
  });
}

const client = getGraphQLClient();

const unixStartTimestamp = 1655164800; // Jul 14, 2022 (3 months)

export async function getPools() {
  const top3PoolsQuery = gql`
    query {
      pools(orderBy: totalValueLockedUSD, orderDirection: desc, first: 3, skip: 1) {
        id
        feeTier
        totalValueLockedUSD
        tick
        token0 {
          id
          symbol
          name
        }
        token1 {
          id
          symbol
          name
        }
      }
    }
  `;
  const res = await client.query({ query: top3PoolsQuery });
  const resContent = res.data.pools;
  return resContent;
}

export async function getPoolsHistory(poolId: string) {
  let resContent: any[] = [];
  let poolDayDatas: any[] = [];
  let poolsHistoryQuery: any;
  let skipPagination = 0;

  do {
    poolsHistoryQuery = gql`
      query {
        poolDayDatas(
          skip: ${skipPagination}
          orderBy: date
          orderDirection: asc
          where: { 
            pool: "${poolId}", 
            date_gt: ${unixStartTimestamp} 
          }
        ) {
          id
          date
          tick
          volumeToken0
          volumeToken1
          token0Price
          token1Price
          volumeUSD
          tvlUSD
          txCount
          sqrtPrice
          liquidity
          feesUSD
        }
      }
    `;

    const res = await client.query({ query: poolsHistoryQuery });
    resContent = res.data.poolDayDatas;
    if (resContent.length === 0) {
      return poolDayDatas;
    }
    poolDayDatas = poolDayDatas.concat(resContent);
    skipPagination += 100;
  } while (resContent.length > 0);

  return poolDayDatas;
}
