-- COMISION 43410
-- LANDOLFI JUAN IGNACIO
-- ENTREGA CLASE 14 - CREACIÓN FUNCTIONS

USE IMDB_DB;

/*
 1)
 
 Vamos a retomar lo que hicimos con las Views pero esta vez configurable por el usuario
 a partir de un Stored Procedure. Queremos una rutina a la que pueda definirse la cantidad
 de años desde la cual filtrar los films (a partir de su columna 'start_year') y que pueda 
 definirse si vamos a ordenarla de forma ascendende o descendente desde una columna que también
 vamos a introducir como parámetro.
*/

DROP PROCEDURE IF EXISTS `SP_titles_last_x_years`;

/*
 En la rutina `SP_titles_last_x_years` tenemos los parametros:
	x_years: Filtra los titulos desde X años atras con este valor.
    column_sort: Columna a utilizar para ordenar los valores.
    is_ascending: Booleano. Si es True ordena de forma ascendente, caso contrario de forma descendente.
*/

DELIMITER // 
CREATE PROCEDURE `SP_titles_last_x_years` (IN x_years INT, IN column_sort VARCHAR(50), IN is_ascending BOOL)
BEGIN
	IF is_ascending 
    THEN 
		SET @ordering = 'ASC' ;
    ELSE 
		SET @ordering = 'DESC' ;
	END IF;
    
    SET @query_str =  CONCAT('SELECT * FROM Titles WHERE (YEAR(NOW()) - title_start_year) <= ', x_years, ' ORDER BY ',column_sort, ' ', @ordering,';') ;
	PREPARE sql_query FROM @query_str ;
    EXECUTE sql_query;
    DEALLOCATE PREPARE sql_query ;
END //
DELIMITER ;

CALL SP_titles_last_x_years(2, 'title_id', False);
CALL SP_titles_last_x_years(5, 'title_original', True);



/*
 2)
  Vamos a crear una rutina que nos permita eliminar el último registro cargado en una tabla en una tabla.
  Se puede pensar como el boton de Deshacer luego de una acción de inserción.
  Insertamos una linea para usar de ejemplo.
*/

INSERT INTO Person(primary_profession_id, primary_name, birth_year, death_year) VALUES (1,'Jose Antonio Dominguez Bandera',1960,NULL);

DROP PROCEDURE IF EXISTS `SP_delete_last_person_added`;


DELIMITER // 
CREATE PROCEDURE `SP_delete_last_person_added` ()
BEGIN
	SET @name_person_deleted = '';
    SET @id_to_delete = (SELECT MAX(person_id) FROM Person);
    
    SET @query_str =  CONCAT('DELETE FROM Person WHERE person_id = ', @id_to_delete, ';') ;
	PREPARE sql_query FROM @query_str ;
    EXECUTE sql_query;
    DEALLOCATE PREPARE sql_query ;
END //
DELIMITER ;

SELECT * FROM Person ORDER BY person_id DESC LIMIT 5; 

CALL SP_delete_last_person_added();

SELECT * FROM Person ORDER BY person_id DESC LIMIT 5; 
