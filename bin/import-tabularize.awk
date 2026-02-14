BEGIN {
	FS = "\t";
	OFS = "\t";
	EUROPE_KYIV_ST_OFFSET = 2 * 3600;
	EUROPE_KYIV_DST_OFFSET = 3 * 3600;
	EUROPE_KYIV_DST_BEGIN[2024] = mktime("2024 03 31 04 00 00"); EUROPE_KYIV_DST_END[2024] = mktime("2024 10 27 03 00 00");
	EUROPE_KYIV_DST_BEGIN[2025] = mktime("2025 03 30 04 00 00"); EUROPE_KYIV_DST_END[2025] = mktime("2025 10 26 03 00 00");
	EUROPE_KYIV_DST_BEGIN[2026] = mktime("2026 03 29 04 00 00"); EUROPE_KYIV_DST_END[2026] = mktime("2026 10 25 03 00 00");
	EUROPE_KYIV_DST_BEGIN[2027] = mktime("2027 03 28 04 00 00"); EUROPE_KYIV_DST_END[2027] = mktime("2027 10 31 03 00 00");
	EUROPE_KYIV_DST_BEGIN[2028] = mktime("2028 03 26 04 00 00"); EUROPE_KYIV_DST_END[2028] = mktime("2028 10 29 03 00 00");
	EUROPE_KYIV_DST_BEGIN[2029] = mktime("2029 03 25 04 00 00"); EUROPE_KYIV_DST_END[2029] = mktime("2029 10 28 03 00 00");
	EUROPE_KYIV_DST_BEGIN[2030] = mktime("2030 03 31 04 00 00"); EUROPE_KYIV_DST_END[2030] = mktime("2030 10 27 03 00 00");
}

function get_europe_kyiv_offset(year, month, day, hour, __dst_begin, __dst_end, __t) {
	__dst_begin = EUROPE_KYIV_DST_BEGIN[year];
	if ( typeof(__dst_begin) == "unassigned" ) {
		print "ERROR: no Europe/Kyiv DST begin found for " year > "/dev/stderr";
		exit 1;
	}
	__dst_end = EUROPE_KYIV_DST_END[year];
	if ( typeof(__dst_end) == "unassigned" ) {
		print "ERROR: no Europe/Kyiv DST end found for " year > "/dev/stderr";
		exit 1;
	}
	__t = mktime(year " " month " " day " " hour " 00 00");
	if ( __t >= __dst_begin && __t < __dst_end ) {
		return EUROPE_KYIV_DST_OFFSET;
	}
	return EUROPE_KYIV_ST_OFFSET;
}

function to_local_date(year, month, day) {
	return strftime("%Y-%m-%d", mktime(year " " month " " day " 00 00 00"));
}

function to_utc_datetime_from_europe_kyiv(year, month, day, hour, minute, second, __offset) {
	__offset = get_europe_kyiv_offset(year, month, day, hour);
	return strftime("%Y-%m-%dT%H:%M:%SZ", mktime(year " " month " " day " " hour " " minute " " second) - __offset)
}

match($0, /^Графік погодинних відключень на ([0-9]{2}).([0-9]{2}).([0-9]{4})$/, __m) {
	campaign_date = to_local_date(__m[3], __m[2], __m[1]);
	__campaign_date_yyyy = __m[3];
	__campaign_date_mm= __m[2];
	__campaign_date_dd= __m[1];
	next;
}

match($0, /^Інформація станом на ([0-9]{2}).([0-9]{2}) ([0-9]{2}).([0-9]{2}).([0-9]{4})$/, __m) {
	updated_at = to_utc_datetime_from_europe_kyiv(__m[5], __m[4], __m[3], __m[1], __m[2], "00");
	next;
}

match($0, /^(Група [^ ]+) Електроенергії немає (.*)/, __m) {
	group = __m[1];
	while ( match(__m[2], /з ([0-9]{2}):([0-9]{2}) до ([0-9]{2}):([0-9]{2})/, ____m)) {
		__m[2] = substr(__m[2], RSTART + RLENGTH);
		outage_time_begin = to_utc_datetime_from_europe_kyiv(__campaign_date_yyyy, __campaign_date_mm, __campaign_date_dd, ____m[1], ____m[2], "00");
		outage_time_end= to_utc_datetime_from_europe_kyiv(__campaign_date_yyyy, __campaign_date_mm, __campaign_date_dd, ____m[3], ____m[4], "00");
		print group, campaign_date, updated_at, outage_time_begin, outage_time_end;
	}
	next;
}

match($0, /^(Група [^ ]+) Електроенергія є.$/) {
	next;
}

length($0) == 0 {
	next;
}

{
	print "ERROR: unhandled pattern: ", $0 > "/dev/stderr";
	exit 1;
}
