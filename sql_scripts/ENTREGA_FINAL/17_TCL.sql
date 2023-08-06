-- TCL

USE IMDB_DB;

/*
	Vamos a realizar inserciones y eliminaciones en dos tablas controlando las transacciones.
*/

-- Para eso necesitamos setear la variable AUTOCOMMIT en 0
-- Controlamos que por default está en 1.
SELECT @@AUTOCOMMIT;
-- Cambiamos.
SET AUTOCOMMIT = 0;
-- Volvemos a controlar.
SELECT @@AUTOCOMMIT as new_value_autocommit;

-- Delete en tabla Person;

-- Iniciamos una transacción
START TRANSACTION;

SELECT * FROM Person limit 1;
DELETE FROM Person WHERE person_id = 1;
SELECT * FROM Person limit 1;

/*	
	Hasta este punto los cambios no impactaron permanentemente en la base de datos. 
	Si reestablecemos la conexión vamos a ver que el primer elemento a retornar sigue siendo la persona con id = 1 .
    Para dejar firme los cambios necesitamos realizar un COMMIT. 
    También podemos realizar un ROLLBACK en caso de querer deshacer todos los cambios realizados desde 'START TRANSACTION'.
*/

-- ROLLBACK
COMMIT;

-- INSERTAMOS EL DATO NUEVAMENTE.
START TRANSACTION;
INSERT INTO Person (person_id, primary_profession_id, primary_name, birth_year, death_year) VALUES (1 ,14, 'Edmond Agabra', 1926, 2012);
COMMIT;

/*
	Segundo ejemplo. Inserción.
    Vamos a cargar distintas profesiones y definiendo algunos savepoints.
*/
START TRANSACTION;

SELECT * FROM Profession;

INSERT INTO Profession (profession_name) VALUES ('PROFESION 01');
INSERT INTO Profession (profession_name) VALUES ('PROFESION 02');
INSERT INTO Profession (profession_name) VALUES ('PROFESION 03');
INSERT INTO Profession (profession_name) VALUES ('PROFESION 04');
INSERT INTO Profession (profession_name) VALUES ('PROFESION 05');
SAVEPOINT lote_01;
INSERT INTO Profession (profession_name) VALUES ('PROFESION 06');
INSERT INTO Profession (profession_name) VALUES ('PROFESION 07');
INSERT INTO Profession (profession_name) VALUES ('PROFESION 08');
INSERT INTO Profession (profession_name) VALUES ('PROFESION 09');
INSERT INTO Profession (profession_name) VALUES ('PROFESION 10');
SAVEPOINT lote_02;

-- Si controlamos ahora vamos a ver que se cargaron los 10 registros aunque todavía no están confirmados.
SELECT * FROM Profession ORDER BY profession_id DESC;
-- Podemos volver a algun estado anterior definido por alguno de los savepoint
-- Volvemos por ejemplo al estado del lote_01 donde tenemos 5 registros nuevos.
ROLLBACK TO lote_01;

-- Controlamos que esto es así y tengamos solamente los registros cargados hasta el savepoint lote_01
SELECT * FROM Profession ORDER BY profession_id DESC;

-- Podemos eliminar un savepoint.
RELEASE SAVEPOINT lote_01;
-- Como ya volvimos más atrás del momento en que el lote_02 fue definido no puedo ir hacia adelante con un rolllback al lote_02. Eso resulta en un error
-- ROLLBACK TO lote_02;
-- Error Code: 1305. SAVEPOINT lote_02 does not exist

-- Hasta este punto lo único que faltaría hacer es un commit o un rollback para confirmar o deshacer lo hecho hasta el momento. 
-- Vamos a hacer un ROLLBACK ya que no nos interesan estos registros.
ROLLBACK;
SELECT * FROM Profession ORDER BY profession_id DESC;
