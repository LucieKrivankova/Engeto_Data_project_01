CREATE TABLE t_lucie_krivankova_project_SQL_secondary_final AS (
	WITH gdp AS (
		SELECT 
			year,
			country,
			ROUND((gdp / 1000000000)::NUMERIC, 2) AS gdp_in_billions
		FROM economies
	)
	SELECT 
		e.year,
		e.country,
		e.population,
		e.gini,
		g.gdp_in_billions,
		LAG(gdp_in_billions) OVER (PARTITION BY e.country ORDER BY e.year) AS last_gdp
	FROM countries c
	LEFT JOIN economies e
		ON c.country = e.country
	JOIN gdp g
		ON g.year = e.year
		AND g.country = e.country
	WHERE 1=1
		AND c.continent = 'Europe'
		AND e.year BETWEEN 2006 AND 2018
	ORDER BY e.country, e.year DESC
)
;
