#!/bin/bash
DBNAME=wiki
mclient $DBNAME create.sql

importw () {
	local nl=$'\n'
	curl "http://dumps.wikimedia.org/enwiki/latest/enwiki-latest-$1.sql.gz" | gzcat | \
	sed -n "/^INSERT INTO/{
		s/^[^(]*(//g
		s/);\$//g
		s/),(/\\$nl/g
		p
	}" | \
	mclient $DBNAME -s "COPY INTO $1 FROM STDIN USING DELIMITERS ',','\n','\''" -
	return 0
}

importw "redirect"
importw "page"