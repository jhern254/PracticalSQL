-- Ch.5
-- Using select for math and string oper.
SELECT 2 + 2;
SELECT 9 - 1;
SELECT 3 * 4;

SELECT 11 / 6;          -- returns 1, int
SELECT 11 % 6;          -- 5, int
SELECT 11.0 / 6;        -- 1.8333, numeric
SELECT CAST (11 AS numeric(3,1)) / 6;   -- 1.8333, numeric

--PostgreSQL specific oper.
SELECT 3^4;         -- 81, double prec.
SELECT |/ 10;       -- 3.162, double prec. Sqrt fn
SELECT sqrt(10);    -- 3.162, double prec. 
SELECT ||/ 10;      -- 2.154, double prec., cube root fn
SELECT 4 !;         -- 24, numeric, factorial fn

-- Order of oper.
SELECT 7 + 8 * 9;
SELECT (7 + 8) * 9;

SELECT 3 ^ 3 - 1;
SELECT 3 ^ (3 - 1);


-- Doing math on Relations
SELECT * FROM us_counties_2010
LIMIT 4;    -- kind of like head()

-- Use AS keyword to rename attributes
SELECT geo_name,
       state_us_abbreviation AS "st",
       p0010001 AS "Total Population",
       p0010003 AS "White Alone",
       p0010004 AS "Black or African American Alone",
       p0010005 AS "Am Indian/Alaska Native Alone",
       p0010006 AS "Asian Alone",
       p0010007 AS "Native Hawaiian and Other Pacific Islander Alone",
       p0010008 AS "Some Other Race Alone",
       p0010009 AS "Two or More Races"
FROM us_counties_2010;

-- Add cols.
SELECT geo_name,
       state_us_abbreviation AS "st",
       p0010003 AS "White Alone",
       p0010004 AS "Black Alone",
       p0010003 + p0010004 AS "Total White and Black"
FROM us_counties_2010;

-- Play query
SELECT geo_name,
       state_us_abbreviation AS "st" ILIKE '%CA', -- can't combine?
       p0010001 AS "Total Population"
FROM us_counties_2010;
-- doesn't work

-- Play query
SELECT geo_name,
       state_us_abbreviation ILIKE '%CA' AS "st", -- works now
       p0010001 AS "Total Population"
FROM us_counties_2010;
-- Doesn't return what I want, gives ?column? bool
-- TODO: fix this


-- Checks if totals add == totals. Works, diff = 0
SELECT geo_name,
       state_us_abbreviation AS "st",
       p0010001 AS "Total",                                 -- int 
       p0010003 + p0010004 + p0010005 + p0010006 + p0010007
            + p0010008 + p0010009 AS "All Races",           -- int
       (p0010003 + p0010004 + p0010005 + p0010006 + p0010007
            + p0010008 + p0010009) - p0010001 AS "Difference" -- int
FROM us_counties_2010
ORDER BY "Difference" DESC; -- Order by new col. rename
-- Use order by on diff. desc to check if there are any bad values, since 
-- they should all be 0


-- Finding Percentages of the Whole
SELECT geo_name,
       state_us_abbreviation AS "st",
       (CAST (p0010006 AS numeric(8, 1)) / p0010001) * 100 AS "pct_asian"   
       -- any oper. involving numeric outputs numeric
FROM us_counties_2010
ORDER BY "pct_asian" DESC;


-- Percent change over time
-- FORMULA: (new_number - old_number) / old_number

-- Create test data
CREATE TABLE percent_change (
    department varchar(20),
    spend_2014 numeric(10, 2),
    spend_2017 numeric(10, 2)
);

INSERT INTO percent_change
VALUES
    ('Building', 250000, 289000),
    ('Assessor', 178556, 179500),
    ('Library', 87777, 90001),
    ('Clerk', 451980, 650000),
    ('Police', 250000, 223000),
    ('Recreation', 199000, 195000)

SELECT department,
       spend_2014, 
       spend_2017,
       round( (spend_2017 - spend_2014) /
                    spend_2014 * 100, 1) AS "pct_change"
FROM percent_change
-- So, select can create new calc. attributes easy, but they're temp



-- Aggregate fns for cols., avg() and sum()
SELECT p001000 AS "Total",
       sum(p0010001) AS "County Sum",
       round(avg(p0010001), 0) AS "County Average"
FROM us_counties_2010;
-- doesn't work, cannot have p0010001 with aggregate fns? ANS: yes, see below

SELECT sum(p0010001) AS "County Sum",
       round(avg(p0010001), 0) AS "County Average"
FROM us_counties_2010;
-- This aggregates all of p0010001, so output 1 row, 2 cols
-- Gives total of County Sum as biging, County avg. as Numeric
-- Total US Pop: 3.08 mill in 2010, w/ avg. per county 98k


-- Calculating medians using quantiles(no built in median fn)
CREATE TABLE percentile_test (
    numbers integer
);

INSERT INTO percentile_test (numbers) VALUES
    (1), (2), (3), (4), (5), (6);
-- Shorthand syntax

SELECT 
    percentile_cont(.5)
    WITHIN GROUP (ORDER BY numbers),
    percentile_disc(.5)
    WITHIN GROUP (ORDER BY numbers)
FROM percentile_test; 
-- WITHIN GROUP new fn
-- Cont. returns 3.5, Disc returns 3
-- To find median, use cont.


-- Add median to prev. aggregate
SELECT sum(p0010001) AS "County Sum",
       round(avg(p0010001), 0) AS "County Average",
       percentile_cont(.5)
       WITHIN GROUP (ORDER BY p0010001) AS "County Median"
FROM us_counties_2010;

-- Use array to find quartiles
SELECT percentile_cont(array[.25, .5, .75])
       WITHIN GROUP (ORDER BY p0010001) AS "quartiles"
FROM us_counties_2010;
-- return type is double prec.

-- Use unnest for better readability
SELECT unnest(
        percentile_cont(array[.25, .5, .75])
        WITHIN GROUP (ORDER BY p0010001) 
) AS "quartiles"
FROM us_counties_2010;




-- Creating a median fn
CREATE OR REPLACE FUNCTION _final_median(anyarray)
    RETURNS float8 AS
$$
   WITH q AS 
   (
        SELECT val
        FROM unnest($1) val
        WHERE VAL IS NOT NULL
        ORDER BY 1 
   ),
   cnt AS
   (
    SELECT COUNT(*) AS c FROM q
   )
   SELECT AVG(val)::float8
   FROM
   (
    SELECT val FROM q
    LIMIT 2 - MOD((SELECT c FROM cnt), 2)
    OFFSET GREATEST(CEIL((SELECT c FROM cnt) / 2.0) - 1, 0)
   ) q2;
$$
LANGUAGE sql IMMUTABLE;

CREATE AGGREGATE median(anyelement) (
  SFUNC = array_append,
  STYPE = anyarray,
  FINALFUNC = _final_median,
  INITCOND = '{}'
);

-- Use median fn
SELECT sum(p0010001) AS "County Sum",
       round(avg(p0010001), 0) AS "County Average",
       median(p0010001) AS "County Median",
       percentile_cont(.5)
       WITHIN GROUP (ORDER BY p0010001) AS "50th Percentile"
FROM us_counties_2010;
-- County Median and 50th perc. give same results



-- Find mode
SELECT mode() WITHIN GROUP (ORDER BY p0010001)
FROM us_counties_2010;






