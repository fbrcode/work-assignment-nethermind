import fetch from 'cross-fetch';
import { ApolloClient, InMemoryCache, gql, HttpLink } from '@apollo/client';
// import { Pool } from '../.graphclient';

export async function getPools() {
  const THE_GRAPH_API_ENDPOINT = 'https://api.thegraph.com/subgraphs/name/uniswap/uniswap-v3';

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
        #        ticks {
        #          id
        #          tickIdx
        #          liquidityGross
        #          liquidityNet
        #          price0
        #          price1
        #          createdAtTimestamp
        #          createdAtBlockNumber
        #        }
      }
    }
  `;

  const client = new ApolloClient({
    link: new HttpLink({ uri: THE_GRAPH_API_ENDPOINT, fetch }),
    cache: new InMemoryCache(),
  });

  return await client.query({ query: top3PoolsQuery });
}
