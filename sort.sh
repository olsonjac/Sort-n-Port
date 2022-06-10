#!/bin/bash

#shows debug info
set -x
#This is not secure and would need to be ran through another file(maybe a temp file ?)
PASS='*******'
USER='root'

#initial for loop that identifies every file found in the new_data folder that is a csv file and routes them to the temp_data directory
for i in `find /home/jacob/new_data/ -name '*.csv'` ; do
  mv $i '/home/jacob/temp_data' ;  done

#for loop that will log into the mysql database and execute sql commands to fully import all csv files into the listed database
for i in `find /home/jacob/temp_data/ -name '*.csv'` ; do mysql -u$USER -p$PASS --local-infile <<-EOF
  USE testdb
  LOAD DATA LOCAL INFILE "$i"
  INTO TABLE users
  FIELDS TERMINATED BY ','
  ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  IGNORE 1 LINES;
	EOF
  done

#final for loop that iterates through all csv files in the temp_data directory and moves them to the archive directory
for i in `find /home/jacob/temp_data/ -name '*.csv'`; do mv $i '/home/jacob/archive_data' ;  done
