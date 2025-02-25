/*Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?*/

with price_data as (
	select 
		year,
		price_avg,
		lag(price_avg) over (partition by price_name order by year) as last_price_avg,
		(
		100 * (price_avg - lag(price_avg) over (partition by price_name order by year))
		/lag(price_avg) over (partition by price_name order by year)
		) as price_percent_change
	from t_lucie_krivankova_project_SQL_primary_final
	group by year, price_name, price_avg
),
payroll_data as (
	select 
		year,
		payroll_avg,
		(
		100 * (payroll_avg - lag(payroll_avg) over (partition by industry order by year))
		/lag(payroll_avg) over (partition by industry order by year)
		) as payroll_percent_change
	from t_lucie_krivankova_project_SQL_primary_final
	group by year, industry, payroll_avg
)
select 
	pr.year,
	round(avg(pr.price_percent_change), 2) as avg_price_per,
	round(avg(pa.payroll_percent_change), 2) as avg_payroll_per,
	round(avg(pr.price_percent_change), 2) - round(avg(pa.payroll_percent_change), 2) as price_vs_payroll_change 
from price_data pr
join payroll_data pa
	on pr.year = pa.year
group by pr.year
having round(avg(pr.price_percent_change), 2) - round(avg(pa.payroll_percent_change), 2) > 10
order by pr.year
limit 1
;
