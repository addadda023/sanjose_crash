
SELECT DISTINCT accidentdatetime, accident_year, accident_year_month, accident_year_week, accident_day
	,accident_per_day
	,round(cast(accident_per_week as decimal)/num_days_in_week,3) weekly_average
	,monthly_average
	FROM
	(
		SELECT DISTINCT accidentdatetime, accident_year, accident_year_month, accident_day, accident_year_week, accident_per_day, accident_per_month
			,sum(accident_per_day) OVER (PARTITION BY accident_year_week) accident_per_week
			,count(accident_per_day) OVER (PARTITION BY accident_year_week) num_days_in_week
			,count(accident_per_day) OVER (PARTITION BY accident_year_month) num_of_days
			,round(cast(accident_per_month as decimal)/count(accident_per_day) OVER (PARTITION BY accident_year_month),3) monthly_average
			
		FROM
		(
			SELECT DISTINCT accidentdatetime, accident_year, accident_year_month, accident_day, accident_year || '/' || week accident_year_week, count(TcrNumber) OVER (PARTITION BY accident_day) accident_per_day
				,count(TcrNumber) OVER (PARTITION BY accident_year, accident_year_month) accident_per_month
				,count(accident_day) OVER (PARTITION BY accident_year_month) num_of_days

				FROM
			(
				SELECT DISTINCT TcrNumber, accidentdatetime, to_char(accidentdatetime,'YYYY') accident_year ,to_char(accidentdatetime,'YYYY/MM') accident_year_month, to_char(accidentdatetime,'MM/DD/YYYY') accident_day
					,extract(week from accidentdatetime::date) week
			FROM sanjose_crash 
			) as t
		) as t1
	) as t2
ORDER BY accidentdatetime ASC
