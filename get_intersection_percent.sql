COPY
(
SELECT intersectiondirection
	, COUNT(*) AS num_of_crashes
	, round(cast(COUNT(*) as decimal)/total.total * 100,3) AS percentage
	
FROM sanjose_crash
	,( SELECT COUNT(*) AS total FROM sanjose_crash ) AS total 

GROUP BY intersectiondirection
	,total
)
To 'C:\Users\Public\intersection_per.csv' With CSV DELIMITER ',';