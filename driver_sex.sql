SELECT driversex, driverage

FROM sanjose_crash

WHERE driversex is NOT NULL
	AND driverage <> 0

ORDER BY driversex, driverage