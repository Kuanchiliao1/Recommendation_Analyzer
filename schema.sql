CREATE DATABASE recommendations;      --Creates and connects to recommendation database
\connect recommendations;

CREATE DOMAIN rating AS integer CHECK (value BETWEEN 1 and 10);
CREATE TYPE media AS ENUM ('tv show', 'movie', 'book', 'game');

CREATE TABLE friends (
  id serial PRIMARY KEY,
  name varchar(25) NOT NULL,
  trust_rating rating NOT NULL
);

CREATE TABLE recommendations (
  id serial PRIMARY KEY,
  name varchar(50) NOT NULL,
  media_type media NOT NULL,
  description varchar(140) DEFAULT '',
  friend_id integer NOT NULL REFERENCES friends (id),
  friend_rating rating NOT NULL,
  self_rating rating NOT NULL,
  date_added date DEFAULT NOW() NOT NULL,
  analyzed_rating rating NOT NULL,
  completed boolean DEFAULT false,
  completed_rating rating,
  completed_date date
);

INSERT INTO friends (name, trust_rating) VALUES ('Bob', 7);
INSERT INTO friends (name, trust_rating) VALUES ('bad bob', 12);

INSERT INTO recommendations
            (name, media_type, description, friend_id,
            friend_rating, self_rating, analyzed_rating)
            VALUES ('Skylanders', 'game', 'good game', 1, 6, 4, 5);

INSERT INTO recommendations
            (name, media_type, description, friend_id,
            friend_rating, self_rating, analyzed_rating)
            VALUES ('Bad Media Type', 'bang', 'fake game', 1, 6, 4, 5);

INSERT INTO recommendations
            (name, media_type, description, friend_id,
            friend_rating, self_rating, analyzed_rating)
            VALUES ('Bad rating', 'bang', 'fake game', 1, 16, 4, 5);
