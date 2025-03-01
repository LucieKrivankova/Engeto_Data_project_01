/*Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?*/

WITH price_data AS (
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
	pr.year,
	round(avg(pr.price_percent_change), 2) AS avg_price_per,
	round(avg(pa.payroll_percent_change), 2) AS avg_payroll_per,
	round(avg(pr.price_percent_change), 2) - round(avg(pa.payroll_percent_change), 2) AS price_vs_payroll_change 
FROM price_data pr
JOIN payroll_data pa
	ON pr.year = pa.year
GROUP BY pr.year
HAVING round(avg(pr.price_percent_change), 2) - round(avg(pa.payroll_percent_change), 2) > 10
ORDER BY pr.year
LIMIT 1
;
