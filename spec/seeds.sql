DROP TABLE IF EXISTS posts;

DROP TABLE IF EXISTS users; 

-- Table Definition
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username text,
    pass text,
    first_name text,
    last_name text
);

INSERT INTO users ("username", "pass", "first_name", "last_name") VALUES
('Sam123', 'password', 'Sam', 'Hunt'),
('user12', '123', 'Joe', 'Bloggs'),
('helloitsme', '456', 'Jane', 'Roe'),
('RealDonaldTrump', 'maga', 'Donald', 'Trump');

DROP TABLE IF EXISTS posts; 

-- Table Definition
CREATE TABLE posts (
    id SERIAL PRIMARY KEY,
    content text,
    poster_id int, 
    post_time timestamp,
    constraint fk_user
     foreign key (poster_id) 
     REFERENCES users (id) ON DELETE CASCADE 
);

TRUNCATE TABLE posts RESTART IDENTITY;

INSERT INTO posts ("content", "poster_id", "post_time") VALUES
('This should work', '1', '01-Dec-2022'),
('I hope it does', '3', '30-Nov-2022'),
('Forget truth social, this is better','4','14-Nov-2022');
