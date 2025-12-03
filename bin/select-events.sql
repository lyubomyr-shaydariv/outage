SELECT DISTINCT updated_at, outage_time_begin, outage_time_end
FROM outage AS P
WHERE "group" = :group AND updated_at = (
	SELECT MAX(updated_at)
	FROM outage
	WHERE campaign_date = P.campaign_date
)
ORDER BY campaign_date, updated_at
;
