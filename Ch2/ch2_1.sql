-- Ch.2
-- select all
SELECT * FROM teachers;

-- can change order in select
SELECT last_name, first_name, salary FROM teachers;

-- use distinct keyword
SELECT DISTINCT school
FROM teachers;

-- find unique combinations w/ another attribute
SELECT DISTINCT school, salary
FROM teachers;

-- sort by desc. order(def. is asc.)
SELECT first_name, last_name, salary
FROM teachers
ORDER BY salary DESC;

-- can sort by multiple attr.
SELECT last_name, school, hire_date
FROM teachers
ORDER BY school ASC, hire_date DESC;



-- Where kw: selects based on criteria via an operator
SELECT last_name, school, hire_date
FROM teachers
WHERE school = 'Myers Middle School'; -- case sensitive

-- more ex. --

-- bug but works lol
SELECT last_name, school, school
FROM teachers 
WHERE first_name = 'Janet';

SELECT first_name, last_name, school
FROM teachers 
WHERE first_name = 'Janet';

SELECT school
FROM teachers 
WHERE school != 'F.D. Roosevelt HS';

SELECT school
FROM teachers 
WHERE school != 'F.D. Roosevelt HS';

SELECT first_name, last_name, hire_date
FROM teachers
WHERE hire_date < '2000-01-01';

SELECT first_name, last_name, salary
FROM teachers
WHERE salary >= 43500;

SELECT first_name, last_name, school, salary
FROM teachers
WHERE salary BETWEEN 40000 and 65000;

-- Like: pattern search using wildcards % for one or more char. or _ for 1
-- Ex: LIKE 'b%', LIKE '%ak%', LIKE '_aker', LIKE 'ba_er' - used to find baker

-- doesn't match since LIKE is case sensitive
SELECT first_name
FROM teachers
WHERE first_name LIKE '%sam';

-- Ilike: postgres case insensitive like
SELECT first_name
FROM teachers
WHERE first_name ILIKE 'sam%';



-- Combining operators with AND and OR
SELECT *
FROM teachers
WHERE school = 'Myers Middle School'
     AND salary < 40000;

SELECT *
FROM teachers
WHERE last_name = 'Cole'
      OR last_name = 'Bush';

-- Parenthesis evaluated first
SELECT *
FROM teachers
WHERE school = 'F.D. Roosevelt HS'
     AND (salary < 38000 OR salary > 40000);


-- Putting it all together
SELECT first_name, last_name, school, hire_date, salary
FROM teachers
WHERE school LIKE '%Roos%'
ORDER BY hire_date DESC;




