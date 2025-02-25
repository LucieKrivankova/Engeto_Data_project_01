CREATE TABLE t_lucie_krivankova_project_SQL_primary_final AS (
	WITH price AS (
		SELECT
			date_part('year', cp.date_from) AS year,
			cpc."name" AS price_name,
			round(avg(cp.value)::numeric, 2) AS price_avg,
			cpc.price_value,
			cpc.price_unit
		FROM czechia_price cp
		JOIN czechia_price_category cpc
			ON cp.category_code = cpc.code
		GROUP BY price_name, year, cpc.price_value, cpc.price_unit
	),
	payroll AS (
		SELECT 
			p.payroll_year,
			i."name" AS industry,
			round(avg(p.value)) AS payroll_avg
		FROM czechia_payroll p
		JOIN czechia_payroll_industry_branch i
			ON p.industry_branch_code = i.code 
		WHERE 1=1
			AND p.value_type_code = 5958
			AND p.calculation_code = 100
		GROUP BY industry, p.payroll_year
	)
	SELECT
		pr.*,
		pa.industry,
		pa.payroll_avg
	FROM payroll pa
	JOIN price pr
		ON pa.payroll_year = pr.year
	ORDER BY pa.industry, pr.year, pr.price_name
)
;
