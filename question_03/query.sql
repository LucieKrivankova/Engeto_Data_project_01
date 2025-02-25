/*Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?*/

with price_data as (
	select 
		year,
		price_name,
		price_avg,
		lag(price_avg) over (partition by price_name order by year),
		(
		100 * (price_avg - lag(price_avg) over (partition by price_name order by year))
		/lag(price_avg) over (partition by price_name order by year)
		) as percent_change
	from t_lucie_krivankova_project_SQL_primary_final
	group by year, price_name, price_avg
)
select 
	price_name,
	round(avg(percent_change), 2) as avg_growth_rate
from price_data
group by price_name
having round(avg(percent_change), 2) > 0
order by avg_growth_rate 
limit 1
;
