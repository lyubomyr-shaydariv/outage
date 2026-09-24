BEGIN {
	FS = "\t"
	OFS = "\t"
	if ( typeof(ENVIRON["TZ"]) == "untyped" ) {
		print "ERROR: TZ environment variable is required" > "/dev/stderr"
		exit 1
	}
}

function to_local_date(year, month, day, __local) {
	__local = mktime(sprintf("%04d %02d %02d 00 00 00", year, month, day), 0)
	return strftime("%Y-%m-%d", __local, 0)
}

function to_utc_datetime_from_local(year, month, day, hour, minute, second, __local) {
	__local = mktime(sprintf("%04d %02d %02d %02d %02d %02d", year, month, day, hour, minute, second), 0)
	return strftime("%Y-%m-%dT%H:%M:%SZ", __local, 1)
}

match($0, /^Графік погодинних відключень на ([0-9]{2}).([0-9]{2}).([0-9]{4})$/, __m) {
	campaign_date = to_local_date(__m[3], __m[2], __m[1])
	__campaign_date_yyyy = __m[3]
	__campaign_date_mm= __m[2]
	__campaign_date_dd= __m[1]
	next
}

match($0, /^Інформація станом на ([0-9]{2}).([0-9]{2}) ([0-9]{2}).([0-9]{2}).([0-9]{4})$/, __m) {
	updated_at = to_utc_datetime_from_local(__m[5], __m[4], __m[3], __m[1], __m[2], "00")
	next
}

match($0, /^(Група [^ ]+) Електроенергії немає (.*)/, __m) {
	group = __m[1]
	while ( match(__m[2], /з ([0-9]{2}):([0-9]{2}) до ([0-9]{2}):([0-9]{2})/, ____m)) {
		__m[2] = substr(__m[2], RSTART + RLENGTH)
		outage_time_begin = to_utc_datetime_from_local(__campaign_date_yyyy, __campaign_date_mm, __campaign_date_dd, ____m[1], ____m[2], "00")
		outage_time_end= to_utc_datetime_from_local(__campaign_date_yyyy, __campaign_date_mm, __campaign_date_dd, ____m[3], ____m[4], "00")
		print group, campaign_date, updated_at, outage_time_begin, outage_time_end
	}
	next
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
