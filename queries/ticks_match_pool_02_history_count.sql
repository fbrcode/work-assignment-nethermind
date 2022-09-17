select
	t.pool_id,
	t.tick_index,
	trunc(t.constant_price0 * 1000000000000, 6) as p0_DAI_500, -- 1,000,000,000,000
	trunc(t.constant_price1 / 1000000000000, 6) as p1_USDC_500--,
	--h.days_in_tick
from univ3.pool_ticks t
--left join (
--	select
--		pool_id,
--		tick_index,
		--substring(tick_index::text,0,length(tick_index::text)-2) as base_tick, 
		--concat(substring(tick_index::text,length(tick_index::text)-2,2)::text,'0')::text as base_down,
		--((concat(substring(tick_index::text,length(tick_index::text)-2,2)::text,'0')::int)+10)::text as base_up,
--		concat(substring(tick_index::text,0,length(tick_index::text)-2),concat(substring(tick_index::text,length(tick_index::text)-2,2)::text,'0')::text)::int as lower_tick,
--		concat(substring(tick_index::text,0,length(tick_index::text)-2),((concat(substring(tick_index::text,length(tick_index::text)-2,2)::text,'0')::int)+10)::text)::int as upper_tick,
--		count(*) as days_in_tick
--	from univ3.pool_history
	--where pool_id = '0x6c6bc977e13df9b0de53b251522280bb72383700'
--	group by pool_id, tick_index
--	having count(*) > 1
--) h on h.pool_id = t.pool_id and (t.tick_index = h.tick_index or (t.tick_index >= h.lower_tick or t.tick_index <= h.upper_tick)) 
where t.pool_id = '0x6c6bc977e13df9b0de53b251522280bb72383700'
and t.tick_index not in ('-887270', '887270', '276220')
order by 1,2;

/*
276320

pool_id                                   |tick_index|days_in_tick|
------------------------------------------+----------+------------+
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276326|           4|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276325|          53|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276324|          38|

------------------------------------------+----------+--------------------+-------------+
pool_id                                   |tick_index|p0_dai_500          |p1_usdc_500  |
------------------------------------------+----------+--------------------+-------------+
0x6c6bc977e13df9b0de53b251522280bb72383700|   -391460|            0.000009|100009.625421|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -345410|            0.000999|  1000.496793|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -306280|            0.050014|    19.994307|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -303410|            0.066639|    15.006177|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -299350|            0.100010|     9.998971|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -283260|            0.499792|     2.000831|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -281440|            0.599552|     1.667910|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -280380|            0.666592|     1.500167|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -279930|            0.697272|     1.434160|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -279220|            0.748575|     1.335870|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -279200|            0.750074|     1.333201|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -278950|            0.769061|     1.300285|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -278640|            0.793274|     1.260597|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -278560|            0.799645|     1.250553|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -278430|            0.810108|     1.234402|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -278190|            0.829785|     1.205130|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -278150|            0.833111|     1.200320|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -277950|            0.849940|     1.176553|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -277460|            0.892622|     1.120294|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -277430|            0.895304|     1.116938|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -277380|            0.899791|     1.111368|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -277370|            0.900691|     1.110257|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -277360|            0.901592|     1.109148|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -277350|            0.902494|     1.108039|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -277280|            0.908834|     1.100310|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -277270|            0.909743|     1.099210|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -277260|            0.910653|     1.098112|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -277160|            0.919805|     1.087186|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -277150|            0.920725|     1.086099|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276940|            0.940264|     1.063530|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276890|            0.944977|     1.058226|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276840|            0.949713|     1.052948|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276830|            0.950663|     1.051896|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276810|            0.952566|     1.049795|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276790|            0.954473|     1.047697|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276780|            0.955428|     1.046650|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276750|            0.958299|     1.043515|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276730|            0.960217|     1.041430|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276710|            0.962139|     1.039349|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276690|            0.964065|     1.037273|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276680|            0.965030|     1.036236|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276670|            0.965995|     1.035201|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276650|            0.967929|     1.033132|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276640|            0.968898|     1.032100|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276630|            0.969867|     1.031068|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276620|            0.970837|     1.030038|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276610|            0.971809|     1.029008|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276600|            0.972781|     1.027980|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276590|            0.973754|     1.026952|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276580|            0.974728|     1.025926|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276570|            0.975703|     1.024901|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276560|            0.976680|     1.023876|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276540|            0.978635|     1.021831|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276530|            0.979614|     1.020809|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276520|            0.980594|     1.019789|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276510|            0.981575|     1.018770|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276500|            0.982557|     1.017752|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276490|            0.983540|     1.016735|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276480|            0.984524|     1.015718|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276470|            0.985509|     1.014703|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276460|            0.986495|     1.013689|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276450|            0.987482|     1.012676|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276440|            0.988470|     1.011664|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276430|            0.989459|     1.010653|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276420|            0.990449|     1.009643|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276410|            0.991439|     1.008633|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276400|            0.992431|     1.007625|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276390|            0.993424|     1.006618|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276380|            0.994418|     1.005612|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276370|            0.995413|     1.004607|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276360|            0.996409|     1.003603|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276350|            0.997406|     1.002600|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276340|            0.998403|     1.001598|
------------------------------------------+----------+--------------------+-------------+
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276330|            0.999402|     1.000597| <<<
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276320|            1.000402|     0.999597| <<<
------------------------------------------+----------+--------------------+-------------+
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276310|            1.001403|     0.998598|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276300|            1.002405|     0.997600|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276290|            1.003408|     0.996603|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276280|            1.004412|     0.995607|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276270|            1.005416|     0.994612|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276260|            1.006422|     0.993618|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276250|            1.007429|     0.992625|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276240|            1.008437|     0.991632|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276230|            1.009446|     0.990641|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276220|            1.010456|     0.989651|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276210|            1.011467|     0.988662|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276200|            1.012479|     0.987674|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276190|            1.013492|     0.986687|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276180|            1.014506|     0.985701|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276170|            1.015521|     0.984716|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276150|            1.017554|     0.982748|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276140|            1.018572|     0.981766|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276130|            1.019591|     0.980785|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276120|            1.020611|     0.979805|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276110|            1.021632|     0.978825|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276100|            1.022654|     0.977847|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276090|            1.023677|     0.976870|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276080|            1.024701|     0.975893|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276040|            1.028808|     0.971998|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276030|            1.029837|     0.971026|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276020|            1.030867|     0.970056|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276010|            1.031899|     0.969086|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -276000|            1.032931|     0.968118|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -275990|            1.033965|     0.967150|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -275940|            1.039147|     0.962327|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -275930|            1.040187|     0.961365|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -275900|            1.043312|     0.958485|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -275840|            1.049590|     0.952752|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -275830|            1.050640|     0.951800|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -275810|            1.052743|     0.949898|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -275740|            1.060138|     0.943272|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -275660|            1.068653|     0.935757|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -275500|            1.085888|     0.920904|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -275460|            1.090240|     0.917228|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -275420|            1.094609|     0.913567|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -275370|            1.100096|     0.909011|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -275360|            1.101197|     0.908102|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -275340|            1.103401|     0.906288|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -275280|            1.110041|     0.900867|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -275270|            1.111152|     0.899966|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -275260|            1.112263|     0.899067|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -275160|            1.123441|     0.890121|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -274930|            1.149578|     0.869883|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -274920|            1.150728|     0.869014|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -274500|            1.200086|     0.833273|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -274440|            1.207308|     0.828288|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -274090|            1.250309|     0.799801|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -273930|            1.270474|     0.787107|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -273780|            1.289674|     0.775389|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -273050|            1.387337|     0.720805|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -272730|            1.432447|     0.698105|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -272720|            1.433880|     0.697408|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -272270|            1.499875|     0.666721|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -272250|            1.502878|     0.665389|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -271940|            1.550194|     0.645080|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -269390|            2.000441|     0.499889|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -265680|            2.898952|     0.344952|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -253300|            9.997024|     0.100029|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -246370|           19.990414|     0.050023|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -246360|           20.010413|     0.049973|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -244130|           25.009148|     0.039985|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -242310|           30.001056|     0.033332|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -197400|         2675.811693|     0.000373|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -197300|         2702.702696|     0.000370|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -197280|         2708.113240|     0.000369|
0x6c6bc977e13df9b0de53b251522280bb72383700|   -197250|         2716.249371|     0.000368|
0x6c6bc977e13df9b0de53b251522280bb72383700|      -510| 950281093584.590717|     0.000000|
0x6c6bc977e13df9b0de53b251522280bb72383700|       -90| 991040824711.425457|     0.000000|
0x6c6bc977e13df9b0de53b251522280bb72383700|        10|1001000450120.021002|     0.000000|
0x6c6bc977e13df9b0de53b251522280bb72383700|       110|1011060166398.544560|     0.000000|
0x6c6bc977e13df9b0de53b251522280bb72383700|       680|1070361669485.509359|     0.000000|
------------------------------------------+----------+--------------------+-------------+

*/