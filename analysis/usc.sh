#!/bin/sh
zcat $1/part* | awk -F"\t" '{ if (length($2) > 2 && length($2) < 200 && NF == 5 && $2 ~ /^([[:upper:]][[:alnum:]_-]+)$/) { print $1",\""$2"\","$3","$4","$5} }' | bzip2 > wikistats-$1.csv.bz2
