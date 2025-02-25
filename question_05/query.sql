/*Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce,
 *  projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?*/

with gdp as (
	select 
		year,
		round(
		100 * (gdp_in_billions - last_gdp)
		/ last_gdp,
		2) as gdp_percent_change
	from t_lucie_krivankova_project_SQL_secondary_final
	where country like 'Cz%'
),
price_data as (
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
	g.*,
	round(avg(pr.price_percent_change), 2) as avg_price_per,
	round(avg(pa.payroll_percent_change), 2) as avg_payroll_per
from gdp g
join price_data pr
	on g.year = pr.year
join payroll_data pa
	on g.year = pa.year
group by g.year, g.gdp_percent_change
order by g.year desc
;
