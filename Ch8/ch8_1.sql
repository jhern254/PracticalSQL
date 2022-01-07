-- Ch. 8: Aggregate fns

- Listing 8-1: Creating and filling the 2014 Public Libraries Survey table

CREATE TABLE pls_fy2014_pupld14a (
    stabr varchar(2) NOT NULL,
    fscskey varchar(6) CONSTRAINT fscskey2014_key PRIMARY KEY,
    libid varchar(20) NOT NULL,
    libname varchar(100) NOT NULL,
    obereg varchar(2) NOT NULL,
    rstatus integer NOT NULL,
    statstru varchar(2) NOT NULL,
    statname varchar(2) NOT NULL,
    stataddr varchar(2) NOT NULL,
    longitud numeric(10,7) NOT NULL,
    latitude numeric(10,7) NOT NULL,
    fipsst varchar(2) NOT NULL,
    fipsco varchar(3) NOT NULL,
    address varchar(35) NOT NULL,
    city varchar(20) NOT NULL,
    zip varchar(5) NOT NULL,
    zip4 varchar(4) NOT NULL,
    cnty varchar(20) NOT NULL,
    phone varchar(10) NOT NULL,
    c_relatn varchar(2) NOT NULL,
    c_legbas varchar(2) NOT NULL,
    c_admin varchar(2) NOT NULL,
    geocode varchar(3) NOT NULL,
    lsabound varchar(1) NOT NULL,
    startdat varchar(10),
    enddate varchar(10),
    popu_lsa integer NOT NULL,
    centlib integer NOT NULL,
    branlib integer NOT NULL,
    bkmob integer NOT NULL,
    master numeric(8,2) NOT NULL,
    libraria numeric(8,2) NOT NULL,
    totstaff numeric(8,2) NOT NULL,
    locgvt integer NOT NULL,
    stgvt integer NOT NULL,
    fedgvt integer NOT NULL,
    totincm integer NOT NULL,
    salaries integer,
    benefit integer,
    staffexp integer,
    prmatexp integer NOT NULL,
    elmatexp integer NOT NULL,
    totexpco integer NOT NULL,
    totopexp integer NOT NULL,
    lcap_rev integer NOT NULL,
    scap_rev integer NOT NULL,
    fcap_rev integer NOT NULL,
    cap_rev integer NOT NULL,
    capital integer NOT NULL,
    bkvol integer NOT NULL,
    ebook integer NOT NULL,
    audio_ph integer NOT NULL,
    audio_dl float NOT NULL,
    video_ph integer NOT NULL,
    video_dl float NOT NULL,
    databases integer NOT NULL,
    subscrip integer NOT NULL,
    hrs_open integer NOT NULL,
    visits integer NOT NULL,
    referenc integer NOT NULL,
    regbor integer NOT NULL,
    totcir integer NOT NULL,
    kidcircl integer NOT NULL,
    elmatcir integer NOT NULL,
    loanto integer NOT NULL,
    loanfm integer NOT NULL,
    totpro integer NOT NULL,
    totatten integer NOT NULL,
    gpterms integer NOT NULL,
    pitusr integer NOT NULL,
    wifisess integer NOT NULL,
    yr_sub integer NOT NULL
);
-- Help speed up queries
CREATE INDEX libname2014_idx ON pls_fy2014_pupld14a (libname);
CREATE INDEX stabr2014_idx ON pls_fy2014_pupld14a (stabr);
CREATE INDEX city2014_idx ON pls_fy2014_pupld14a (city);
CREATE INDEX visits2014_idx ON pls_fy2014_pupld14a (visits);

COPY pls_fy2014_pupld14a
FROM '/home/jun/Documents/Programming/PracticalSQL/Ch8/pls_fy2014_pupld14a.csv'
WITH (FORMAT CSV, HEADER);




-- Listing 8-2: Creating and filling the 2009 Public Libraries Survey table

CREATE TABLE pls_fy2009_pupld09a (
    stabr varchar(2) NOT NULL,
    fscskey varchar(6) CONSTRAINT fscskey2009_key PRIMARY KEY,
    libid varchar(20) NOT NULL,
    libname varchar(100) NOT NULL,
    address varchar(35) NOT NULL,
    city varchar(20) NOT NULL,
    zip varchar(5) NOT NULL,
    zip4 varchar(4) NOT NULL,
    cnty varchar(20) NOT NULL,
    phone varchar(10) NOT NULL,
    c_relatn varchar(2) NOT NULL,
    c_legbas varchar(2) NOT NULL,
    c_admin varchar(2) NOT NULL,
    geocode varchar(3) NOT NULL,
    lsabound varchar(1) NOT NULL,
    startdat varchar(10),
    enddate varchar(10),
    popu_lsa integer NOT NULL,
    centlib integer NOT NULL,
    branlib integer NOT NULL,
    bkmob integer NOT NULL,
    master numeric(8,2) NOT NULL,
    libraria numeric(8,2) NOT NULL,
    totstaff numeric(8,2) NOT NULL,
    locgvt integer NOT NULL,
    stgvt integer NOT NULL,
    fedgvt integer NOT NULL,
    totincm integer NOT NULL,
    salaries integer,
    benefit integer,
    staffexp integer,
    prmatexp integer NOT NULL,
    elmatexp integer NOT NULL,
    totexpco integer NOT NULL,
    totopexp integer NOT NULL,
    lcap_rev integer NOT NULL,
    scap_rev integer NOT NULL,
    fcap_rev integer NOT NULL,
    cap_rev integer NOT NULL,
    capital integer NOT NULL,
    bkvol integer NOT NULL,
    ebook integer NOT NULL,
    audio integer NOT NULL,
    video integer NOT NULL,
    databases integer NOT NULL,
    subscrip integer NOT NULL,
    hrs_open integer NOT NULL,
    visits integer NOT NULL,
    referenc integer NOT NULL,
    regbor integer NOT NULL,
    totcir integer NOT NULL,
    kidcircl integer NOT NULL,
    loanto integer NOT NULL,
    loanfm integer NOT NULL,
    totpro integer NOT NULL,
    totatten integer NOT NULL,
    gpterms integer NOT NULL,
    pitusr integer NOT NULL,
    yr_sub integer NOT NULL,
    obereg varchar(2) NOT NULL,
    rstatus integer NOT NULL,
    statstru varchar(2) NOT NULL,
    statname varchar(2) NOT NULL,
    stataddr varchar(2) NOT NULL,
    longitud numeric(10,7) NOT NULL,
    latitude numeric(10,7) NOT NULL,
    fipsst varchar(2) NOT NULL,
    fipsco varchar(3) NOT NULL
);

CREATE INDEX libname2009_idx ON pls_fy2009_pupld09a (libname);
CREATE INDEX stabr2009_idx ON pls_fy2009_pupld09a (stabr);
CREATE INDEX city2009_idx ON pls_fy2009_pupld09a (city);
CREATE INDEX visits2009_idx ON pls_fy2009_pupld09a (visits);

COPY pls_fy2009_pupld09a
FROM '/home/jun/Documents/Programming/PracticalSQL/Ch8/pls_fy2009_pupld09a.csv'
WITH (FORMAT CSV, HEADER);



-- Count() aggregate fn: used to count rows
SELECT count(*)
FROM pls_fy2014_pupld14a;
-- OUT: 9305
-- NOTE: Asterisk counts NULL values

SELECT count(*)
FROM pls_fy2009_pupld09a;
-- OUT: 9299


-- Use count on specific cols. to see how many values
SELECT count(salaries)
FROM pls_fy2014_pupld14a;

SELECT count(salaries)
FROM pls_fy2009_pupld09a;

-- Use distinct to count unique values
-- no distinct
SELECT count(libname)
FROM pls_fy2014_pupld14a;

SELECT count(DISTINCT libname)
FROM pls_fy2014_pupld14a;


-- Max() and Min() w/ select
SELECT max(visits), min(visits)
FROM pls_fy2014_pupld14a;




-- Group By aggregate fn: elim. duplicate results 
-- Ex.
SELECT stabr
FROM pls_fy2014_pupld14a
GROUP BY stabr
ORDER BY stabr; -- sorts in alphabetical order
-- Groups col. by state initials
-- returns 56 unique states(including DC, Virgin Islands, etc.)

-- Group by on 2 cols
SELECT city, stabr
FROM pls_fy2014_pupld14a
GROUP BY city, stabr
ORDER BY city, stabr;
-- returns all unique combinations of cities and state


-- Ex. Combining Group By w/ aggregate fns like count
SELECT stabr, count(*)
FROM pls_fy2014_pupld14a
GROUP BY stabr          -- changes count() fn behavior
ORDER BY count(*) DESC;
-- OUT: States w/ count of library agencies in desc. order
-- Count is specifically focused on stabr(state names) since the Group by
-- Query doesn't run if no group by, since count is an aggregate fn
-- ERROR:  column "pls_fy2014_pupld14a.stabr" must appear in the GROUP BY clause or be used in 
--an aggregate function


-- Ex. Using Group By w/ count() on multiple cols.
SELECT stabr, stataddr, count(*)
FROM pls_fy2014_pupld14a
GROUP BY stabr, stataddr
ORDER BY stabr ASC, count(*) DESC;
-- stataddr: cat. var of 3 values, tells if library moved or not
-- Orders in alpha. order, with count of each group of 3 vars in stataddr
-- Shows number of unique combinations of stabr and stataddr




-- DATA PREPROCESSING
-- Use WHERE filtering to get rid of bad values in data
-- Data has neg. values to indicate non-response in survey, get rid.

-- Calculate sum of annual visits to libs. from both tables
SELECT sum(visits) AS visits_2014
FROM pls_fy2014_pupld14a
WHERE visits >= 0;
-- OUT: 1425930900

SELECT sum(visits) AS visits_2009
FROM pls_fy2009_pupld09a
WHERE visits >= 0;
-- OUT: 1591799201 

-- Interpr: These numbers show less visits, however, there are less libs
-- in 2014. Let's check more: By joining tables
SELECT sum(pls14.visits) AS visits_2014,
      sum(pls09.visits) AS visits_2009
FROM pls_fy2014_pupld14a pls14 JOIN pls_fy2009_pupld09a pls09
ON pls14.fscskey = pls09.fscskey
WHERE pls14.visits >= 0 AND pls09.visits >= 0; -- Need dot oper. to show which set
-- OUT: visits2014: 1417299241, visits2009: 1585455205
-- NOTE: This joined table drops closed libs., etc. We only see matching libs now
-- Int: We see there was a decrease in visits


-- Q: Did this trend vary by region?
SELECT pls14.stabr, 
      sum(pls14.visits) AS visits_2014,     -- have to rewrite every query
      sum(pls09.visits) AS visits_2009,
      round ( (CAST(sum(pls14.visits) AS decimal(10, 1)) - sum(pls09.visits)) / 
                    sum(pls09.visits) * 100, 2 ) AS pct_change
FROM pls_fy2014_pupld14a pls14 JOIN pls_fy2009_pupld09a pls09  --have to rewrite ev. query
ON pls14.fscskey = pls09.fscskey
WHERE pls14.visits >= 0 AND pls09.visits >= 0
GROUP BY pls14.stabr                    -- why only pls14? ANS: Doesn't matter
ORDER BY pct_change DESC;               -- only interested in change

--Int: Highest pos. pct change in GU w/ 70%, Lowest in OK w/ -35% 
-- ALWAYS remember to ask an expert on why we get these answers out of the data
-- to see if it sounds right, and find out why this is happening/ interpret the data


-- Having fn: Using having to filter the results of an aggregate query
SELECT pls14.stabr,
    -- table sums and pct_change
      sum(pls14.visits) AS visits_2014,
      sum(pls09.visits) AS visits_2009,
      round ( (CAST(sum(pls14.visits) AS decimal(10, 1)) - sum(pls09.visits)) / 
                    sum(pls09.visits) * 100, 2 ) AS pct_change    
FROM pls_fy2014_pupld14a pls14 JOIN pls_fy2009_pupld09a pls09 
ON pls14.fscskey = pls09.fscskey
WHERE pls14.visits >= 0 AND pls09.visits >= 0
GROUP BY pls14.stabr
HAVING sum(pls14.visits) > 50000000 -- include only rows greater than this #
ORDER BY pct_change DESC
-- Shows larger states only due to HAVING clause
-- OUT: Only shows 6 states, with their pct change.
-- Int: All states show neg. change, we can use this to ask questions why neg. loss









