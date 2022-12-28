CREATE DATABASE recommendations;      --Creates and connects to recommendation database
\connect recommendations;

CREATE TABLE friends (
  id serial PRIMARY KEY,
  name varchar(25) NOT NULL,
  trust_rating integer NOT NULL
);

CREATE TABLE recommendations (
  id serial PRIMARY KEY,
  name varchar(50) NOT NULL,
  media_type text NOT NULL,
  description varchar(140) DEFAULT '',
  friend_id integer NOT NULL REFERENCES friends (id),
  friend_rating integer,
  self_rating integer,
  date_added date DEFAULT NOW(),
  analyzed_rating integer,
  completed boolean DEFAULT false,
  completed_rating integer,
  completed_date date,
  CHECK (media_type IN ('tv show', 'movie', 'book', 'game')),
  CHECK (friend_rating BETWEEN 1 and 10),
  CHECK (self_rating BETWEEN 1 and 10),
  CHECK (analyzed_rating BETWEEN 1 and 10),
  CHECK (completed_rating BETWEEN 1 and 10)
);
