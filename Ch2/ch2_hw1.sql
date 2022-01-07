-- Ch.2 HW

CREATE DATABASE homework;

--1) 
-- Create animal table
CREATE TABLE animals (
    id bigserial CONSTRAINT ani_key PRIMARY KEY,
    animal varchar(100) NOT NULL,
    date_entered date NOT NULL
);

-- Create specific animal table
CREATE TABLE animal_info (
    id bigserial CONSTRAINT info_key PRIMARY KEY,
    animal varchar(100) NOT NULL,
    type varchar(100) NOT NULL,
    name varchar(100) NOT NULL,
    dob date NOT NULL
);


-- 2)
-- Insert ex. data
INSERT INTO animals(animal, date_entered)
VALUES ('Lion', '2021-03-09'),
       ('Seal', '2021-03-01'),
       ('Dolphin', '2021-03-09');

INSERT INTO animal_info(animal, type, name, dob)
VALUES ('Lion', 'Feline', 'Blastmast J', '2020-10-10'),
       ('Seal', 'Sealus', 'Ok', '2020-01-20'),
       ('Dolphin', 'Dolphinus', 'Yesm', '2019-06-01');

-- Look at new tables
SELECT * FROM animals;
SELECT * FROM animal_info;

-- Works

INSERT INTO animals(animal, date_entered)
VALUES ('Donkey' '2020-04-14')  -- Omit comma to see error
-- OUT: Error is syntax error


