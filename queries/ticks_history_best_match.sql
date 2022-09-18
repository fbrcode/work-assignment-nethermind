drop view if exists univ3.vw_history_prices_by_tick_range_all;
create or replace view univ3.vw_history_prices_by_tick_range_all as
select 
	pool_id,
	pool,
	hist_date,
	tick_index,
	tick_index_range,
	--match_search1,
	--match_search2,
	--match_search3,
	--tick_index_rank,
	token0_symbol,
	token0_price,
	token0_tick_price, 
	token1_symbol,
	token1_price,
	token1_tick_price
from (
	select 
		pool_id,
		pool,
		hist_date,
		tick_index,
		tick_index_range,
		match_search1,
		match_search2,
		match_search3,
		rank() over (partition by pool_id, hist_date order by match_search1, match_search2, match_search3, tick_index_range) as tick_index_rank,
		token0_symbol,
		token0_price,
		token0_tick_price, 
		token1_symbol,
		token1_price,
		token1_tick_price
	from (	select
			h.pool_id,
			h.pool,
			h.hist_date,
			h.tick_index,
			t.tick_index as tick_index_range,
			substring(h.tick_index::text,0,length(h.tick_index::text)+1) as tick_search1,
			substring(h.tick_index::text,0,length(h.tick_index::text)) as tick_search2,
			substring(h.tick_index::text,0,length(h.tick_index::text)-1) as tick_search3,
			case when t.tick_index::text = substring(h.tick_index::text,0,length(h.tick_index::text)+1) then h.tick_index else null end as match_search1,
			case when substring(t.tick_index::text,0,length(t.tick_index::text)) = substring(h.tick_index::text,0,length(h.tick_index::text)) then h.tick_index else null end as match_search2,
			case when substring(t.tick_index::text,0,length(t.tick_index::text)-1) = substring(h.tick_index::text,0,length(h.tick_index::text)-1) then h.tick_index else null end as match_search3,
			--rank() over (partition by h.pool_id, h.hist_date order by t.tick_index asc) as pool_index_rank,
			h.token0_symbol,
			h.token0_price,
			case when h.tick_index < 0 then t.constant_price0 * 1000000000000 else t.constant_price1 * 1000000000000 end as token0_tick_price, 
			h.token1_symbol,
			h.token1_price,
			case when h.tick_index < 0 then t.constant_price1 / 1000000000000 else t.constant_price0 / 1000000000000 end as token1_tick_price
		from univ3.vw_history_top_pools h
		left join univ3.pool_ticks t 
			on h.pool_id = t.pool_id 
			and (
					t.tick_index::text like substring(h.tick_index::text,0,length(h.tick_index::text)+1) || '%'
				or 	t.tick_index::text like substring(h.tick_index::text,0,length(h.tick_index::text)) || '%'
				or 	t.tick_index::text like substring(h.tick_index::text,0,length(h.tick_index::text)-1) || '%'
			)
		--where h.hist_date = '2022-07-03'
	) x
) y
where tick_index_rank = 1
--and pool_id = '0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8'
order by pool_id, hist_date, tick_index, tick_index_range;
