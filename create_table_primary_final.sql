create table t_lucie_krivankova_project_SQL_primary_final as (
	with price as (
		select
			date_part('year', cp.date_from) as year,
			cpc."name" as price_name,
			round(avg(cp.value)::numeric, 2) as price_avg,
			cpc.price_value,
			cpc.price_unit
		from czechia_price cp
		join czechia_price_category cpc
			on cp.category_code = cpc.code
		group by price_name, year, cpc.price_value, cpc.price_unit
	),
	payroll as (
		select 
			p.payroll_year,
			i."name" as industry,
			round(avg(p.value)) as payroll_avg
		from czechia_payroll p
		join czechia_payroll_industry_branch i
			on p.industry_branch_code = i.code 
		where 1=1
			and p.value_type_code = 5958
			and p.calculation_code = 100
		group by industry, p.payroll_year
	)
	select
		pr.*,
		pa.industry,
		pa.payroll_avg
	from payroll pa
	join price pr
		on pa.payroll_year = pr.year
	order by pa.industry, pr.year, pr.price_name
)
;
