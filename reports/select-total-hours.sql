SELECT "group", SUM(unixepoch(outage_time_end) - unixepoch(outage_time_begin)) / 3600.0 AS total_hours
FROM outage
GROUP BY "group"
ORDER BY total_hours DESC
;
