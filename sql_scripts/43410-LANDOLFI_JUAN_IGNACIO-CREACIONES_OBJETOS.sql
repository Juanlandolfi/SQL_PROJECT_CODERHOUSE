-- COMISION 43410
-- LANDOLFI JUAN IGNACIO
-- ENTREGA 3 - TABLAS
DROP SCHEMA IF EXISTS IMDB_DB;

CREATE SCHEMA IF NOT EXISTS IMDB_DB;

USE IMDB_DB;

CREATE TABLE IF NOT EXISTS Regions (
    region_id INT NOT NULL AUTO_INCREMENT,
    region_code VARCHAR(8),
    last_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (region_id)
);

CREATE TABLE IF NOT EXISTS Languages (
    language_id INT NOT NULL AUTO_INCREMENT,
    language_code VARCHAR(3),
    last_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (language_id)
);

CREATE TABLE IF NOT EXISTS Person (
    person_id INT NOT NULL AUTO_INCREMENT,
    primary_profession_id INT NOT NULL,
    primary_name VARCHAR(50) NOT NULL,
    birth_year YEAR,
    death_year YEAR,
    last_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (person_id)
);

CREATE TABLE IF NOT EXISTS Profession (
    profession_id INT NOT NULL AUTO_INCREMENT,
    profession_name VARCHAR(100) NOT NULL,
    last_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (profession_id)
);

CREATE TABLE IF NOT EXISTS Crew (
    crew_id INT AUTO_INCREMENT,
    title_id INT NOT NULL,
    person_id INT NOT NULL,
    profession_id INT NOT NULL,
    last_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (crew_id)
);

CREATE TABLE IF NOT EXISTS Titles (
    title_id INT NOT NULL AUTO_INCREMENT,
    title_type_id INT NOT NULL,
    title_primary VARCHAR(500) NOT NULL,
    title_original VARCHAR(500) NOT NULL,
    title_adult BOOL,
    title_start_year YEAR,
    title_end_year YEAR,
    title_runtime INT,
    last_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (title_id)
);

CREATE TABLE IF NOT EXISTS Titles_aka (
    title_aka_id INT NOT NULL AUTO_INCREMENT,
    title_id INT NOT NULL,
    region_id INT NOT NULL,
    language_id INT NOT NULL,
    title_localize VARCHAR(255) NOT NULL,
    title_is_original BOOL NOT NULL,
    title_types VARCHAR(150),
    last_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (title_aka_id)
);

CREATE TABLE IF NOT EXISTS Episodes (
    episode_id INT NOT NULL AUTO_INCREMENT,
    title_id INT NOT NULL,
    title_id_parent INT NOT NULL,
    season_number INT NOT NULL,
    episode_number INT NOT NULL,
    last_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (episode_id)
);

CREATE TABLE IF NOT EXISTS Title_types (
    type_id INT NOT NULL AUTO_INCREMENT,
    type_name VARCHAR(50) NOT NULL,
    last_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (type_id)
);

CREATE TABLE IF NOT EXISTS Genres (
    genre_id INT NOT NULL AUTO_INCREMENT,
    genre_name VARCHAR(50) NOT NULL,
    last_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (genre_id)
);

CREATE TABLE IF NOT EXISTS Title_Genres (
    title_genre_id INT NOT NULL AUTO_INCREMENT,
    title_id INT NOT NULL,
    genre_id INT NOT NULL,
    last_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (title_genre_id)
);

-- Foreign Keys to Crew
ALTER TABLE
    Crew
ADD
    CONSTRAINT fk_title_id_crew FOREIGN KEY (title_id) REFERENCES Titles(title_id);

ALTER TABLE
    Crew
ADD
    CONSTRAINT fk_person_id_crew FOREIGN KEY (person_id) REFERENCES Person(person_id);

ALTER TABLE
    Crew
ADD
    CONSTRAINT fk_profession_id_crew FOREIGN KEY (profession_id) REFERENCES Profession(profession_id);

-- Foreign Keys to Titles_aka
ALTER TABLE
    Titles_aka
ADD
    CONSTRAINT fk_title_id_aka FOREIGN KEY (title_id) REFERENCES Titles(title_id);

ALTER TABLE
    Titles_aka
ADD
    CONSTRAINT fk_region_id_aka FOREIGN KEY (region_id) REFERENCES Regions(region_id);

ALTER TABLE
    Titles_aka
ADD
    CONSTRAINT fk_language_aka FOREIGN KEY (language_id) REFERENCES Languages(language_id);

-- Foreign Keys to Titles
ALTER TABLE
    Titles
ADD
    CONSTRAINT fk_title_type_id_titles FOREIGN KEY (title_type_id) REFERENCES Title_types(type_id);

-- Foreign Keys to Episodes
ALTER TABLE
    Episodes
ADD
    CONSTRAINT fk_title_id_episodes FOREIGN KEY (title_id) REFERENCES Titles(title_id);

ALTER TABLE
    Episodes
ADD
    CONSTRAINT fk_title_id_parent FOREIGN KEY (title_id_parent) REFERENCES Titles(title_id);

-- Foreign Keys to Title_Genres
ALTER TABLE
    Title_Genres
ADD
    CONSTRAINT fk_title_id_titles FOREIGN KEY (title_id) REFERENCES Titles(title_id);

ALTER TABLE
    Title_Genres
ADD
    CONSTRAINT fk_genre_id_genres FOREIGN KEY (genre_id) REFERENCES Genres(genre_id);

-- Foreign Keys to Person
ALTER TABLE
    Person
ADD
    CONSTRAINT fk_primary_profession_id_profession FOREIGN KEY (primary_profession_id) REFERENCES Profession(profession_id);