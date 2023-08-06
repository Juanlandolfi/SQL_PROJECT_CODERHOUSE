-- DCL

USE IMDB_DB;

/*
	Crearemos 2 usuarios.
    El primero va a tener solamente permisos de lectura.
    El segundo permisos de lectura, inserción y modificación.
    Ninguno tendrá permisos de eliminación.
*/

-- Creamos ambos usuarios
CREATE USER IF NOT EXISTS 'nancyv'@'localhost' IDENTIFIED BY 'password';
CREATE USER IF NOT EXISTS 'juanil'@'localhost' IDENTIFIED BY 'password';

/* 
	Ninguno posee permisos al crearse así que debemos asignarlos
	Nancy va a tener permiso de lectura sobre todas las tablas.
	Juan va a tener permisos mixtos para las tareas que debe realizar.
    Pero ninguno tendrá permisos de eliminación como se dijo.
*/

-- Permisos Nancy: Select para todas las tablas de la base de datos IMDB_DB
-- El * es el comodín que opera para que podamos seleccionar todas las tablas del schema seleccionado si tener que nombrar una a una las tablas que la componen.
GRANT SELECT ON IMDB_DB.* TO 'nancyv'@'localhost';

-- Permisos Juan: Select, Insert, Update para Titles y Episodes
-- Tengo que generar una sentencia para cada tabla en este caso.
GRANT SELECT, INSERT, UPDATE ON IMDB_DB.Titles TO 'juanil'@'localhost';
GRANT SELECT, INSERT, UPDATE ON IMDB_DB.Episodes TO 'juanil'@'localhost';

-- Mostramos los permisos otorgados
SHOW GRANTS FOR 'nancyv'@'localhost';
SHOW GRANTS FOR 'juanil'@'localhost';

/*############### TESTEO POR USUARIO ###############*/ 
-- Generar la conexión correspondiente para probarlos.

-- NANCY
-- Deberiamos ver el schema completo
-- Y al intentar realizar una sentencia DML por fuera del SELECT debería levantar un error.alter
SELECT * FROM IMDB_DB.Titles;
-- La siguiente sentencia genera un error por falta de permisos.
UPDATE IMDB_DB.Titles SET title_original = 'test' WHERE title_id = 1;
-- Error Code: 1142. UPDATE command denied to user 'nancyv'@'localhost' for table 'Titles'

-- JUANI
-- Deberíamos ver solamente las tablas Titles y Episodes
-- Podemos leer los datos
SELECT * FROM Titles;
-- Podemos insertar datos
INSERT INTO Titles (title_type_id, title_primary, title_original, title_adult, title_start_year, title_end_year, title_runtime) VALUES
					(1, 'TEST', 'TEST', 0, 2023,2025, 60);
SELECT * FROM Titles WHERE title_primary = 'TEST';
-- Pero no podemos eliminar. Recibimos el siguiente error.
DELETE FROM Titles WHERE title_primary = 'TEST';
-- Error Code: 1142. DELETE command denied to user 'juanil'@'localhost' for table 'Titles'

