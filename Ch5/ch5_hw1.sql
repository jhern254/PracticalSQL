-- Ch5 hw1
-- 1)
-- Area of circle: A = pi * (r^2)
SELECT PI() * (5 ^ 2);

-- Limit decimals
SELECT PI() * ( CAST ((5^2) AS numeric(4, 2)))
-- Doesn't work

SELECT CAST(PI() * (5 ^ 2) AS numeric(4, 2)); 
-- Correct, 78.54

-- 2)
SELECT geo_name,
       state_us_abbreviation ILIKE 'NY%' AS "st", 
       p0010001 AS "Total Pop.",
       p0010005 AS "Am Indian/Alaska Native Alone" 
FROM us_counties_2010
ORDER BY p0010005 DESC
LIMIT 10;

-- prototype query
SELECT geo_name,
       state_us_abbreviation AS "st", 
       p0010001 AS "Total Pop.",
       p0010005 AS "Am Indian/Alaska Native Alone" 
FROM us_counties_2010
WHERE state_us_abbreviation = 'NY'
ORDER BY p0010005 DESC
LIMIT 10;

-- query
SELECT geo_name,
       state_us_abbreviation AS "st", 
       p0010001 AS "Total_Pop.",
       p0010005 AS "Am_Indian/Alaska_Native_Alone",
       (CAST (p0010005 AS numeric(8, 1)) / p0010001) * 100 AS "pct_native"
       -- some rule involving needing 8 prec. and 1 scale
FROM us_counties_2010
WHERE state_us_abbreviation = 'NY'
ORDER BY pct_native DESC
LIMIT 10;
-- Works. Franklin County has the highest percentage at 7.36% Native because
-- there is a reservation on the border of the county.


-- Own query for curiousity
SELECT geo_name,
       state_us_abbreviation AS "st",
       p0010001 AS "Total Pop.",
       p0010006 AS "Asian Pop.",
       p0010024 AS "Asian/ Other Race",
       p0020002 AS "Hispanic or Latino",
       p0020008 AS "Asian/ Hispanic"
FROM us_counties_2010
WHERE state_us_abbreviation = 'CA'
-- NOTE: Make sure to name cols. w/ underscore and NO spaces


-- 3)
SELECT state_us_abbreviation AS "st", 
       sum(p0010001) AS "County Sum",
       percentile_cont(.5)
       WITHIN GROUP (ORDER BY p0010001) AS "County_Median"
FROM us_counties_2010
WHERE state_us_abbreviation = 'CA'
      OR state_us_abbreviation = 'NY'
GROUP BY st
ORDER BY "County_Median" DESC;

-- Because this is an aggregate fn, I'm not sure how to list 2 separate
-- states, besides grouping state names w/ the pop.
-- ANS: Fixed code.
-- California has a higher county median w/ 179140.5, and NY w/ 91301. 


ALT ANS:
SELECT state_us_abbreviation AS "st",
       percentile_cont(.5)
       WITHIN GROUP (ORDER BY p0010001) AS "County_Median"
FROM us_counties_2010
WHERE state_us_abbreviation IN ('NY', 'CA')
GROUP BY state_us_abbreviation;
-- Better syntax, use IN() for matching strings instead of =




