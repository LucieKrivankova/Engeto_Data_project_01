/*Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?*/

SELECT 
	year,
	price_name,
	price_avg,
	round(avg(payroll_avg)) AS payroll_avg,
	round(avg(payroll_avg)/price_avg) AS to_buy,
	price_unit 
FROM t_lucie_krivankova_project_SQL_primary_final
WHERE 
	(price_name LIKE 'Mléko%' OR price_name LIKE 'Chl%')
	AND (year = 2006 OR year = 2018)
	GROUP BY year, price_name, price_avg, price_unit
ORDER BY year, price_name
;
