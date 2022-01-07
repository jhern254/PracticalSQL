-- Query the Western Longitude (LONG_W) for the largest Northern Latitude 
-- (LAT_N) in STATION that is less than 137.2345
-- Round your answer to  decimal places.

-- ANS:
-- Derived tables(subquery)
SELECT *
FROM (
        SELECT ROUND(LONG_W, 4)
        FROM STATION
        WHERE LAT_N < 137.2345
        ORDER BY LAT_N DESC
      )
WHERE ROWNUM = 1;

-- CTE
WITH 
    temp_t (long_d)
AS
    (
        SELECT ROUND(LONG_W, 4)
        FROM STATION
        WHERE LAT_N < 137.2345
        ORDER BY LAT_N DESC
    )
SELECT long_d
FROM temp_t
WHERE ROWNUM = 1;

-- Select distinct pet names from two tables
SELECT DISTINCT name
FROM (
      SELECT name
      FROM dogs
      UNION
      SELECT name
      FROM cats
      );


-- Fix bad data for records 20 - 100, inclusive
UPDATE enrollments
SET year = '2015'
WHERE id BETWEEN 20 AND 100;

-- Update one table w/ values from another table syntax
UPDATE table
SET column = (
                SELECT column
                FROM table_b
                WHERE table.column = table_b.column
             )
WHERE EXISTS (
                SELECT column
                FROM table_b
                WHERE table.column = table_b.column
             );


-- SQL SELECT INTO copies data from one table into new table
SELECT * INTO CustomersBackup2017
FROM Customers;

SELECT CustomerName, ContactName INTO CustomersBackup2017
FROM Customers;




