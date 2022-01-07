-- Ch. 16 - Command Line psql

-- Launch psql
-- psql -d database_name -U user_name
psql -d analysis -U jun

-- single line query
SELECT geo_name FROM us_counties_2010 LIMIT 3;

-- multi line query - can press enter in psql
-- NOTE: query ends when ; is read
SELECT geo_name
FROM us_counties_2010
LIMIT 3;

-- Create wineries table to see psql work w/ ()
CREATE TABLE wineries (
    id bigint,
    winery_name varchar(100)
);


-- Can format output w/ \pset meta-command
-- Print table w/ no Limit
SELECT geo_name FROM us_counties_2010;
-- OUT: Shows long list

-- Use \pset pager to show bottom results first

-- Check expanded table view
SELECT * FROM grades;

-- \x
-- run again. Output basically shows more row info/cols.

SELECT * FROM us_counties_2010;
-- Reg. form is not even readable


-- Meta Commands for DB info
-- \dt+ to list all tables

-- Displays tables whose names begin w/ us
\dt+ us*
-- OUT: shows 3 tables



-- Importing and exporting in psql
DROP TABLE state_regions;

CREATE TABLE state_regions (
    st varchar(2) CONSTRAINT st_key PRIMARY KEY,
    region varchar(20) NOT NULL
);

-- Use psql \copy meta to import file
\copy state_regions 
FROM '/home/jun/Documents/Programming/PracticalSQL/Ch9/state_regions.csv' 
WITH (FORMAT CSV, HEADER);
-- Has to be one line to work?




-- Export w/ \o
-- Set format options to be like csv
\a \f , \pset footer

-- Query to export
SELECT * FROM grades;

\o '/home/jun/Documents/Programming/PracticalSQL/Ch16/query_output.csv'
SELECT * FROM grades;
--OUT: Worked. Can now save files in local filesystem, not temp

--NOTE: every QUERY after exported, will be saved to same file
-- Have to run \o again to change back to empty




-- Can also run saved sql files, for saved queries
-- EX:
psql -d analysis -U jun -f display_grades.sql
-- OUT: runs display_grades sql file



-- Create DB w/ createdb command
createdb -U postgres -e box_office

-- Connect to new db
psql -d box_office -U postgres















