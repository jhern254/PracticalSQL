-- Ch. 12 HW

-- Listing 12-15

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

-- 1)
-- Do more EDA on Waikiki data

WITH hawaii_temps (station_name, max_temp_group) AS
    (SELECT station_name,
           CASE WHEN max_temp >= 90 THEN '90 or more'
                WHEN max_temp BETWEEN 88 AND 89 THEN '88-89'
                WHEN max_temp BETWEEN 86 AND 87 THEN '86-87'
                WHEN max_temp BETWEEN 84 AND 85 THEN '84-85'
                WHEN max_temp BETWEEN 82 AND 83 THEN '82-83'
                WHEN max_temp BETWEEN 80 AND 81 THEN '80-81'
                ELSE '79 or less'
           END
     FROM temperature_readings
     WHERE station_name ILIKE 'WAIKIKI%')
-- Main query
SELECT station_name, max_temp_group, count(*)
FROM hawaii_temps
GROUP BY station_name, max_temp_group
ORDER BY station_name, count(*) DESC;

--ANS: 86-87 temp group had the most days at 118



-- Listing 12-11
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

-- 2)
SELECT *
FROM crosstab('SELECT flavor,
                      office,
                      count(*)
               FROM ice_cream_survey
               GROUP BY flavor, office
               ORDER BY flavor',

              'SELECT office
               FROM ice_cream_survey
               GROUP BY office
               ORDER BY office') 

AS (flavors varchar(20),
    Downtown bigint,
    Midtown bigint,
    Uptown bigint);

-- Ans: The counts are the same, the matrix was just transposed.








