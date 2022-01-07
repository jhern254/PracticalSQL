-- Ch. 3 Hw
-- 1)
Text Ans:
Numeric(4, 1), since we need 4 digits total(precision), and 1 digit after the
decimal(scale).


-- 2)
first_name varchar(100),
last_name varchar(100)

Names usually have a small char. length, so expecting to store a certain
char length helps keep the variable small in the DB memory. 
We separate the first and last names to keep the variable neat, although
it is not necessary.

-- 3)
It should throw an error because dates is formatted a specific way in psql.














