/*Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?*/

WITH payroll_data AS (
	SELECT
		year,
        industry,
        payroll_avg,
        LAG(payroll_avg) OVER (PARTITION BY industry ORDER BY year) AS last_payroll,
        CASE 
            WHEN LAG(payroll_avg) OVER (PARTITION BY industry ORDER BY year) > payroll_avg THEN 'klesa'
            ELSE 'roste'
        END AS payroll_compare
    FROM t_lucie_krivankova_project_SQL_primary_final
    GROUP BY industry, year, payroll_avg
)
SELECT DISTINCT
	industry,
	year
FROM payroll_data
WHERE payroll_compare = 'klesa'
ORDER BY industry, year
;
