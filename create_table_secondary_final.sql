-- create table t_lucie_krivankova_project_SQL_secondary_final as (
	with gdp as (
		select 
			year,
			country,
			ROUND((gdp / 1000000000)::numeric, 2) AS gdp_in_billions
		from economies
	)
	select 
		e.year,
		e.country,
		e.population,
		e.gini,
		g.gdp_in_billions,
		lag(gdp_in_billions) over (partition by e.country order by e.year) as last_gdp
	from countries c
	left join economies e
		on c.country = e.country
	join gdp g
		on g.year = e.year
		and g.country = e.country
	where 1=1
		and c.continent = 'Europe'
		and e.year between 2006 and 2018
	order by e.country, e.year desc
--)
;
