-- Ch. 12 - Advanced Query Techniques

-- Finds counties where total pop. is >= median, in one query
SELECT geo_name,
       state_us_abbreviation,
       p0010001
FROM us_counties_2010
WHERE p0010001 >= (
    SELECT percentile_cont(.9) WITHIN GROUP (ORDER BY p0010001)
    FROM us_counties_2010
    )
ORDER BY p0010001 DESC;

-- NOTE: Can also run subquery separately in PgAdmin. Returns 197.. 
-- which is given to WHERE statement


-- Subset Data
-- Ex. Subset data w/ subquery to delete rows and copy table

-- Copy table
CREATE TABLE us_counties_2010_top10 AS
SELECT * FROM us_counties_2010;

-- Use subqueries to delete
DELETE FROM us_counties_2010_top10
WHERE p0010001 < (
    SELECT percentile_cont(.9) WITHIN GROUP (ORDER BY p0010001)
    FROM us_counties_2010_top10
    );
-- Delete 2828

-- Count remaining rows in new table
SELECT count(*) FROM us_counties_2010_top10;
-- 315 Rows left




-- Creating Dervived Tables: create subquery table in FROM clause
-- Calculate mean, median, and diff. between them in one query
SELECT round(calcs.average, 0) AS average,
       calcs.median,
       round(calcs.average - calcs.median, 0) AS median_average_diff
FROM (
    SELECT avg(p0010001) AS average,
           percentile_cont(.5)
              WITHIN GROUP(ORDER BY p0010001)::numeric(10, 1) AS median  
              -- CAST syntax
    FROM us_counties_2010
    )
AS calcs;

-- So, use From to create new derived table, THEN select from newly made table
--Int: The diff. is quite a lot, Avg: 98k, Med: 25k, Diff: 72k. This means
-- it's better to use the median since the avg. is biased by outliers.




-- Joining Derived tables
-- Listing 12-4 - There is cleaner way to write in Listing 12-8 
SELECT census.state_us_abbreviation AS st,
       census.st_population,
       plants.plant_count,
       round((plants.plant_count / census.st_population::numeric(10, 1))*1000000,
            1)
    AS plants_per_million
FROM    -- Write first 
    (               -- Use aggregate fns
        SELECT st,
              count(*) AS plant_count
        FROM meat_poultry_egg_inspect
        GROUP BY st
    )
    AS plants
JOIN
    (   -- Write 2nd
        SELECT state_us_abbreviation,
              sum(p0010001) AS st_population
        FROM us_counties_2010
        GROUP BY state_us_abbreviation
    )
    AS census
ON plants.st = census.state_us_abbreviation
ORDER BY plants_per_million DESC;       -- var made in main query

-- Note: To write easier, Write FROM derived_table1, then JOIN w/ 
-- deriv._table2, then write main SELECT query

-- Int: Top state is NE, which makes sense since Nebraska is a top cattle
-- exporter, and bottom state has few plants, like Washington DC.




-- Generating Columns w/ Subqueries - usually w/ aggregate fn output values
-- Creates new median col. w/ subquery
SELECT geo_name,
       state_us_abbreviation AS st,
       p0010001 AS total_pop,
       (SELECT percentile_cont(.5) WITHIN GROUP (ORDER BY p0010001)
        FROM us_counties_2010) AS us_median
FROM us_counties_2010; 


-- Using same method, create new col. w/ diff. from median
-- This is trick question, because as I learned earlier, can't ref. 
-- made value from main select query, so have to reuse code.

-- Listing 12-6. Made better using CTE's in Listing 12-9
SELECT geo_name,
       state_us_abbreviation AS st,
       p0010001 AS total_pop,
       (SELECT percentile_cont(.5) WITHIN GROUP (ORDER BY p0010001)
        FROM us_counties_2010) AS us_median,
       p0010001 - (SELECT percentile_cont(.5) WITHIN GROUP (ORDER BY p0010001)
        FROM us_counties_2010) AS diff_from_median
FROM us_counties_2010
WHERE (p0010001 - (SELECT percentile_cont(.5) WITHIN GROUP (ORDER BY p0010001)
        FROM us_counties_2010))
    BETWEEN -1000 AND 1000; -- narrow results to county pop. not far from med.

-- Note: Have to rewrite code a lot. Also, don't have to include us_median var.
-- OUT: 71 counties are between -1000 to 1000 far from the US median county pop.




-- Subquery Expressions - only 2 covered in book, see doc. for rest
-- Used in WHERE clause, usually to filter rows on some evaluation

-- IN (subquery) - check matching values
SELECT first_name, last_name
FROM employees
WHERE id IN (
    SELECT id
    FROM retirees);
-- Output are names of employees who have id values that match in retirees tab.


-- EXISTS (subquery) - check if values exist, w/ T/F test.
SELECT first_name, last_name
FROM employees
WHERE EXISTS (
    SELECT id
    FROM retirees);
-- Out: Returns all names, if id exists in retirees table.


SELECT first_name, last_name
FROM employees
WHERE EXISTS (
    SELECT id
    FROM retirees
    WHERE id = employees.id);
-- Change so only returns if it finds one match


-- NOT kw w/ EXISTS
-- Find employees w/ no corresponding record in retirees table
SELECT first_name, last_name
FROM employees
WHERE NOT EXISTS (
    SELECT id
    FROM retirees
    WHERE id = employees.id);

-- NOTE: Not w/ Exists useful for assessing whether dataset is complete.



-- IMPORTANT ########################
-- Common Table Expressions(CTE)
-- Using WITH clause, creates 1 or more temp tables for querying

-- Create CTE to filter large counties w/ pop. >= 100,000
WITH 
    large_counties (geo_name, st, p0010001)
AS
    (
        SELECT geo_name, state_us_abbreviation, p0010001
        FROM us_counties_2010
        WHERE p0010001 >= 100000
    )
SELECT st, count(*) -- main query
FROM large_counties
GROUP BY st
ORDER BY count(*) DESC;
-- Define CTE table w/ vars, write subquery to get vars, write main query

-- Int: TX, CA, and FL are the top 3 states
-- #################################################
-- IMPORTANT NOTE: In SQL, this is how to not repeat code in Select.


-- Rewrite Listing 12-4 using CTE
-- Listing 12-8
WITH                                -- CTE 1
    counties (st, population) AS
    (SELECT state_us_abbreviation, sum(population_count_100_percent)
    FROM us_counties_2010
    GROUP BY state_us_abbreviation),

    plants (st, plants) AS          -- CTE 2
    (SELECT st, count(*) AS plants
     FROM meat_poultry_egg_inspect
     GROUP BY st)

SELECT counties.st,                 -- Main query
       population,
       plants,
       round((plants/population::numeric(10, 1)) * 1000000, 1) AS per_million
FROM counties JOIN plants           -- Join on CTE temp tables
ON counties.st = plants.st 
ORDER BY per_million DESC;



-- Rewrite Listing 12-6 using CTE
-- Listing 12-9
WITH us_median AS   -- no listed vars, get all vars from subquery, only 1
    (SELECT percentile_cont(.5)
     WITHIN GROUP (ORDER BY p0010001) AS us_median_pop
     FROM us_counties_2010)

SELECT geo_name,
       state_us_abbreviation AS st,
       p0010001 AS total_pop,
       us_median_pop,           -- new var
       p0010001 - us_median_pop AS diff_from_median
FROM us_counties_2010 CROSS JOIN us_median --makes value available to every row 
WHERE (p0010001 - us_median_pop)
    BETWEEN -1000 AND 1000;

-- NOTE: ##########################
-- CTE is the best to use, to have readable, modifiable, and non repeated
-- code queries.




-- Install crosstab PostreSQL fn, within tablefunc module
CREATE EXTENSION tablefunc;

-- Import data
CREATE TABLE ice_cream_survey (
    response_id integer PRIMARY KEY,
    office varchar(20),
    flavor varchar(20)
);

COPY ice_cream_survey
FROM '/home/jun/Documents/Programming/PracticalSQL/Ch12/ice_cream_survey.csv'
WITH (FORMAT CSV, HEADER)

-- Inspect data
SELECT *
FROM ice_cream_survey
LIMIT 5;


-- Generate CrossTab
SELECT *
FROM crosstab('SELECT office,   -- SQ1: Generates data for crosstab, w/ 3 cols
                      flavor,
                      count(*)
               FROM ice_cream_survey
               GROUP BY office, flavor
               ORDER BY office',

              'SELECT flavor    -- SQ2: produces set of categ. col. names
               FROM ice_cream_survey
               GROUP BY flavor  -- Can only output 1 col., so use Group By for vars
               ORDER BY flavor')

AS (office varchar(20),
    chocolate bigint,       -- alpha. order since same order as subquery
    strawberry bigint,
    vanilla bigint);

-- OUT: Can see results of survey




-- Tabulating City Temp. Readings
CREATE TABLE temperature_readings (
    reading_id bigserial,
    station_name varchar(50),
    observation_date date,
    max_temp integer,
    min_temp integer
);

COPY temperature_readings
    (station_name, observation_date, max_temp, min_temp)
FROM '/home/jun/Documents/Programming/PracticalSQL/Ch12/temperature_readings.csv'
WITH (FORMAT CSV, HEADER);

-- Create temp. readings crosstabs
SELECT *
FROM crosstab('SELECT 
                  station_name,             -- names rows
                  -- names cols
                  date_part(''month'', observation_date),   -- '' syntax?
                  percentile_cont(.5)
                        WITHIN GROUP (ORDER BY max_temp)
               FROM temperature_readings
               GROUP BY station_name,
                        date_part(''month'', observation_date)
               ORDER BY station_name',

               'SELECT month
                FROM generate_series(1, 12) month')

AS (station varchar(50),
    jan numeric(3, 0),
    feb numeric(3, 0),
    mar numeric(3, 0),
    apr numeric(3, 0),
    may numeric(3, 0),
    jun numeric(3, 0),
    jul numeric(3, 0),
    aug numeric(3, 0),
    sep numeric(3, 0),
    oct numeric(3, 0),
    nov numeric(3, 0),
    dec numeric(3, 0)
);
-- OUT: Shows table w/ 3 stations, and all 12 months




-- Using CASE keyword - multiple cases
SELECT max_temp,                            -- only 1 var
       CASE WHEN max_temp >= 90 THEN 'Hot'
            WHEN max_temp BETWEEN 70 AND 89 THEN 'Warm'
            WHEN max_temp BETWEEN 50 AND 69 THEN 'Pleasant'
            WHEN max_temp BETWEEN 33 AND 49 THEN 'Cold'
            WHEN max_temp BETWEEN 20 AND 32 THEN 'Freezing'
            ELSE 'Inhumane'
       END AS temperature_group             -- names col.
FROM temperature_readings;



-- Case is good for data preprocessing
-- Use CASE w/ CTE
-- Syntax: WITH ... AS -> Main Query

WITH temps_collapsed (station_name, max_temperature_group) AS
    (SELECT station_name,
           CASE WHEN max_temp >= 90 THEN 'Hot'
                WHEN max_temp BETWEEN 70 AND 89 THEN 'Warm'
                WHEN max_temp BETWEEN 50 AND 69 THEN 'Pleasant'
                WHEN max_temp BETWEEN 33 AND 49 THEN 'Cold'
                WHEN max_temp BETWEEN 20 AND 32 THEN 'Freezing'
                ELSE 'Inhumane'
            END
     FROM temperature_readings)

SELECT station_name, max_temperature_group, count(*)
FROM temps_collapsed
GROUP BY station_name, max_temperature_group
ORDER BY station_name, count(*) DESC;

-- OUT: Shows unique comb. of station_name and temp_group, and number of days
-- in temperature group.
-- Int: Waikiki HI has 361 days of warm, and 5 of hot lol









