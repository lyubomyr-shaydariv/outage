SELECT group_name, SUM(UNIXEPOCH(outage_time_end) - UNIXEPOCH(outage_time_begin)) / 3600.0 AS total_hours
FROM outage
GROUP BY group_name
ORDER BY total_hours DESC
;
