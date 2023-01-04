CREATE DATABASE recommendations;      --Creates and connects to recommendation database
\connect recommendations;

CREATE DOMAIN rating AS integer CHECK (value BETWEEN 1 and 10);
CREATE TYPE media AS ENUM ('tv show', 'movie', 'book', 'game');
CREATE TYPE completion_status AS ENUM ('not started', 'save for later', 'in progress',  'completed');

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
  completed completion_status DEFAULT 'not started',
  completed_rating rating,
  completed_date date
);

-- good seed data
INSERT INTO friends (name, trust_rating) VALUES ('Bob', 7);
INSERT INTO friends (name, trust_rating) VALUES ('Esche', 9);

INSERT INTO recommendations                                           -- recs for Bob
            (name, media_type, description, friend_id,
            friend_rating, self_rating, analyzed_rating)
            VALUES ('Skylanders', 'game', 'good game', 1, 6, 4, 5);

INSERT INTO recommendations                                           -- recs for Esche
            (name, media_type, description, friend_id,
            friend_rating, self_rating, analyzed_rating)
            VALUES ('Native Son', 'book', 'good book', 2, 9, 8, 9);

INSERT INTO recommendations
            (name, media_type, description, friend_id,
            friend_rating, self_rating, analyzed_rating)
            VALUES ('Citizen Sleeper', 'game', '2nd good game', 2, 7, 9, 8);

-- in progress rec
INSERT INTO recommendations
            (name, media_type, description, friend_id,
            friend_rating, self_rating, analyzed_rating,
            completed)
            VALUES ('Mob Psycho', 'tv show', 'Anime', 1, 9, 7, 8, 'in progress');

-- save for later rec
INSERT INTO recommendations
            (name, media_type, description, friend_id,
            friend_rating, self_rating, analyzed_rating,
            completed)
            VALUES ('Breaking Bad', 'tv show', 'baddddd', 1, 10, 10, 10, 'save for later');

-- completed rec
INSERT INTO recommendations
            (name, media_type, description, friend_id,
            friend_rating, self_rating, analyzed_rating,
            completed, completed_rating)
            VALUES ('Iron Man 2', 'movie', 'Decent movie', 2, 5, 7, 6, 'completed', 5);


-- bad seed data for constraint testing, should all fail
INSERT INTO friends (name, trust_rating) VALUES ('bad bob', 12);

INSERT INTO recommendations
            (name, media_type, description, friend_id,
            friend_rating, self_rating, analyzed_rating)
            VALUES ('Bad Media Type', 'bang', 'fake game', 1, 6, 4, 5);

INSERT INTO recommendations
            (name, media_type, description, friend_id,
            friend_rating, self_rating, analyzed_rating)
            VALUES ('Bad rating', 'bang', 'fake game', 1, 6, 4, 5);
