/*Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?*/

WITH price_data AS (
	SELECT
		year,
		price_name,
		price_avg,
		LAG(price_avg) OVER (PARTITION BY price_name ORDER BY year),
		(
		100 * (price_avg - LAG(price_avg) OVER (PARTITION BY price_name ORDER BY year))
		/LAG(price_avg) OVER (PARTITION BY price_name ORDER BY year)
		) AS percent_change
	FROM t_lucie_krivankova_project_SQL_primary_final
	GROUP BY year, price_name, price_avg
)
SELECT
	price_name,
	round(avg(percent_change), 2) AS avg_growth_rate
FROM price_data
GROUP BY price_name
HAVING round(avg(percent_change), 2) > 0
ORDER BY avg_growth_rate 
LIMIT 1
;
