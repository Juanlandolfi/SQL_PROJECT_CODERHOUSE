-- FUNCTIONS

USE IMDB_DB;

/*
Vamos a generar una función que dado el id del titulo nos devuelva la cantidad de personas 
involucradas en el mismo a partir de los datos de nuestra tabla Crew
*/

--  Creamos la funcion `quantity_of_crew`

DROP FUNCTION IF EXISTS quantity_of_crew;

DELIMITER //
CREATE FUNCTION quantity_of_crew (t_id INT)
RETURNS INT
READS SQL DATA
    RETURN (SELECT COUNT(title_id) FROM IMDB_DB.Crew WHERE title_id = t_id);
// DELIMITER ;

SELECT quantity_of_crew(10), quantity_of_crew(100), quantity_of_crew(1);

/*
	Desde gerencia van a aplicar una campaña de difusión de peliculas que se hayan lanzado luego del año XXXX.
    Se va a dar un presupuesto por titulo equivalente a $500 por cada director y $250 por cada escritor que esté cargado
    en la base datos. Para aquellos titulos sobre los cuales no tengamos ningun director ni escritor cargado van a asignar $50.
    Nos piden que se pueda ingresar el año de corte a partir del cual se van contar los titulos como parametro de la función.

	-- 
    1) Hacemos un join de todas las tablas que necesitamos.
	2) Agrupamos por titulo y profesion para tener la cuenta de cuantos directores 
	   y escritores tiene cada titulo como asi también crear una columna con el valor 
       a pagar a cada uno.
	3) Sobre eso hacemos una consulta donde sumamos todo y utilizamos un CASE para asigar 
	   el valor 1 a los titulos donde no había directores ni escritores y multiplicarlo por
       su precio. En el mismo CASE multiplicamos la cantidad de escritores y directores por su precio.
*/


DROP FUNCTION IF EXISTS ads_budget;

DELIMITER //
CREATE FUNCTION ads_budget (year_since INT)
RETURNS FLOAT 
DETERMINISTIC
BEGIN 
DECLARE campaing_cost FLOAT;

SELECT SUM(CASE quantity WHEN 0 THEN 1 * price ELSE quantity * price END) INTO campaing_cost
FROM (
		SELECT t.title_original, 
				p.profession_name, 
				COUNT(c.crew_id) quantity, 
				(CASE p.profession_name WHEN 'writer' THEN 250 WHEN 'director' THEN 500 ELSE 50 END ) as price
		FROM Titles t
		LEFT JOIN Crew c ON t.title_id = c.title_id
		LEFT JOIN Profession p ON c.profession_id = p.profession_id
        WHERE t.title_start_year >= year_since 
		GROUP BY t.title_original, p.profession_name ) sub;
RETURN campaing_cost;
END 
// DELIMITER ;	

SELECT ads_budget(2015) anio_2015, ads_budget(2018) anio_2018, ads_budget(2022) anio_2022;


