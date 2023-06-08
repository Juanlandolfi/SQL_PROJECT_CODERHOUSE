USE IMDB_DB;
-- SET sql_mode = (SELECT REPLACE(@@sql_mode, 'ONLY_FULL_GROUP_BY', ''));
-- SET sql_mode = CONCAT_WS(',', @@sql_mode, 'ONLY_FULL_GROUP_BY');

SELECT title_original , GROUP_CONCAT( roles SEPARATOR ', ')  
FROM (
	SELECT t.title_original, CONCAT(p.primary_name,'(', pr.profession_name,')') roles  FROM Crew c
	JOIN IMDB_DB.Titles t ON c.title_id = t.title_id
	JOIN IMDB_DB.Person p ON c.person_id = p.person_id
	JOIN IMDB_DB.Profession pr ON c.profession_id = pr.profession_id
    ) sub
GROUP BY title_original
;
