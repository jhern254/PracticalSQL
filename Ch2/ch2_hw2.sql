-- Ch. 2 HW2 
-- 1)
-- Query 
SELECT first_name, last_name, school
FROM teachers
ORDER BY school, last_name ASC;


-- 2)
SELECT first_name, school, salary
FROM teachers
WHERE first_name ILIKE 'S%' 
     AND salary > 40000;


-- 3)
SELECT *
FROM teachers
WHERE hire_date >= '2010-01-01'
ORDER BY salary DESC;










