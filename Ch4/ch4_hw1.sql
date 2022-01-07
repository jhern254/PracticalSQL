-- Ch. 4 Hw
-- 1)
COPY movies_db 
FROM 'movies_file.txt'
WHERE (FORMAT TXT, HEADER, DELIMITER ':', QUOTE '#');
-- Only format optinos are txt, csv, and binary

-- 2)
-- Check table
SELECT *
FROM us_counties_2010
LIMIT 5;

-- Write select query
SELECT geo_name, state_us_abbreviation, housing_unit_count_100_percent 
FROM us_counties_2010
ORDER BY housing_unit_count_100_percent DESC
LIMIT 20;

-- Export query to csv
COPY (
    SELECT geo_name, state_us_abbreviation, housing_unit_count_100_percent 
    FROM us_counties_2010
    ORDER BY housing_unit_count_100_percent DESC
    LIMIT 20
)
TO '/home/jun/Documents/Programming/PracticalSQL/Ch4/hw1.csv'
WITH (FORMAT CSV, HEADER);
-- This is correct, but I have no permissions to file 

-- Correct run
COPY (
    SELECT geo_name, state_us_abbreviation, housing_unit_count_100_percent 
    FROM us_counties_2010
    ORDER BY housing_unit_count_100_percent DESC
    LIMIT 20
)
TO '/tmp/Ch4_hw1.csv'
WITH (FORMAT CSV, HEADER);
-- Works

-- 3)
--Ex. 17519.668
Text Ans:
numeric(3, 8) will not work, since the precision and and scale have reversed
placements in the numeric arguments. Should be numeric(8, 3)





