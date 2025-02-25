/*Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?*/

with payroll_data as (
	select
		year,
        industry,
        payroll_avg,
        lag(payroll_avg) over (partition by industry order by year) as last_payroll,
        case
            when LAG(payroll_avg) over (partition by industry order by year) > payroll_avg then 'klesa'
            else 'roste'
        end as payroll_compare
    from t_lucie_krivankova_project_SQL_primary_final
    group by industry, year, payroll_avg
)
select distinct
	industry,
	year
from payroll_data
where payroll_compare = 'klesa'
order by industry, year
;
