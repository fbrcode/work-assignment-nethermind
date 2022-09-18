drop schema if exists univ3 cascade;
create schema univ3;

drop table if exists univ3.pools_top;
create table univ3.pools_top (
  id text primary key,
  id_tokens text,
  fee numeric,
  current_tvl_usd numeric,
  current_tick text,
  token0_id text,
  token0_symbol text,
  token0_name text,
  token0_decimals integer,
  token1_id text,
  token1_symbol text,
  token1_name text,
  token1_decimals integer,
  created_at timestamptz default now()
);

/* sample insert
insert into univ3.pools_top (
  id, 
  id_tokens, 
  fee, 
  current_tvl_usd, 
  current_tick, 
  token0_id, 
  token0_symbol, 
  token0_name, 
  token0_decimals,
  token1_id, 
  token1_symbol, 
  token1_name,
  token1_decimals
) values (
  '0x5777d92f208679db4b9778590fa3cab3ac9e2168',
  'DAI / USDC',
  100,
  --883741958.650914,
  883741958.6509142941875104139999999,
  '-276324',
  '0x6b175474e89094c44da98b954eedeac495271d0f',
  'DAI',
  'Dai Stablecoin',
  18,
  '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48',
  'USDC',
  'USD Coin',
  6
);
*/

drop table if exists univ3.pool_ticks;
create table univ3.pool_ticks (
  id text,
  pool_id text,
  tick_index integer,
  constant_price0 numeric,
  constant_price1 numeric,
  created_at timestamptz default now()
);

alter table univ3.pool_ticks 
add constraint pool_ticks__pools_top__fk 
foreign key (pool_id)
references univ3.pools_top(id);

/* sample insert
insert into univ3.pool_ticks (
  id,
  pool_id,
  tick_index,
  constant_price0,
  constant_price1
) values (
  '0x5777d92f208679db4b9778590fa3cab3ac9e2168#-254218',
  '0x5777d92f208679db4b9778590fa3cab3ac9e2168',
  '-254218',
  0.9,
  1.1
);
*/

drop table if exists univ3.pool_history;
create table univ3.pool_history (
  id text,
  pool_id text,
  unix_date integer,
  hist_date date,
  tick_index integer,
  volumeToken0 numeric,
  volumeToken1 numeric,
  tokenPrice0 numeric,
  tokenPrice1 numeric,
  volumeUSD numeric,
  tvlUSD numeric,
  txCount integer,
  sqrtPrice numeric,
  liquidity numeric,
  feesUSD numeric,
  created_at timestamptz default now()
);

alter table univ3.pool_history 
add constraint pool_history__pools_top__fk 
foreign key (pool_id)
references univ3.pools_top(id);

/* sample insert
insert into univ3.pool_history (
  id,
  pool_id,
  unix_date,
  hist_date,
  tick_id,
  volumeToken0,
  volumeToken1,
  tokenPrice0,
  tokenPrice1,
  volumeUSD,
  tvlUSD,
  txCount,
  sqrtPrice,
  liquidity,
  feesUSD
) values (
  '0x5777d92f208679db4b9778590fa3cab3ac9e2168-459851',
  '0x5777d92f208679db4b9778590fa3cab3ac9e2168',
  1655463600,
  '2020-09-18',
  '-276324',
  26273666,
  26274495,
  0.9,
  1.1,
  26272568.41,
  681790497.98,
  835,
  79229834134521981600589,
  3401894300457591194958746,
  2627.25
);
*/

-- select  id, pool_id, unix_date, hist_date, tick_id, volumetoken0, volumetoken1, tokenprice0, tokenprice1 from univ3.pool_history limit 10;

/*
select
  t.id,
  t.id_tokens,
  t.fee,
  t.current_tvl_usd,
  t.current_tick,
  t.token0_id,
  t.token0_symbol,
  t.token0_name,
  t.token1_id,
  t.token1_symbol,
  t.token1_name
from univ3.pools_top t;

select 
  h.id,
  h.pool_id,
  h.unix_date,
  h.hist_date,
  h.tick_id,
  h.volumetoken0,
  h.volumetoken1,
  h.tokenprice0,
  h.tokenprice1,
  h.volumeusd,
  h.tvlusd,
  h.txcount,
  h.sqrtprice,
  h.liquidity,
  h.feesusd
from univ3.pool_history h;
*/

drop view if exists univ3.vw_history_top_pools;
create or replace view univ3.vw_history_top_pools as
select
  t.id as pool_id,
  t.id_tokens || ' (' || round(t.fee/10000,2) || '%)' as pool,
  round(t.current_tvl_usd,2) tvl_usd,
  t.token0_symbol,
  t.token0_name,
  t.token1_symbol,
  t.token1_name,
  h.hist_date,
  h.tick_index,
  h.volumetoken0::int as token0_amount,
  h.volumetoken1::int as token1_amount,
  trunc(h.tokenprice0,12) as token0_price,
  trunc(h.tokenprice1,12) as token1_price
from univ3.pools_top t
inner join univ3.pool_history h on h.pool_id = t.id
order by t.current_tvl_usd desc, h.hist_date;

/*
SELECT
  hist_date AS "time",
  token0_amount AS "Dai Stablecoin",
  token1_amount AS "USD Coin"
FROM univ3.vw_history_top_pools
WHERE
  pool_id = '0x5777d92f208679db4b9778590fa3cab3ac9e2168'
ORDER BY 1
*/

drop view if exists univ3.vw_history_token_amount_difference;
create or replace view univ3.vw_history_token_amount_difference as
select
	pool,
	pool_id,
	hist_date,
	tick_index,
	token0_amount,
	token1_amount,
	case 
		when (token0_amount - token1_amount) >= 0 
		then token0_amount - token1_amount
		else 0
	end as token0_larger_diff,
	case 
		when (token1_amount - token0_amount) >= 0 
		then token1_amount - token0_amount
		else 0
	end as token1_larger_diff,
	case 
		when (token0_amount - token1_amount) >= 0 
		then token0_symbol
		else token1_symbol
	end as leading_token_amount
from univ3.vw_history_top_pools;

-- logic for best match on pool tick prices
drop view if exists univ3.vw_history_prices_by_tick_range_all;
create or replace view univ3.vw_history_prices_by_tick_range_all as
select 
	pool_id,
	pool,
	hist_date,
	tick_index,
	tick_index_range,
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
	) x
) y
where tick_index_rank = 1
order by pool_id, hist_date, tick_index, tick_index_range;
