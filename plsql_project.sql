-- Table to store movie details
CREATE TABLE Movies (
    movie_id INT PRIMARY KEY,
    title VARCHAR2(100),
    genre_id INT,
    release_year INT
);

-- Table to store user details
CREATE TABLE Users (
    user_id INT PRIMARY KEY,
    name VARCHAR2(100)
);

-- Table to store movie ratings by users
CREATE TABLE Ratings (
    rating_id INT PRIMARY KEY,
    user_id INT,
    movie_id INT,
    rating INT,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (movie_id) REFERENCES Movies(movie_id)
);

-- Table to store genres of movies
CREATE TABLE Genres (
    genre_id INT PRIMARY KEY,
    genre_name VARCHAR2(50)
);

-- Table to store user genre preferences
CREATE TABLE User_Genre_Preferences (
    user_id INT,
    genre_id INT,
    preference_level INT,
    PRIMARY KEY (user_id, genre_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (genre_id) REFERENCES Genres(genre_id)
);


-- Insert some genres
INSERT INTO Genres VALUES (1, 'Action');
INSERT INTO Genres VALUES (2, 'Comedy');
INSERT INTO Genres VALUES (3, 'Drama');
INSERT INTO Genres VALUES (4, 'Romance');

select * from  ratings;
-- Insert some movies
INSERT INTO Movies VALUES (1, 'Die Hard', 1, 1988);
INSERT INTO Movies VALUES (2, 'The Hangover', 2, 2009);
INSERT INTO Movies VALUES (3, 'The Godfather', 3, 1972);
INSERT INTO Movies VALUES (4, 'The Notebook', 4, 2004);

-- Insert some users
INSERT INTO Users VALUES (1, 'Alice');
INSERT INTO Users VALUES (2, 'Bob');

-- Insert ratings with explicit rating_id
INSERT INTO Ratings (rating_id, user_id, movie_id, rating) VALUES (1, 1, 1, 5);
INSERT INTO Ratings (rating_id, user_id, movie_id, rating) VALUES (2, 2, 2, 4);
INSERT INTO Ratings (rating_id, user_id, movie_id, rating) VALUES (3, 1, 3, 5);
INSERT INTO Ratings (rating_id, user_id, movie_id, rating) VALUES (4, 2, 4, 3);


-- Insert user genre preferences correctly
INSERT INTO User_Genre_Preferences (user_id, genre_id, preference_level) VALUES (1, 1, 5);
INSERT INTO User_Genre_Preferences (user_id, genre_id, preference_level) VALUES (1, 3, 3); 
INSERT INTO User_Genre_Preferences (user_id, genre_id, preference_level) VALUES (2, 2, 4);


CREATE OR REPLACE PROCEDURE recommend_movies (p_user_id IN INT) AS
    CURSOR user_preferences IS
        SELECT genre_id, preference_level
        FROM User_Genre_Preferences
        WHERE user_id = p_user_id;

    CURSOR recommended_movies IS
        SELECT m.movie_id, m.title
        FROM Movies m
        JOIN Genres g ON m.genre_id = g.genre_id
        WHERE g.genre_id IN (SELECT genre_id FROM User_Genre_Preferences WHERE user_id = p_user_id)
        ORDER BY m.release_year DESC;
BEGIN
    -- Show user genre preferences
    FOR pref IN user_preferences LOOP
        DBMS_OUTPUT.PUT_LINE('User ' || p_user_id || ' prefers genre: ' || pref.preference_level || ' for Genre ID: ' || pref.genre_id);
    END LOOP;

    -- Recommend movies based on user genre preferences
    FOR rec IN recommended_movies LOOP
        DBMS_OUTPUT.PUT_LINE('Recommended Movie: ' || rec.title);
    END LOOP;
END recommend_movies;
