BEGIN {
	FS = "\t";
	OFS = "\t";
	print "BEGIN:VCALENDAR";
	print "VERSION:2.0";
	print "PRODID:-//GEN//AWK//UA";
	print "X-WR-CALNAME:" GROUP;
	print "X-WR-TIMEZONE:Europe/Kiev";
}

{
	__id = $1;
	gsub(/[-:]/, "", __id);
	__begin = $2;
	gsub(/[-:]/, "", __begin);
	__end = $3;
	gsub(/[-:]/, "", __end);
	print "BEGIN:VEVENT";
	print "UID:" __begin "@poweron.loe.lviv.ua";
	print "DTSTAMP:" __id;
	print "DTSTART:" __begin;
	print "DTEND:" __end;
	print "SUMMARY:⬛ " GROUP;
	print "END:VEVENT";
}

END {
	print "END:VCALENDAR";
}
