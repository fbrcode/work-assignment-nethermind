/*

pool 01 history
------------------------------------------+----------+----------+----------+------------------------------------+-----------------------------------+
pool_id                                   |unix_date |hist_date |tick_index|dai_price                           |usdc_price                         |
------------------------------------------+----------+----------+----------+------------------------------------+-----------------------------------+
...
0x5777d92f208679db4b9778590fa3cab3ac9e2168|1663372800|2022-09-16|   -276324|0.9999842493966250268857065054381479|1.000015750851460387284969671242668|
------------------------------------------+----------+----------+----------+------------------------------------+-----------------------------------+

*/

select
	t.pool_id,
	t.tick_index,
	t.constant_price0,
	trunc(t.constant_price0 * 1000000000000, 6) as p0_DAI_100,
	t.constant_price1,
	trunc(t.constant_price1 / 1000000000000, 6) as p1_USDC_100
from univ3.pool_ticks t
where t.pool_id = '0x5777d92f208679db4b9778590fa3cab3ac9e2168'
and t.tick_index in ('-276324')
order by 1,2;


/*

pool_id                                   |tick_index|constant_price0                                |p0_dai_100|constant_price1                    |p1_usdc_100|
------------------------------------------+----------+-----------------------------------------------+----------+-----------------------------------+-----------+
0x5777d92f208679db4b9778590fa3cab3ac9e2168|   -276324|0.000000000001000002643830950670501834410613775|  1.000002|999997356176.0391531139768636809218|   0.999997|

*/
