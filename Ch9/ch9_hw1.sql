-- Ch. 9 HW
-- Questions are general, but need to do step by step data cleaning to ans.

-- 1)

-- Delete table w/ just in case it exists
DROP  TABLE meat_poultry_egg_inspect_backup;

-- Create backup table
CREATE TABLE meat_poultry_backup AS
SELECT * FROM meat_poultry_egg_inspect;

-- Check that backup has same data
SELECT
    (SELECT count(*) FROM meat_poultry_egg_inspect) AS original,
    (SELECT count(*) FROM meat_poultry_backup) AS backup;



-- Use trans. block to add new cols.
START TRANSACTION; 

ALTER TABLE meat_poultry_egg_inspect ADD COLUMN meat_processing boolean,
ALTER TABLE meat_poultry_egg_inspect ADD COLUMN poultry_processing boolean;

-- Check table
SELECT meat_processing, poultry_processing
FROM meat_poultry_egg_inspect;

-- Doesn't work. Forgot how to count all nulls
SELECT count(meat_processing)
FROM meat_poultry_egg_inspect
WHERE "meat_processing" IS NULL;

-- Work around. Works.
SELECT count(*)
FROM meat_poultry_egg_inspect
WHERE meat_processing IS NULL;
-- Matches row #

-- Commit changes to table
COMMIT;


-- 2)
-- This is a good lesson in checking code.
-- I accidentally named activities activites, and only noticed now.

-- Use trans. block to add new cols.
START TRANSACTION; 

ALTER TABLE meat_poultry_egg_inspect
RENAME COLUMN activites TO activities;

-- Check table
SELECT *
FROM meat_poultry_egg_inspect
LIMIT 5;

-- Commit changes to table
COMMIT;



-- Use trans. block to add new cols.
START TRANSACTION;

UPDATE meat_poultry_egg_inspect
SET meat_processing = TRUE
WHERE activities ILIKE '%Meat Processing%';

UPDATE meat_poultry_egg_inspect
SET poultry_processing = TRUE
WHERE activities ILIKE '%Poultry Processing%';


-- Check table
SELECT count(*)
FROM meat_poultry_egg_inspect
WHERE meat_processing = TRUE;

SELECT count(*)
FROM meat_poultry_egg_inspect;
-- Looks good, about 4.7k cols. changed


-- Check table
SELECT count(*)
FROM meat_poultry_egg_inspect
WHERE poultry_processing = TRUE;
-- About 3.7k cols. changed


-- Commit changes to table
COMMIT;




-- 3)
-- Already counted before. Going to count both
SELECT count(*)
FROM meat_poultry_egg_inspect
WHERE poultry_processing = TRUE 
    AND meat_processing = TRUE;
-- 3,338 plants in the dataset perform both activities


-- Book Ans. For counting vars
SELECT count(meat_processing), count(poultry_processing)
FROM meat_poultry_egg_inspect;




