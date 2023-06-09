USE IMDB_DB;
-- SET sql_mode = (SELECT REPLACE(@@sql_mode, 'ONLY_FULL_GROUP_BY', ''));
-- SET sql_mode = CONCAT_WS(',', @@sql_mode, 'ONLY_FULL_GROUP_BY');

SELECT title_original, type_name , GROUP_CONCAT( roles SEPARATOR ', ')  crew
FROM (
	SELECT t.title_original, tt.type_name ,CONCAT(p.primary_name,'(', pr.profession_name,')') roles  FROM Crew c
	JOIN IMDB_DB.Titles t ON c.title_id = t.title_id
	JOIN IMDB_DB.Person p ON c.person_id = p.person_id
	JOIN IMDB_DB.Profession pr ON c.profession_id = pr.profession_id
    JOIN IMDB_DB.Title_types tt ON t.title_type_id = tt.type_id
    ) sub
GROUP BY title_original, type_name
;

SELECT COUNT(t.title_original) quantity , tt.type_name, g.genre_name
FROM Titles t
JOIN Title_types tt ON t.title_type_id = tt.type_id
JOIN Title_Genres tg ON t.title_id = tg.title_id
JOIN Genres g on tg.genre_id = g.genre_id
GROUP BY tt.type_name, g.genre_name
ORDER BY quantity DESC;


SELECT COUNT(t.title_original) quantity, g.genre_name
FROM Titles t
JOIN Title_types tt ON t.title_type_id = tt.type_id
JOIN Title_Genres tg ON t.title_id = tg.title_id
JOIN Genres g on tg.genre_id = g.genre_id
GROUP BY  g.genre_name
ORDER BY quantity DESC;


-- CREATE VIEW THAT GIVES ME A LIST OF FILMS WITH THEIR DIRECTORS AND WRITERS

