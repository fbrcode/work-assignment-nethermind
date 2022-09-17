select
	t.pool_id,
	t.tick_index,
	p.token0_symbol,
	p.token0_decimals,
	t.constant_price0 as DAI_price,
	power(10, p.token0_decimals)::bigint as DAI_power,
	p.token1_symbol,
	p.token1_decimals,
	t.constant_price1 as USDC_price,
	power(10, p.token1_decimals)::bigint as USDC_power
from univ3.pool_ticks t
inner join univ3.pools_top p on p.id = t.pool_id 
where t.pool_id = '0x5777d92f208679db4b9778590fa3cab3ac9e2168'
and t.tick_index = '-276324';

/*

DAI - 18 decimals
 123456789012345678
1000000000000000000 = WEI -> 1 ETH -> 1 DAI

USDC - 6 decimals
 123456
1000000 - 1 USDC




pool_id                                   |tick_id|count|
------------------------------------------+-------+-----+
0x5777d92f208679db4b9778590fa3cab3ac9e2168|-276324|   94|

Name           |Value                                             |
---------------+--------------------------------------------------+
id             |0x5777d92f208679db4b9778590fa3cab3ac9e2168#-276324|
pool_id        |0x5777d92f208679db4b9778590fa3cab3ac9e2168        |
tick_index     |-276324                                           |
constant_price0|0.000000000001000002643830950670501834410613775   |
constant_price1|999997356176.0391531139768636809218               |
created_at     |2022-09-16 13:50:13.616 -0300                     |
*/
 