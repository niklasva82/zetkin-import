#!/bin/sh

for year in 2014 2015 2016 2017; do
	head -n 1 $1 > $year.csv
	cat $1 | awk 'BEGIN { FS=";" } $10 ~ /'${year}'/ { print }' | awk 'BEGIN { FS=";" } { print }' >> $year.csv
done;

head -n 1 $1 > aldre.csv
cat $1 | awk 'BEGIN { FS=";" } $10 < 2014 && $10 != "" { print }' | awk 'BEGIN { FS=";" } { print }' >> aldre.csv
