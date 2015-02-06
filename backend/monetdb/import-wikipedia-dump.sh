#!/bin/bash
DBNAME=wikistats

importw () {
	local nl=$'\n'
	curl "http://dumps.wikimedia.org/enwiki/latest/enwiki-latest-$1.sql.gz" | gzip -d -c | \
	sed -n "/^INSERT INTO/{
		s/^[^(]*(//g
		s/);\$//g
		s/),(/\\$nl/g
		p
	}" | \
	mclient $DBNAME -s "DELETE FROM $1; COPY INTO $1 FROM STDIN USING DELIMITERS ',','\n','\''" -
	return 0
}

importw "redirect"
importw "page"
