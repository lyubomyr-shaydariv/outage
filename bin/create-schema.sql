CREATE TABLE outage (
	group_name TEXT NOT NULL,
	campaign_date TEXT NOT NULL,
	updated_at TEXT NOT NULL,
	outage_time_begin TEXT NOT NULL,
	outage_time_end TEXT NOT NULL,
	CHECK (STRFTIME('%Y-%m-%d', campaign_date) IS NOT NULL AND campaign_date = STRFTIME('%Y-%m-%d', campaign_date)),
	CHECK (STRFTIME('%Y-%m-%dT%H:%M:%SZ', updated_at) IS NOT NULL AND updated_at = STRFTIME('%Y-%m-%dT%H:%M:%SZ', updated_at)),
	CHECK (STRFTIME('%Y-%m-%dT%H:%M:%SZ', outage_time_begin) IS NOT NULL AND outage_time_begin = STRFTIME('%Y-%m-%dT%H:%M:%SZ', outage_time_begin)),
	CHECK (STRFTIME('%Y-%m-%dT%H:%M:%SZ', outage_time_end) IS NOT NULL AND outage_time_end = STRFTIME('%Y-%m-%dT%H:%M:%SZ', outage_time_end)),
	CHECK (outage_time_begin <= outage_time_end)
)
;
CREATE INDEX outage_campaign_updated
ON outage(campaign_date, updated_at)
;
CREATE INDEX outage_group_campaign_updated
ON outage(group_name, campaign_date, updated_at)
;
