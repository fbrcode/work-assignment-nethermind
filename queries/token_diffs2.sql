select
	pool,
	hist_date,
	tick_index,
	token0_amount,
	token1_amount,
	token0_larger_diff,
	token1_larger_diff,
	leading_token_amount
from univ3.vw_history_token_amount_difference
where pool_id = '0x5777d92f208679db4b9778590fa3cab3ac9e2168';

select distinct pool_id, pool from univ3.vw_history_token_amount_difference;