BEGIN {
	FS = "\t"
	OFS = "\t"
	if ( typeof(ENVIRON["TZ"]) == "untyped" ) {
		print "ERROR: TZ environment variable is required" > "/dev/stderr"
		exit 1
	}
	print "BEGIN:VCALENDAR"
	print "VERSION:2.0"
	print "PRODID:-//GEN//AWK//UA"
	print "X-WR-CALNAME:" GROUP
	# TODO remove gensub(...) once Google Calendar recognizes the Europe/Kyiv timezone
	print "X-WR-TIMEZONE:" gensub(/Kyiv/, "Kiev", "g", ENVIRON["TZ"])
}

{
	__id = $1
	gsub(/[-:]/, "", __id)
	__begin = $2
	gsub(/[-:]/, "", __begin)
	__end = $3
	gsub(/[-:]/, "", __end)
	print "BEGIN:VEVENT"
	print "UID:" __begin "@poweron.loe.lviv.ua"
	print "DTSTAMP:" __id
	print "DTSTART:" __begin
	print "DTEND:" __end
	print "SUMMARY:⬛ " GROUP
	print "END:VEVENT"
}

END {
	print "END:VCALENDAR"
}
