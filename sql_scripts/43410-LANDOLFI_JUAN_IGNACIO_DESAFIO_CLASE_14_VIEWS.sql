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

-- Creamos una VIEW para tal fin:
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

-- Vamos a crear una VISTA que le de a nuestra gerencia el procentaje de titulos
-- que todavía no tienen cargado ningun guionista ni director.
 
CREATE OR REPLACE VIEW VW_crew_to_complete AS (
	SELECT COUNT(DISTINCT t.title_id) / (select count(title_id) FROM IMDB_DB.Titles)
	FROM IMDB_DB.Titles t
	LEFT JOIN Crew c ON t.title_id = c.title_id
	LEFT JOIN Person p ON c.person_id = p.person_id
	WHERE c.crew_id IS NULL
);

SELECT * FROM VW_crew_to_complete; -- Porcentaje de peliculas que no tienen ningun escritor ni guinista cargado



-- VIEW donde tengamos Resumen de cantidad de Titulos por Genero

CREATE OR REPLACE VIEW VW_quantity_per_genre AS (
	SELECT COUNT(t.title_original) quantity, g.genre_name
	FROM Titles t
	JOIN Title_types tt ON t.title_type_id = tt.type_id
	JOIN Title_Genres tg ON t.title_id = tg.title_id
	JOIN Genres g on tg.genre_id = g.genre_id
	GROUP BY  g.genre_name
	ORDER BY quantity DESC
);

SELECT * FROM VW_quantity_per_genre;



-- VIEW donde tengamos Cantidad de profesiones en nuestra tabla persona

CREATE OR REPLACE VIEW VW_profession_count AS (
	SELECT profession_name, COUNT(p.person_id) quantity 
    FROM Person p
	LEFT JOIN Profession pr ON p.primary_profession_id = pr.profession_id
	GROUP BY pr.profession_name 
	ORDER BY quantity DESC
);

SELECT * FROM VW_profession_count;



-- VIEW donde veamos los titulos que tenemos que se hayan lanzado en los ultimos 3 años.

CREATE OR REPLACE VIEW VW_titles_last_3_years AS (
	SELECT * 
	FROM Titles t
	WHERE (YEAR(NOW()) - title_start_year) <= 3
);

SELECT title_primary, title_start_year FROM VW_titles_last_3_years;

