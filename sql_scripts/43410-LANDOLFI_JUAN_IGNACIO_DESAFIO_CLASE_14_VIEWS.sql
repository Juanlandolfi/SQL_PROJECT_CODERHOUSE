-- COMISION 43410
-- LANDOLFI JUAN IGNACIO
-- ENTREGA CLASE 14 - CREACIÓN VIEWS

/*
Tenemos creada la base datos y ya empezamos a popularlas. 
Desde gerencia están armando un catalogo donde figure el
nombre del titulo, tipo de titulo(movie, tvshow, tvepisode, 
tvmovie, short, etc) y un campo donde figuren los nombres
de los directores y escritores donde tengamos esa información.
*/

-- Creamos una vista para tal fin:
USE IMDB_DB;

CREATE OR REPLACE VIEW VW_films_type_dire_writer AS (
SELECT title_original, type_name , GROUP_CONCAT( roles SEPARATOR ', ')  directors_and_writers
FROM (
	SELECT t.title_original, tt.type_name ,CONCAT(p.primary_name,'(', pr.profession_name,')') roles  FROM Crew c
	JOIN IMDB_DB.Titles t ON c.title_id = t.title_id
	JOIN IMDB_DB.Person p ON c.person_id = p.person_id
	JOIN IMDB_DB.Profession pr ON c.profession_id = pr.profession_id
    JOIN IMDB_DB.Title_types tt ON t.title_type_id = tt.type_id
    ) sub
GROUP BY title_original, type_name
);

SELECT * FROM VW_films_type_dire_writer;

/*
Pero enseguida el directorio se da cuenta que no todos los titulos tienen sus
datos completos. Y quieren ponerse en campaña para lograr la carga de los mismos.
Nos piden una vista que nos marque el progreso de carga de estos datos para llevar
un control.
*/

-- Vamos a crear una vista que le de a nuestra gerencia el procentaje de titulos
-- que todavía no tienen cargado ningun guionista ni director.
 
CREATE OR REPLACE VIEW VW_crew_to_complete AS (
	SELECT COUNT(DISTINCT t.title_id) / (select count(title_id) FROM IMDB_DB.Titles)
	FROM IMDB_DB.Titles t
	LEFT JOIN Crew c ON t.title_id = c.title_id
	LEFT JOIN Person p ON c.person_id = p.person_id
	WHERE c.crew_id IS NULL
);

SELECT * FROM VW_crew_to_complete; -- Porcentaje de peliculas que no tienen ningun escritor ni guinista cargado