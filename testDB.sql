-- Jun Hernandez, github: github.com/jhern254
--
-- This is example PostgreSQL code to create 2 databases. The first database
-- table is based on us_counties_2010.csv, which contains Census data about 
-- every county in the United States, and has 3,143 rows and 91 columns. The 
-- 2nd file is us_counties_2000.csv and has 3,141 rows and 16 columns of data,
-- as an abridged file. Since these are practice datasets, the total size is
-- 1.3 MB.  
-- The Census data is provided by the government, where every 10 years,
-- they conduct a full count of the population and collect demographic data.
-- More info can be found here:
-- www.census.gov/prod/cen2010/briefs/c2010br-01.pdf
--
-- These 2 files are imported into psql as separate tables in a database, then 
-- joined together in order to conduct full analysis.
--
-- The 2nd database is from new_york_addresses, which contains 940,374 rows
-- and 7 columns, at 126 MB. This dataset has information on all New York
-- City addresses.
--
-- The data is imported, a database table is created, as well as indexed and
-- tested to conduct benchmark query performance.


-- CODE:
-- 1st Ex)
--
-- Ex. Create table to prepare for data import from file
CREATE TABLE us_counties_2010 (
    geo_name varchar(90),                   -- Name of the geography
    state_us_abbreviation varchar(2),       -- State/U.S. abbreviation
    summary_level varchar(3),               -- Summary Level
    region smallint,                        -- Region
    division smallint,                      -- Division
    state_fips varchar(2),                  -- State FIPS code
    county_fips varchar(3),                 -- County code
    area_land bigint,                       -- Area (Land) in square meters
    area_water bigint,                      -- Area (Water) in square meters
    population_count_100_percent integer,   -- Population count (100%)
    housing_unit_count_100_percent integer, -- Housing unit count (100%)
    internal_point_lat numeric(10, 7),      -- Internal point (latitude)
    internal_point_lon numeric(10, 7),      -- Internal point (longitude)

 -- This section is referred to as P1. Race:
    p0010001 integer,   -- Total population
    p0010002 integer,   -- Population of one race:
    p0010003 integer,       -- White Alone
    p0010004 integer,       -- Black or African American alone
    p0010005 integer,       -- American Indian and Alaska Native alone
    p0010006 integer,       -- Asian alone
    p0010007 integer,       -- Native Hawaiian and Other Pacific Islander alone
    p0010008 integer,       -- Some Other Race alone
    p0010009 integer,   -- Population of two or more races
    p0010010 integer,   -- Population of two races:
    p0010011 integer,       -- White; Black or African American
    p0010012 integer,       -- White; American Indian and Alaska Native
    p0010013 integer,       -- White; Asian
    p0010014 integer,       -- White; Native Hawaiian and Other Pacific Islander
    p0010015 integer,       -- White; Some Other Race
    p0010016 integer,       -- Black or African American; American Indian and Alaska Native
    p0010017 integer,       -- Black or African American; Asian
    p0010018 integer,       -- Black or African American; Native Hawaiian and Other Pacific Islander
    p0010019 integer,       -- Black or African American; Some Other Race
    p0010020 integer,       -- American Indian and Alaska Native; Asian
    p0010021 integer,       -- American Indian and Alaska Native; Native Hawaiian and Other Pacific Islander
    p0010022 integer,       -- American Indian and Alaska Native; Some Other Race
    p0010023 integer,       -- Asian; Native Hawaiian and Other Pacific Islander
    p0010024 integer,       -- Asian; Some Other Race
    p0010025 integer,       -- Native Hawaiian and Other Pacific Islander; Some Other Race
    p0010026 integer,   -- Population of three races
    p0010047 integer,   -- Population of four races
    p0010063 integer,   -- Population of five races
    p0010070 integer,   -- Population of six races

    -- This section is referred to as P2. HISPANIC OR LATINO, AND NOT HISPANIC OR LATINO BY RACE
    p0020001 integer,   -- Total
    p0020002 integer,   -- Hispanic or Latino
    p0020003 integer,   -- Not Hispanic or Latino:
    p0020004 integer,   -- Population of one race:
    p0020005 integer,       -- White Alone
    p0020006 integer,       -- Black or African American alone
    p0020007 integer,       -- American Indian and Alaska Native alone
    p0020008 integer,       -- Asian alone
    p0020009 integer,       -- Native Hawaiian and Other Pacific Islander alone
    p0020010 integer,       -- Some Other Race alone
    p0020011 integer,   -- Two or More Races
    p0020012 integer,   -- Population of two races
    p0020028 integer,   -- Population of three races
    p0020049 integer,   -- Population of four races
    p0020065 integer,   -- Population of five races
    p0020072 integer,   -- Population of six races

    -- This section is referred to as P3. RACE FOR THE POPULATION 18 YEARS AND OVER
    p0030001 integer,   -- Total
    p0030002 integer,   -- Population of one race:
    p0030003 integer,       -- White alone
    p0030004 integer,       -- Black or African American alone
    p0030005 integer,       -- American Indian and Alaska Native alone
    p0030006 integer,       -- Asian alone
    p0030007 integer,       -- Native Hawaiian and Other Pacific Islander alone
    p0030008 integer,       -- Some Other Race alone
    p0030009 integer,   -- Two or More Races
    p0030010 integer,   -- Population of two races
    p0030026 integer,   -- Population of three races
    p0030047 integer,   -- Population of four races
    p0030063 integer,   -- Population of five races
    p0030070 integer,   -- Population of six races

    -- This section is referred to as P4. HISPANIC OR LATINO, AND NOT HISPANIC OR LATINO BY RACE
    -- FOR THE POPULATION 18 YEARS AND OVER
    p0040001 integer,   -- Total
    p0040002 integer,   -- Hispanic or Latino
    p0040003 integer,   -- Not Hispanic or Latino:
    p0040004 integer,   -- Population of one race:
    p0040005 integer,   -- White alone
    p0040006 integer,   -- Black or African American alone
    p0040007 integer,   -- American Indian and Alaska Native alone
    p0040008 integer,   -- Asian alone
    p0040009 integer,   -- Native Hawaiian and Other Pacific Islander alone
    p0040010 integer,   -- Some Other Race alone
    p0040011 integer,   -- Two or More Races
    p0040012 integer,   -- Population of two races
    p0040028 integer,   -- Population of three races
    p0040049 integer,   -- Population of four races
    p0040065 integer,   -- Population of five races
    p0040072 integer,   -- Population of six races

    -- This section is referred to as H1. OCCUPANCY STATUS
    h0010001 integer,   -- Total housing units
    h0010002 integer,   -- Occupied
    h0010003 integer    -- Vacant
);

-- Copy import from us_counties_2010.csv
COPY us_counties_2010   --relation copied into
FROM '/home/jun/Documents/Programming/us_counties_2010.csv'
WITH (FORMAT CSV, HEADER);

-- Test query
SELECT * FROM us_counties_2010;



-- Second table
--
-- Decennial Census 2000. 
-- Full data dictionary at https://www.census.gov/prod/cen2000/doc/pl94-171.pdf
-- Note: Some non-number columns have been given more descriptive names

CREATE TABLE us_counties_2000 (
    geo_name varchar(90),              -- County/state name,
    state_us_abbreviation varchar(2),  -- State/U.S. abbreviation
    state_fips varchar(2),             -- State FIPS code
    county_fips varchar(3),            -- County code
    p0010001 integer,                  -- Total population
    p0010002 integer,                  -- Population of one race:
    p0010003 integer,                  -- White Alone
    p0010004 integer,                  -- Black or African American alone
    p0010005 integer,                -- American Indian and Alaska Native alone
    p0010006 integer,                  -- Asian alone
    p0010007 integer,       -- Native Hawaiian and Other Pacific Islander alone
    p0010008 integer,                  -- Some Other Race alone
    p0010009 integer,                  -- Population of two or more races
    p0010010 integer,                  -- Population of two races
    p0020002 integer,                  -- Hispanic or Latino
    p0020003 integer                   -- Not Hispanic or Latino:
);

COPY us_counties_2000
FROM '/home/jun/Documents/Programming/us_counties_2000.csv'
WITH (FORMAT CSV, HEADER);


-- Example Simple Queries
-- Finds difference in total population between 2000 and 2010, using joined 
-- table
SELECT c2010.geo_name,
       c2010.state_us_abbreviation AS state,
       c2010.p0010001 AS pop_2010,
       c2000.p0010001 AS pop_2000,
       c2010.p0010001 - c2000.p0010001 AS raw_change,
       round ( (CAST(c2010.p0010001 AS numeric(8, 1)) - c2000.p0010001)
            / c2000.p0010001 * 100, 1) AS pct_change
FROM us_counties_2010 c2010 INNER JOIN us_counties_2000 c2000  
ON c2010.state_fips = c2000.state_fips
    AND c2010.county_fips = c2000.county_fips
      AND c2010.p0010001 <> c2000.p0010001  -- 3 conditions, <> = inequality
ORDER BY pct_change DESC;
-- <> used to find diff. pop. from 2000 to 2010

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




-- 2)
CREATE TABLE new_york_addresses (
    longitude numeric(9, 6),
    latitude numeric(9, 6),
    street_number varchar(10),
    street varchar(32),
    unit varchar(7),
    postcode varchar(5),
    id integer CONSTRAINT new_york_key PRIMARY KEY
);

COPY new_york_addresses
FROM '/home/jun/Documents/Programming/city_of_new_york.csv'
WITH (FORMAT CSV, HEADER);


-- Example Queries
-- BTree index speed a simple search query
-- Data had lots of nulls in unit, check if there are values
SELECT unit
FROM new_york_addresses
WHERE unit IS NOT NULL;

-- Use Analyze w/ Explain kw to show actual execution time
-- Ex. See before and after execution time after adding index to db
EXPLAIN ANALYZE SELECT * FROM new_york_addresses
WHERE street = 'BROADWAY';
-- OUT: Planning time: 0.131 ms, Exec. Time: 30.638 ms

EXPLAIN ANALYZE SELECT * FROM new_york_addresses
WHERE street = '52 STREET';
-- OUT: Planning time: 0.073 ms, Exec. Time: 32.911 ms

EXPLAIN ANALYZE SELECT * FROM new_york_addresses
WHERE street = 'ZWICKY AVENUE';
-- OUT: Planning time: 0.081 ms, Exec. Time: 33.852 ms

-- Now, create index(only Psql) to see diff.
CREATE INDEX street_idx ON new_york_addresses (street);

-- Post idx results:
-- OUT: Used bitmap index scan. Planning time: 0.145 ms, Exec. Time: 2.315 ms
-- OUT: Planning time: 0.069 ms, Exec. Time: 0.965 ms
-- OUT: Planning time: 0.089 ms, Exec. Time: 0.098 ms


