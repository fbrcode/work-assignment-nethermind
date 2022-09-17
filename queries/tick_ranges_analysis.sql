select
	pool_id,
	tick_index,
	--substring(tick_index::text,0,length(tick_index::text)-2) as base_tick, 
	--concat(substring(tick_index::text,length(tick_index::text)-2,2)::text,'0')::text as base_down,
	--((concat(substring(tick_index::text,length(tick_index::text)-2,2)::text,'0')::int)+10)::text as base_up,
	concat(substring(tick_index::text,0,length(tick_index::text)-2),concat(substring(tick_index::text,length(tick_index::text)-2,2)::text,'0')::text)::int as lower_tick,
	concat(substring(tick_index::text,0,length(tick_index::text)-2),((concat(substring(tick_index::text,length(tick_index::text)-2,2)::text,'0')::int)+10)::text)::int as upper_tick,
	count(*)
from univ3.pool_history
--where pool_id = '0x6c6bc977e13df9b0de53b251522280bb72383700'
group by 
	pool_id,
	tick_index
--having count(*) > 1
order by 1,2;

/*

------------------------------------------+----------+----------+----------+-----+
pool_id                                   |tick_index|lower_tick|upper_tick|count|
------------------------------------------+----------+----------+----------+-----+
0x5777d92f208679db4b9778590fa3cab3ac9e2168|   -276324|   -276320|   -276330|   95|
------------------------------------------+----------+----------+----------+-----+
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276326|   -276320|   -276330|    4|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276325|   -276320|   -276330|   53|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276324|   -276320|   -276330|   38|
------------------------------------------+----------+----------+----------+-----+
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    201973|    201970|    201980|    2|
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    202699|    202690|    202700|    2|
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    205487|    205480|    205490|    2|
...
------------------------------------------+----------+----------+----------+-----+

*/

with pool_history_ticks_agg as (
select
	pool_id,
	tick_index,
	concat(substring(tick_index::text,0,length(tick_index::text)-2),concat(substring(tick_index::text,length(tick_index::text)-2,2)::text,'0')::text)::int as lower_tick,
	concat(substring(tick_index::text,0,length(tick_index::text)-2),((concat(substring(tick_index::text,length(tick_index::text)-2,2)::text,'0')::int)+10)::text)::int as upper_tick,
	count(*) as tick_hits_count
from univ3.pool_history
--where pool_id = '0x5777d92f208679db4b9778590fa3cab3ac9e2168'
--where pool_id = '0x6c6bc977e13df9b0de53b251522280bb72383700'
where pool_id = '0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8'
group by 
	pool_id,
	tick_index
--having count(*) > 1
) 
select
	a.pool_id,
	a.tick_index,
	a.lower_tick,
    a.upper_tick,
    a.tick_hits_count,
    --t.id,
    t.tick_index,
    --trunc(t.constant_price0 * 1000000000000, 6) as tk0_price_rng,
    --trunc(t.constant_price1 / 1000000000000, 6) as tk1_price_rng
	trunc(t.constant_price0, 6) as p0_USDC_3000,
	trunc(t.constant_price1, 13) as p1_WETH_3000
from pool_history_ticks_agg a
left join univ3.pool_ticks t 
	on t.pool_id = a.pool_id
	and (
			t.tick_index = a.tick_index
--		or 	t.tick_index = a.lower_tick
--		or 	t.tick_index = a.upper_tick
	)
order by 1,2;

/*
POOL 01 (has exact tick index match)
------------------------------------------+----------+----------+----------+---------------+----------+-------------+-------------+
pool_id                                   |tick_index|lower_tick|upper_tick|tick_hits_count|tick_index|tk0_price_rng|tk1_price_rng|
------------------------------------------+----------+----------+----------+---------------+----------+-------------+-------------+
0x5777d92f208679db4b9778590fa3cab3ac9e2168|   -276324|   -276320|   -276330|             95|   -276320|     1.000402|     0.999597|
0x5777d92f208679db4b9778590fa3cab3ac9e2168|   -276324|   -276320|   -276330|             95|   -276324|     1.000002|     0.999997|
0x5777d92f208679db4b9778590fa3cab3ac9e2168|   -276324|   -276320|   -276330|             95|   -276330|     0.999402|     1.000597|
------------------------------------------+----------+----------+----------+---------------+----------+-------------+-------------+

POOL 02 (do not have exact tick index match, needs lower and upper ranges to match)
------------------------------------------+----------+-------------------------------+-----------+------------+
pool_id                                   |tick_index|p0_dai_500                     |p1_usdc_500|days_in_tick|
------------------------------------------+----------+-------------------------------+-----------+------------+
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276580|                       0.974728|   1.025926|            |
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276570|                       0.975703|   1.024901|            |
...
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276350|                       0.997406|   1.002600|            |
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276340|                       0.998403|   1.001598|            |
------------------------------------------+----------+-------------------------------+-----------+------------+
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276330|                       0.999402|   1.000597|            | <<<
------------------------------------------+----------+-------------------------------+-----------+------------+
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276320|                       1.000402|   0.999597|            | <<<
------------------------------------------+----------+-------------------------------+-----------+------------+
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276310|                       1.001403|   0.998598|            |
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276300|                       1.002405|   0.997600|            |
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276290|                       1.003408|   0.996603|            |
...
------------------------------------------+----------+-------------------------------+-----------+------------+

------------------------------------------+----------+----------+----------+---------------+----------+-------------+-------------+
pool_id                                   |tick_index|lower_tick|upper_tick|tick_hits_count|tick_index|tk0_price_rng|tk1_price_rng|
------------------------------------------+----------+----------+----------+---------------+----------+-------------+-------------+
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276326|   -276320|   -276330|              4|   -276320|     1.000402|     0.999597|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276326|   -276320|   -276330|              4|   -276330|     0.999402|     1.000597|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276325|   -276320|   -276330|             53|   -276320|     1.000402|     0.999597|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276325|   -276320|   -276330|             53|   -276330|     0.999402|     1.000597|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276324|   -276320|   -276330|             38|   -276320|     1.000402|     0.999597|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276324|   -276320|   -276330|             38|   -276330|     0.999402|     1.000597|
------------------------------------------+----------+----------+----------+---------------+----------+-------------+-------------+

POOL 03 (some have tick match and some do not)
------------------------------------------+----------+----------+----------+---------------+----------+----------------+---------------+
pool_id                                   |tick_index|lower_tick|upper_tick|tick_hits_count|tick_index|p0_usdc_3000    |p1_weth_3000   |
------------------------------------------+----------+----------+----------+---------------+----------+----------------+---------------+
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    200405|    200400|    200410|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    200518|    200510|    200520|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    200643|    200640|    200650|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    200844|    200840|    200850|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    200939|    200930|    200940|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    200955|    200950|    200960|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    201084|    201080|     20190|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    201091|    201090|    201100|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    201191|    201190|    201200|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    201482|    201480|    201490|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    201506|    201500|    201510|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    201574|    201570|    201580|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    201727|    201720|    201730|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    201796|    201790|    201800|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    201798|    201790|    201800|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    201838|    201830|    201840|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    201865|    201860|    201870|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    201903|    201900|    201910|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    201959|    201950|    201960|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    201973|    201970|    201980|              2|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    201978|    201970|    201980|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    202033|    202030|     20240|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    202136|    202130|    202140|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    202190|    202190|    202200|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    202300|    202300|    202310|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    202329|    202320|    202330|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    202333|    202330|    202340|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    202340|    202340|    202350|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    202347|    202340|    202350|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    202368|    202360|    202370|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    202391|    202390|    202400|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    202412|    202410|    202420|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    202421|    202420|    202430|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    202431|    202430|    202440|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    202483|    202480|    202490|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    202492|    202490|    202500|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    202556|    202550|    202560|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    202627|    202620|    202630|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    202630|    202630|    202640|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    202691|    202690|    202700|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    202696|    202690|    202700|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    202699|    202690|    202700|              2|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    202709|    202700|    202710|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    202784|    202780|    202790|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    202826|    202820|    202830|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    202828|    202820|    202830|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    202856|    202850|    202860|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    202860|    202860|    202870|              1|    202860|645145072.203638|0.0000000015500|
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    202920|    202920|    202930|              1|    202920|649027383.812997|0.0000000015407|
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    202948|    202940|    202950|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    203032|    203030|     20340|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    203045|    203040|     20350|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    203164|    203160|    203170|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    203229|    203220|    203230|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    203382|    203380|    203390|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    203530|    203530|    203540|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    203577|    203570|    203580|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    203584|    203580|    203590|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    203663|    203660|    203670|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    203666|    203660|    203670|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    204201|    204200|    204210|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    204328|    204320|    204330|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    205062|    205060|     20570|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    205104|    205100|    205110|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    205136|    205130|    205140|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    205145|    205140|    205150|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    205207|    205200|    205210|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    205284|    205280|    205290|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    205302|    205300|    205310|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    205437|    205430|    205440|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    205487|    205480|    205490|              2|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    205514|    205510|    205520|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    205705|    205700|    205710|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    205827|    205820|    205830|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    205891|    205890|    205900|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    205932|    205930|    205940|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    206004|    206000|     20610|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    206018|    206010|     20620|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    206063|    206060|     20670|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    206068|    206060|     20670|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    206163|    206160|    206170|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    206308|    206300|    206310|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    206326|    206320|    206330|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    206414|    206410|    206420|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    206545|    206540|    206550|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    206578|    206570|    206580|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    206583|    206580|    206590|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    206625|    206620|    206630|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    206689|    206680|    206690|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    206775|    206770|    206780|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    206873|    206870|    206880|              1|          |                |               |
0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8|    207292|    207290|    207300|              1|          |                |               |
------------------------------------------+----------+----------+----------+---------------+----------+----------------+---------------+

*/

