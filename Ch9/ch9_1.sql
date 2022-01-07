-- Ch. 9 Inspecting and Modifying Data

-- Import data
CREATE TABLE meat_poultry_egg_inspect (
    est_number varchar(50) CONSTRAINT est_number_key PRIMARY KEY,
    company varchar(100),
    street varchar(100),
    city varchar(30),
    st varchar(2),
    zip varchar(5),
    phone varchar(14),
    grant_date date,
    activites text,
    dbas text
);

COPY meat_poultry_egg_inspect
FROM '/home/jun/Documents/Programming/PracticalSQL/Ch9/MPI_Directory_by_Establishment_Name.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ',');

CREATE INDEX company_idx ON meat_poultry_egg_inspect (company); --make queries faster

-- Check data
SELECT *
FROM meat_poultry_egg_inspect
LIMIT 5;

-- Check # of rows
SELECT count(*)
FROM meat_poultry_egg_inspect;
-- Out: 6287 rows

-- Check NAs - from stackoverflow, is this good?
SELECT *
FROM meat_poultry_egg_inspect
WHERE NOT(meat_poultry_egg_inspect IS NOT NULL); 

-- Check NAs 
SELECT count(*)
FROM meat_poultry_egg_inspect
WHERE NOT(meat_poultry_egg_inspect IS NOT NULL);
-- OUT: 4408

/* 
-- Doesn't work. Why? 
SELECT count(*)
FROM meat_poultry_egg_inspect
WHERE meat_poultry_egg_inspect IS NULL;
-- OUT: 0
*/



-- Ex: find multiple companies at same address
SELECT company,
       street,
       city,
       st,
       count(*) AS address_count
FROM meat_poultry_egg_inspect
GROUP BY company, street, city, st
HAVING count(*) > 1     -- filters Group By comb. to more than 1 only
ORDER BY company, street, city, st;
-- Returns unique comb. of company, street, city, st. Shows mult. addresses only
-- 23 rows only
-- Int: There may be reasons for duplicate listings.



-- Explore more ways this dataset is dirty
-- Ex: Group and count states
SELECT st,
	   count(*) AS st_count
FROM meat_poultry_egg_inspect
GROUP BY st
ORDER BY st;
-- OUT: Finds all st. Last col. shows 3 nulls


-- Using IS NULL to find missing values in st column
SELECT est_number,
       company,
       city,
       st,
       zip
FROM meat_poultry_egg_inspect
WHERE st IS NULL
ORDER BY st NULLS FIRST;    -- make nulls appear first in list
-- OUT: 3 rows where State is NULL, w/ same 2 having NULL city
-- Int: Check file to see if these values are indeed missing. 



-- Check for inconsistently entered data w/ Group By and Count()
-- Shows unduplicated data, to spot variations in spelling in var cols.
SELECT company,
       count(*) AS company_count
FROM meat_poultry_egg_inspect
GROUP BY company
ORDER BY company ASC;   -- def. is ASC
-- OUT: Shows all unique company names, w/ count of locations
-- Int: We see multiple misspellings, like Armour - Eckrich Meats



-- Note: I notice that count(*) is used a lot in EDA

-- Check for unexpected lengths in what should be consistently formatted cols
-- Ex: Check for bad length zip codes, which should be 5 length
SELECT length(zip),
       count(*) AS length_count
FROM meat_poultry_egg_inspect
GROUP BY length(zip)
ORDER BY length(zip) ASC;
-- OUT: 3: 86, 4: 496, 5: 5705
-- Int: Very bad dataset, the zip codes are all messed up. It's possible the 
-- leading 0's in zip codes were dropped somewhere


-- Check which states have shortened zip codes
SELECT st,
       count(*) AS st_count
FROM meat_poultry_egg_inspect
WHERE length(zip) < 5
GROUP BY st
ORDER BY st ASC;
-- Int: There are 9 states that have a zip count less than 5, these are 
-- mostly in states w/ leading 00 zipcodes



-- #######################################
-- #######################################
-- Ex. Fix data
-- 3 problems:
-- 1) Missing values for 3 rows in st col.
-- 2) Inconsistent spelling of at least one company's name
-- 3) Inaccurate ZIP codes due to file conversion

-- Creating Backup Tables
CREATE TABLE meat_poultry_egg_inspect_backup AS
SELECT * FROM meat_poultry_egg_inspect;

-- Check that backup has same data
SELECT
    (SELECT count(*) FROM meat_poultry_egg_inspect) AS original,
    (SELECT count(*) FROM meat_poultry_egg_inspect_backup) AS backup;
-- OUT: Original: 6287, Backup: 6287


-- 1)
-- Use UPDATE to fill missing values
-- Copy state col to new col
ALTER TABLE meat_poultry_egg_inspect ADD COLUMN st_copy varchar(2);
-- Make sure same data type

UPDATE meat_poultry_egg_inspect
SET st_copy = st;

-- Make sure cols are same
SELECT st,
       st_copy
FROM meat_poultry_egg_inspect
ORDER BY st; 

-- Fix data: Update three rows w/ missing state codes
-- Book has correct values to insert
UPDATE meat_poultry_egg_inspect
SET st = 'MN'                   -- value to fill in
WHERE est_number = 'V18677A';   -- primary key value

UPDATE meat_poultry_egg_inspect
SET st = 'AL'
WHERE est_number = 'M45319+P45319';

UPDATE meat_poultry_egg_inspect
SET st = 'WI'
WHERE est_number = 'M263A+P263A+V263A';

-- Find NULLs again 
SELECT est_number,
       company,
       city,
       st,
       zip
FROM meat_poultry_egg_inspect
WHERE st IS NULL;
-- OUT: 0 NULLs 

-- DO NOT RUN AFTER FIXING EX. VALUES
-- Ex. Set back values to original
UPDATE meat_poultry_egg_inspect
SET st = st_copy;

-- OR
UPDATE meat_poultry_egg_inspect original
SET st = backup.st
FROM meat_poultry_egg_inspect_backup backup
WHERE original.est_number = backup.est_number;
-- END Ex. CODE



-- 2)
-- Use UPDATE to fix bad values
-- Work in new col. to avoid tampering w/ orig. data
ALTER TABLE meat_poultry_egg_inspect ADD COLUMN company_standard varchar(100);

UPDATE meat_poultry_egg_inspect
SET company_standard = company; -- copy col.

-- Use Update to modify field values that match a string
UPDATE meat_poultry_egg_inspect
SET company_standard = 'Armour-Eckrich Meats'
WHERE company LIKE 'Armour%';

SELECT company, company_standard    -- Check results
FROM meat_poultry_egg_inspect
WHERE company LIKE 'Armour%';
-- OUT: Company_standard shows correct values for 7 misspellings in orig. comp. var
-- NOTE: Keep orig. company var. for reference




-- 3)
-- Use UPDATE and String Oper(||), which concat., to repair lost leading zeros 
-- Ex. Concatenation: 'abc' || '123', OUT: 'abc123'

-- Make backup of st. col
ALTER TABLE meat_poultry_egg_inspect ADD COLUMN zip_copy varchar(5);

UPDATE meat_poultry_egg_inspect
SET zip_copy = zip;

-- Modify codes w/ String Oper.
UPDATE meat_poultry_egg_inspect
SET zip = '00' || zip
WHERE st IN('PR', 'VI') AND length(zip) = 3; -- Based on data that's missing 00

-- Fix remaining errors
UPDATE meat_poultry_egg_inspect
SET zip = '0' || zip
WHERE st IN('CT', 'MA', 'ME', 'NH', 'NJ', 'RI', 'VT') AND length(zip) = 4;

-- Check for bad length zip codes, which should be 5 length
SELECT length(zip),
       count(*) AS length_count
FROM meat_poultry_egg_inspect
GROUP BY length(zip)
ORDER BY length(zip) ASC;
-- OUT: 5: 6287, All values are correct now 




-- Updating Values Across Tables
-- Listing 9-18: Use other data to update our main tables
CREATE TABLE state_regions (
    st varchar(2) CONSTRAINT st_key PRIMARY KEY,
    region varchar(20) NOT NULL
);

COPY state_regions
FROM '/home/jun/Documents/Programming/PracticalSQL/Ch9/state_regions.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ',');


-- Add col. for inspection dates, then fill w/ New England States
ALTER TABLE meat_poultry_egg_inspect ADD COLUMN inspection_date date;

-- Update one table w/ values from another table - SEE pg. 217 for syntax
UPDATE meat_poultry_egg_inspect inspect     -- rename table for readability
SET inspection_date = '2019-12-01'
WHERE EXISTS (SELECT state_regions.region       -- subquery syntax
              FROM state_regions
              WHERE inspect.st = state_regions.st   -- mini Join: set foreign key = PK
                    AND state_regions.region = 'New England');

-- Check updated table
SELECT st, inspection_date
FROM meat_poultry_egg_inspect
GROUP BY st, inspection_date
ORDER BY st;
-- OUT: Updated inspection dates for all New England companies, still many NA's




-- Deleting Unnecessary Data
-- Deleting rows matching an expression, del. extra states
DELETE FROM meat_poultry_egg_inspect
WHERE st IN('PR', 'VI');    -- Delete Puerto Rico and Virgin Isl. data


-- Delete column from table
-- No longer need zip_copy
ALTER TABLE meat_poultry_egg_inspect DROP COLUMN zip_copy;


-- Delete tables w/ DROP TABLE
DROP  TABLE meat_poultry_egg_inspect_backup;




-- Using Transaction Block: Use to review database changes before finalization
START TRANSACTION;  -- Changes won't be permanent until commit fn

UPDATE meat_poultry_egg_inspect
SET company = 'AGRO Merchantss Oakland LLC' -- purpose mistake
WHERE company = 'AGRO Merchants Oakland, LLC';

-- Check table
SELECT company
FROM meat_poultry_egg_inspect
WHERE company LIKE 'AGRO%'
ORDER BY company;

ROLLBACK;   -- Discard changes made in transaction block

-- Make correct changes and commit
START TRANSACTION;  

UPDATE meat_poultry_egg_inspect
SET company = 'AGRO Merchants Oakland LLC' -- fix mistake
WHERE company = 'AGRO Merchants Oakland, LLC';

-- Check table
SELECT company
FROM meat_poultry_egg_inspect
WHERE company LIKE 'AGRO%'
ORDER BY company;

COMMIT;


-- IMPORTANT:
-- Improving Performance by Creating New Copy Tables instead of updating cols 
-- Create copy of table and add populated col. reviewed_date
CREATE TABLE meat_poultry_egg_inspect_backup AS 
SELECT *,
        '2018-02-07'::date AS reviewed_date -- value cast syntax
FROM meat_poultry_egg_inspect;


-- Swap table names using ALTER TABLE
-- Use new table w/ new col. as main table, and set old table to backup
ALTER TABLE meat_poultry_egg_inspect RENAME TO meat_poultry_egg_inspect_temp;
ALTER TABLE meat_poultry_egg_inspect_backup
  RENAME TO meat_poultry_egg_inspect;
ALTER TABLE meat_poultry_egg_inspect_temp
  RENAME TO meat_poultry_egg_inspect_backup;











