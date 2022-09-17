select
	id,
	id_tokens,
	fee,
	current_tvl_usd,
	--current_tick,
	token0_id,
	token0_symbol,
	token0_name,
	token1_id,
	token1_symbol,
	token1_name
from univ3.pools_top
order by current_tvl_usd desc;
--where id = '0x5777d92f208679db4b9778590fa3cab3ac9e2168';

/*

id                                        |id_tokens|fee |current_tvl_usd                    |token0_id                                 |token0_symbol|token0_name   |token1_id                                 |token1_symbol|token1_name  |
------------------------------------------+---------+----+-----------------------------------+------------------------------------------+-------------+--------------+------------------------------------------+-------------+-------------+
0x5777d92f208679db4b9778590fa3cab3ac9e2168|DAI/USDC | 100|       879528422.748528070408883563|0x6b175474e89094c44da98b954eedeac495271d0f|DAI          |Dai Stablecoin|0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48|USDC         |USD Coin     |
0x6c6bc977e13df9b0de53b251522280bb72383700|DAI/USDC | 500|418347105.1086680814304486220000001|0x6b175474e89094c44da98b954eedeac495271d0f|DAI          |Dai Stablecoin|0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48|USDC         |USD Coin     |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|USDC/WETH|3000|305645578.7106206612766305731329115|0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48|USDC         |USD Coin      |0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2|WETH         |Wrapped Ether|

*/