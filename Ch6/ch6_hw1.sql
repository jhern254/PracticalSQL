-- Ch. 6 HW 1
-- 1)
SELECT c2010.geo_name AS county_2010, 
       c2000.geo_name AS county_2000,
       c2010.state_us_abbreviation AS state
FROM us_counties_2010 AS c2010 LEFT JOIN us_counties_2000 AS c2000
ON c2010.state_fips = c2000.state_fips
    AND c2010.county_fips = c2000.county_fips
WHERE c2000.geo_name IS NULL;
-- Shows 6 NULL counties in 2000 tables. These could be new counties

-- Run same but Right join for 2000 table
SELECT c2010.geo_name AS county_2010, 
       c2000.geo_name AS county_2000,
       c2010.state_us_abbreviation AS state
FROM us_counties_2010 AS c2010 RIGHT JOIN us_counties_2000 AS c2000
ON c2010.state_fips = c2000.state_fips
    AND c2010.county_fips = c2000.county_fips
WHERE c2010.geo_name IS NULL;
-- There are 4 counties in 2000 that do not exist anymore in 2010. Why? 

--ANS: This was correct, but I don't know if running multiple queries
-- is common as an answer, instead of one query. Seems redundant.


-- 2)
-- Q: Determine median of the percent change in county pop.
-- Percent change over time
-- FORMULA: (new_number - old_number) / old_number

-- I think I was doing this wrong. 
SELECT c2010.state_us_abbreviation AS "st",
       percentile_cont(.5)
       WITHIN GROUP (ORDER BY c2010.p0010001) AS "2010_median",
       percentile_cont(.5) 
       WITHIN GROUP (ORDER BY c2000.p0010001) AS "2000_median",
       ( CAST(2010_median) AS numeric(4, 2) - 2000_median) / 
			2000_median * 100 AS Median_pct_change
FROM us_counties_2010 c2010 JOIN us_counties_2000 c2000
ON c2010.state_fips = c2000.state_fips
    AND c2010.county_fips = c2000.county_fips
GROUP BY c2010.geo_name

-- Still doesn't work
SELECT c2010.state_us_abbreviation AS "st",
       c2010.geo_name AS county_2010,
       c2010.p0010001 AS pop_2010,
       c2000.p0010001 AS pop_2000,
       ROUND( (CAST (c2010.p0010001 AS numeric(8, 1)) - c2000.p0010001) 
           / c2000.p0010001 * 100, 1) AS "pct_change",
       percentile_cont(.5)
       WITHIN GROUP (ORDER BY "pct_change") AS pct_change_median
FROM us_counties_2010 c2010 INNER JOIN us_counties_2000 c2000
ON c2010.state_fips = c2000.state_fips
    AND c2010.county_fips = c2000.county_fips
ORDER BY pct_change DESC;

-- Ex. Why prev. code wont work
-- This doesn't work because PSQL won't ref. Select made vars
SELECT c2010.state_us_abbreviation AS "st",
       c2010.geo_name AS county_2010,
       c2010.p0010001 AS pop_2010,
       c2000.p0010001 AS pop_2000,
       ROUND( (CAST (c2010.p0010001 AS numeric(8, 1)) - c2000.p0010001) 
           / c2000.p0010001 * 100, 1) AS "pct_change",
       pct_change - 1 AS new_pct_change
FROM us_counties_2010 c2010 INNER JOIN us_counties_2000 c2000
ON c2010.state_fips = c2000.state_fips
    AND c2010.county_fips = c2000.county_fips
ORDER BY pct_change DESC;

-- So, a way to do this is to literally add a new col. for pct_change,
-- by copying over the database while making a new col.
-- But this seems overkill.

-- NOTE:
-- In SQL, single quotes are for values, double qutoes are for quoted
-- identifiers(column names, table names, etc.)

-- NOTE:
-- From stackoverflow on why PSQL can't reference same SELECT list vars:
--It's inconvenient sometimes, but it's SQL standard behavior, 
--and it prevents ambiguities. You cannot reference column aliases 
--in the same SELECT list.
-- ANS: They were using LATERAL subqueries. 


--BOOK ANS:
-- Wow. All they did was throw the query into a function. I was overthinking.
SELECT percentile_cont(.5)
       WITHIN GROUP (ORDER BY 
            ROUND( ( CAST(c2010.p0010001 AS numeric(8, 1)) - c2000.p0010001)
                / c2000.p0010001 * 100, 1)) AS percentile_50th 
FROM us_counties_2010 c2010 INNER JOIN us_counties_2000 c2000
ON c2010.state_fips = c2000.state_fips
    AND c2010.county_fips = c2000.county_fips
-- ANS: 3.2 % median change




-- 3)
SELECT c2010.state_us_abbreviation AS "st",
       c2010.geo_name,
       ROUND( ( CAST(c2010.p0010001 AS numeric(8,1)) - c2000.p0010001)
            / c2000.p0010001 * 100, 1) AS "pct_change"
FROM us_counties_2010 c2010 INNER JOIN us_counties_2000 c2000
ON c2010.state_fips = c2000.state_fips
    AND c2010.county_fips = c2000.county_fips
ORDER BY pct_change ASC;

-- St. Bernard Parish, LA had the highest loss change in county pop.
-- This might've been due to Hurricane Katrina.







