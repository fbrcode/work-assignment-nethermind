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
  token1_id text,
  token1_symbol text,
  token1_name text,
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
  token1_id, 
  token1_symbol, 
  token1_name
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
  '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48',
  'USDC',
  'USD Coin'
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
  tick_id text,
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
  h.tick_id,
  h.volumetoken0::int as token0_amount,
  h.volumetoken1::int as token1_amount,
  h.tokenprice0,6 as token0_price,
  h.tokenprice1,6 as token1_price
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
	tick_id,
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
