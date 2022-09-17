select
	pool,
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
from univ3.vw_history_top_pools
where pool_id = '0x5777d92f208679db4b9778590fa3cab3ac9e2168'
and hist_date < '2022-07-01';
