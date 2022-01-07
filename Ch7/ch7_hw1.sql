-- Ch. 7 HW
CREATE TABLE albums (
    album_id bigserial,
    album_catalog_code varchar(100),
    album_title text,
    album_artist text,
    album_release_date date,
    album_genre varchar(40),
    album_description text
);

CREATE TABLE songs (
    song_id bigserial, 
    song_title text,
    song_artist text,
    album_id bigint
);


-- 1)
-- Using col. pk syntax
CREATE TABLE albums (
    album_id bigserial CONSTRAINT albums_key PRIMARY KEY,
    album_catalog_code varchar(100) NOT NULL,
    album_title text NOT NULL,
    album_artist text NOT NULL,
    album_release_date date,
    album_genre varchar(40), 
    album_description text, 
    CONSTRAINT release_date_check CHECK (album_release_date > '1/1/1925')
    -- From book ans. This is a good check though.
);
-- From book, I modified and got rid of NOT NULL for date, genre, desc.
-- I guess this makes those fields optional.

-- Using table pk syntax
CREATE TABLE songs (
    song_id bigserial, 
    song_title text NOT NULL,
    song_artist text NOT NULL,
    album_id bigint REFERENCES albums (album_id),
    CONSTRAINT songs_key PRIMARY KEY (song_id)
);

-- Ans: I added PK and a FK in songs table, to ref. albums. 
-- I added NOT NULL constraints to all cols. to make sure every col.
-- needs a value when inserting.


-- 2)
-- Ans: Instead of using album_id as PK in albums, you can use a combination
-- of album title, artist, and release date, since it is unlikely that
-- there will be duplicates of these as a combination.


-- 3)
-- Ans: To speed up queries, potential indexes for albums would be the vars
-- album title becuase this might be a common search. For songs, it might be  
-- song_artist, since there would be too many songs per artist to track.

-- Book Ans:
-- Primary key columns get indexes by default, but we should add an index
-- to the album_id foreign key column in the songs table because we'll use
-- it in table joins. It's likely that we'll query these tables to search
-- by titles and artists, so those columns in both tables should get indexes
-- too. The album_release_date in albums also is a candidate if we expect
-- to perform many queries that include date ranges.



