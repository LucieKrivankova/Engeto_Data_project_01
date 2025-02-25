/*Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?*/

select 
	year,
	price_name,
	price_avg,
	round(avg(payroll_avg)) as payroll_avg,
	round(avg(payroll_avg)/price_avg) as to_buy,
	price_unit 
from t_lucie_krivankova_project_SQL_primary_final
where 1=1 
	and (price_name like 'Mléko%' or price_name like 'Chl%')
	and (year = 2006 or year = 2018)
	group by year, price_name, price_avg, price_unit
order by year, price_name
;
