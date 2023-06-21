-- COMISION 43410
-- LANDOLFI JUAN IGNACIO
-- ENTREGA CLASE 14 - TRIGGERS

USE IMDB_DB;

/*
  1)
  Vamos a mantener una tabla para registrar todos los cambios sufridos en la tabla Titles.
  Crearemos una tabla que contenga la misma información y otra adicional al control con la información
  de Usuario, Fecha, Hora y tipo de operacion (INSERT, UPDATE o DELETE).
  Con esto podremos saber quién cargó, eliminó o modificó un titulo.
  Para esto necesitaemos 3 triggers.
*/

DROP TABLE IF EXISTS `Log_titles`;

CREATE TABLE IF NOT EXISTS `Log_titles` (
	id INT NOT NULL AUTO_INCREMENT,
    title_id INT NOT NULL,
    title_type_id INT NOT NULL,
    title_primary VARCHAR(500) NOT NULL,
    title_original VARCHAR(500) NOT NULL,
    title_adult BOOL,
    title_start_year INT,
    title_end_year INT,
    title_runtime INT,
    operation_type VARCHAR(10),
    user_modified VARCHAR(50),
    date_modified DATE,
    time_modified TIME,
    PRIMARY KEY (id)
);



DROP TRIGGER IF EXISTS `insert_titles_log_trigger`;

CREATE TRIGGER `insert_titles_log_trigger`
AFTER INSERT ON `Titles`
FOR EACH ROW
INSERT INTO `Log_titles`(title_id,title_type_id, title_primary, title_original, title_adult, title_start_year, title_end_year, title_runtime, operation_type, user_modified, date_modified, time_modified) 
VALUES (NEW.title_id, NEW.title_type_id, NEW.title_primary, NEW.title_original, NEW.title_adult, NEW.title_start_year, NEW.title_end_year, NEW.title_runtime, 'INSERT',USER(), CURRENT_DATE(), CURRENT_TIME() )
;


DROP TRIGGER IF EXISTS `update_titles_log_trigger`;

CREATE TRIGGER `update_titles_log_trigger`
AFTER UPDATE ON `Titles`
FOR EACH ROW
INSERT INTO `Log_titles`(title_id,title_type_id, title_primary, title_original, title_adult, title_start_year, title_end_year, title_runtime, operation_type, user_modified, date_modified, time_modified) 
VALUES (NEW.title_id, NEW.title_type_id, NEW.title_primary, NEW.title_original, NEW.title_adult, NEW.title_start_year, NEW.title_end_year, NEW.title_runtime, 'UPDATE', USER(), CURRENT_DATE(), CURRENT_TIME() );
DROP TRIGGER IF EXISTS `delete_titles_log_trigger`;

CREATE TRIGGER `delete_titles_log_trigger`
BEFORE DELETE ON `Titles`
FOR EACH ROW
INSERT INTO `Log_titles`(title_id,title_type_id, title_primary, title_original, title_adult, title_start_year, title_end_year, title_runtime, operation_type, user_modified, date_modified, time_modified) 
VALUES (OLD.title_id, OLD.title_type_id, OLD.title_primary, OLD.title_original, OLD.title_adult, OLD.title_start_year, OLD.title_end_year, OLD.title_runtime, 'DELETE', USER(), CURRENT_DATE(), CURRENT_TIME() )
;


-- INSERT PRUEBA
INSERT INTO `Titles` (title_type_id, title_primary, title_original, title_adult, title_start_year, title_end_year, title_runtime) 
VALUES (1, 'test', 'test', 0, 2023, NULL, 60);

-- UPDATE DE PRUEBA
UPDATE `Titles` SET title_primary = 'test_updated' WHERE title_original = 'test';

-- DELETE PRUEBA
DELETE FROM `Titles` WHERE title_original = 'test';


-- CONTROL
SELECT * FROM `Log_titles`;
SELECT * FROM `Titles` WHERE title_original = 'test';

/*
	2)
    Vamos a crear un Trigger que controle que todos los idiomas en la tabla Languagues sean cargados en minúsculas.
    
*/

SELECT * FROM Languages;

DROP TRIGGER IF EXISTS `insert_language_trigger`;

-- Creamos el trigger que convierte el valor a minúsculas
CREATE TRIGGER `insert_language_trigger`
BEFORE INSERT ON `Languages`
FOR EACH ROW
SET NEW.language_code = LOWER(NEW.language_code);

-- Insertamos un valor en mayúsculas el cual se debería grabar en minúsculas.
INSERT INTO Languages(language_code) VALUES ('TTT');

-- Controlamos como fue insertado
SELECT * FROM Languages ORDER BY language_id DESC LIMIT 1;

-- Lo eliminamos
DELETE FROM Languages WHERE language_code = 'ttt';

-- Controlamos nuevamente
SELECT * FROM Languages ORDER BY language_id DESC LIMIT 1;
