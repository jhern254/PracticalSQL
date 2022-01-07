-- Ch.7 Table Design - fns to keep data integrity
-- Primary key ex., Constraint keyword

-- column constraint ex.
CREATE TABLE natural_key_example (
    license_id varchar(10) CONSTRAINT license_key PRIMARY KEY,
    first_name varchar(50),
    last_name varchar(50)
);

DROP TABLE natural_key_example;

-- table constraint ex.
CREATE TABLE natural_key_example (
    license_id varchar(10),
    first_name varchar(50),
    last_name varchar(50),
    CONSTRAINT license_key PRIMARY KEY (license_id)
);


-- Ex. PK keeps integrity of data
INSERT INTO natural_key_example (license_id, first_name, last_name)
VALUES ('T229901', 'Lynn', 'Malero');

INSERT INTO natural_key_example (license_id, first_name, last_name)
VALUES ('T229901', 'Sam', 'Tracy');
-- Gives error, duplicate key value violates unique constraint




-- Composite primary key: mult. PK, MUST declare using table constraint syntax
CREATE TABLE natural_key_composite_example (
    student_id varchar(10),
    school_day date,
    present boolean,
    CONSTRAINT student_key PRIMARY KEY (student_id, school_day) -- grouped PK
);

-- Ex. Simulate violation entry
INSERT INTO natural_key_composite_example (student_id, school_day, present)
VALUES(775, '1/22/2017', 'Y');

INSERT INTO natural_key_composite_example (student_id, school_day, present)
VALUES(775, '1/23/2017', 'Y');
-- These 2 work

INSERT INTO natural_key_composite_example (student_id, school_day, present)
VALUES(775, '1/23/2017', 'N');
-- Throws same error




-- NOTE: Book seems to rec. Natural keys over Surrogate(artificial) keys
-- NOTE: Says to check database structure if no natural keys
-- Ex. Surrogate keys
CREATE TABLE surrogate_key_example (
    order_number bigserial, -- ALWAYS use bigserial for inc. datatype
    product_name varchar(50),
    order_date date,
    CONSTRAINT order_key PRIMARY KEY (order_number)
);

INSERT INTO surrogate_key_example (product_name, order_date)
VALUES ('Beachball Polish', '2015-03-17'),
       ('Wrinkle De-Atomizer', '2017-05-22'), 
       ('Flux Capacitor', '1985-10-26');
SELECT * FROM surrogate_key_example;
-- Order number is PK




-- Foreign key ex
CREATE TABLE licenses (
    license_id varchar(10),
    first_name varchar(50),
    last_name varchar(50),
    CONSTRAINT licenses_key PRIMARY KEY (license_id)
);

CREATE TABLE registrations (
    registration_id varchar(10),
    registration_date date,
    license_id varchar(10) REFERENCES licenses (license_id),    -- has to be same name
    CONSTRAINT registration_key PRIMARY KEY (registration_id, license_id)
);

INSERT INTO licenses (license_id, first_name, last_name)
VALUES ('T229901', 'Lynn', 'Malero');

INSERT INTO registrations (registration_id, registration_date, license_id)
VALUES ('A203391', '3/17/2017', 'T229901');
-- These 2 work, since T22 ref. key exists in ref. table

INSERT INTO registrations (registration_id, registration_date, license_id)
VALUES ('A75772', '3/17/2017', 'T000001');
-- Throws error: insert into table violates foreign key constraint
-- Key T00.. not present in table licenses


-- ON DELETE CASCADE keywords: auto delete related records
DROP TABLE registrations;

CREATE TABLE registrations (
    registration_id varchar(10),
    registration_date date,
    license_id varchar(10) REFERENCES licenses (license_id) ON DELETE CASCADE,    
    CONSTRAINT registration_key PRIMARY KEY (registration_id, license_id)
);




-- Check Constraint: VERY useful, prevents bad data
-- Table constraint syntax
CREATE TABLE check_constraint_ex (
    user_id bigserial,      -- surrogate PK
    user_role varchar(50),
    salary integer,
    CONSTRAINT user_id_key PRIMARY KEY (user_id),   -- setting PK
    CONSTRAINT chech_role_in_list CHECK (user_role IN('Admin', 'Staff')),
    CONSTRAINT check_salary_not_zero CHECK (salary > 0)
);
-- Check syntax: name_check CHECK (logical_expression)
-- using IN() operator



-- Unique constraint: ensures uniq. value in each row, but allows NULLs
CREATE TABLE unique_constraint_ex (
    contact_id bigserial CONSTRAINT contact_id_key PRIMARY KEY,
    first_name varchar(50),
    last_name varchar(50),
    email varchar(200),
    CONSTRAINT email_unique UNIQUE (email)
);

INSERT INTO unique_constraint_ex (first_name, last_name, email)
VALUES ('Samantha', 'Lee', 'slee@example.org');

INSERT INTO unique_constraint_ex (first_name, last_name, email)
VALUES ('Betty', 'Diaz', 'bdiaz@example.org');

INSERT INTO unique_constraint_ex (first_name, last_name, email)
VALUES ('Sasha', 'Lee', 'slee@example.org');
-- Throws error, duplicate key value

INSERT INTO unique_constraint_ex (first_name, last_name)
VALUES ('Sara', 'Lee');
-- Valid insert. Leaves null in email var



-- Not Null Constraint: no empty cols
CREATE TABLE not_null_ex (
    student_id bigserial,
    first_name varchar(50) NOT NULL,
    last_name varchar(50) NOT NULL,
    CONSTRAINT student_id_key PRIMARY KEY (student_id)
);

INSERT INTO not_null_ex (first_name)
VALUES ('Samantha');
-- throws error


-- Alter table: remove constraints or constraints on cols. like Not Null
ALTER TABLE not_null_ex DROP CONSTRAINT student_id_key;
ALTER TABLE not_null_ex ADD CONSTRAINT student_id_key PRIMARY KEY
(student_id);

ALTER TABLE not_null_ex ALTER COLUMN first_name DROP NOT NULL; 
ALTER TABLE not_null_ex ALTER COLUMN first_name SET NOT NULL;



-- BTree index speed a simple search query
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
FROM '/home/jun/Documents/Programming/PracticalSQL/Ch7/city_of_new_york.csv'
WITH (FORMAT CSV, HEADER);

-- Data had lots of nulls in unit, check if there are values
SELECT unit 
FROM new_york_addresses
WHERE unit IS NOT NULL;
-- Works. Where has to go AFTER From
-- TODO: Find how many nulls there are

-- Use Analyze w/ Explain kw to show actual execution time
-- Ex. See before and after execution time after adding index to db
EXPLAIN ANALYZE SELECT * FROM new_york_addresses
WHERE street = 'BROADWAY';
-- explain and analyze return execution statistics
-- OUT: Book says uses sequential scan. Planning time: 0.131 ms, Exec. Time: 30.638 ms

EXPLAIN ANALYZE SELECT * FROM new_york_addresses
WHERE street = '52 STREET';
-- OUT: Planning time: 0.073 ms, Exec. Time: 32.911 ms

EXPLAIN ANALYZE SELECT * FROM new_york_addresses
WHERE street = 'ZWICKY AVENUE';
-- OUT: Planning time: 0.081 ms, Exec. Time: 33.852 ms

-- Now, create index(only Psql) to see diff.
CREATE INDEX street_idx ON new_york_addresses (street);
-- Why street?

-- Post idx results:
-- OUT: Used bitmap index scan. Planning time: 0.145 ms, Exec. Time: 2.315 ms 
-- OUT: Planning time: 0.069 ms, Exec. Time: 0.965 ms 
-- OUT: Planning time: 0.089 ms, Exec. Time: 0.098 ms 








