/*Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce,
 *  projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?*/

WITH gdp AS (
	SELECT
		year,
		round(100 * (gdp_in_billions - last_gdp)/ last_gdp, 2) AS gdp_percent_change
	FROM t_lucie_krivankova_project_SQL_secondary_final
	WHERE country LIKE 'Cz%'
),
price_data AS (
	SELECT
		year,
		price_avg,
		LAG(price_avg) OVER (PARTITION BY price_name ORDER BY year) AS last_price_avg,
		(
		100 * (price_avg - LAG(price_avg) OVER (PARTITION BY price_name ORDER BY year))
		/LAG(price_avg) OVER (PARTITION BY price_name ORDER BY year)
		) AS price_percent_change
	FROM t_lucie_krivankova_project_SQL_primary_final
	GROUP BY year, price_name, price_avg
),
payroll_data AS (
	SELECT
		year,
		payroll_avg,
		(
		100 * (payroll_avg - LAG(payroll_avg) OVER (PARTITION BY industry ORDER BY year))
		/LAG(payroll_avg) OVER (PARTITION BY industry ORDER BY year)
		) AS payroll_percent_change
	FROM t_lucie_krivankova_project_SQL_primary_final
	GROUP BY year, industry, payroll_avg
)
SELECT
	g.*,
	round(avg(pr.price_percent_change), 2) AS avg_price_per,
	round(avg(pa.payroll_percent_change), 2) AS avg_payroll_per
FROM gdp g
JOIN price_data pr
	ON g.year = pr.year
JOIN payroll_data pa
	ON g.year = pa.year
GROUP BY g.year, g.gdp_percent_change
ORDER BY g.year DESC
;
