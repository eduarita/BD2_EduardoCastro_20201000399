/*	BigQuery Tarea #1
	Eduardo Josué Castro Arita - 20201000399
*/

--	Ejercicio #1
SELECT
  name,
  gender,
  SUM(number)
FROM `bigquery-public-data.usa_names.usa_1910_2013`
GROUP BY name,gender
ORDER BY SUM(number) DESC

--	Ejercicio #2
SELECT
  date,
  state,
  tests_total,
  cases_positive_total,
  SUM(tests_total) over(partition by state) as Total_Estado
FROM `bigquery-public-data.covid19_covidtracking.summary`

-- Ejercicio #3
SELECT channelGrouping, pageviews, pageviews/(SUM(pageviews) OVER()) AS porcentaje_del_total, AVG(pageviews) OVER() AS promedio
FROM
(-- Subconsulta
  SELECT channelGrouping,SUM(totals.pageviews) AS pageviews FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170801`
  GROUP BY channelGrouping,date
)GROUP BY channelGrouping, pageviews
ORDER BY porcentaje_del_total DESC

-- Ejercicio #4
SELECT
  Region,
  Country,
  Total_Revenue,
  DENSE_RANK() OVER(PARTITION BY Region ORDER BY Total_Revenue DESC) AS rango
FROM  `future-datum-370823.dset.Ventas`

