# Proyecto Final Curso SQL - Coderhouse

*Comisión 43410*

**Juan Ignacio Landolfi**

<br>

## Objetivo del Trabajo

<br>
Crear y normalizar los datasets provenientes de IMDb relacionado a peliculas y series. Los datasets tienen datos sobre peliculas, cortos, series como ser: duración, género, año de lanzamiento, personas involucradas con sus roles respectivos, etc.
<br>

Queremos poder ser capaces de:
- Tener un uso eficiente del espacio de almacenamiento al normalizar las tablas.
- Buscar titulos por nombre, director, categoría, etc.
- Actores con mayor cantidad de titulos en la db.
- Etc.

<br>

## DER

![Diagrama de Entidad Relacion TP Final](https://raw.githubusercontent.com/Juanlandolfi/SQL_PROJECT_CODERHOUSE/main/DER.png)



## Descripción de las tablas propuestas para normalizar la base de datos

**Titles**: Información respectica a los títulos de las producciones.
- title_id: PK. Identificador unico numerico.
- title_type_id: FK. Identificados del tipo de produccion(movie, series, etc.).
- title_primary:Nombre más popular por el cual se conoce.
- title_original: Título original en su idioma original.
- title_adult: Booleano, si es +18 o no.
- title_start_year: Año lanzamiento, inicio primer capítulo si es serie.
- title_end_year: Corresponde si es serie, fecha lanzamiento ultimo capítulo.
- title_runtime: Duración del título en minutos.
- last_modified: Ultima fecha de moficación del registro.

**Titles_aka**: Títulos localizados, por idiomas, tipo presentación .
- title_aka_id: PK. Identificados único del título localizado.
- title_id: FK. Referencia  a la tabla principal Titles.
- region_id: FK. ID region.
- language_id: FK. ID idioma.
- title_localize: Nombre del título.
- title_is_original: Booleano indicando si es el título original.
- title_types: Atributos extras para identificacion del título(DVD, festival , TV, etc.).
- last_modified: Ultima fecha de moficación del registro.

**Title_types**: Tipo y/o formato del título (Movie, short, tvseries, tvepisode, etc).
- type_id: PK. ID único.
- type_name:  Nombre tipo.
- last_modified: Ultima fecha de moficación del registro.


**Crew**: Información respectica a las personas que participaron de un título (escritores, directores, actores, actrices).
- crew_id: PK. Identificador unico numerico.
- title_id: FK. Referencia  a la tabla Titles.
- person_id: FK. Referencia a la tabla Person.
- profession_id: FK. Referencia a la tabla Profession.
- last_modified: Ultima fecha de moficación del registro.

**Language**: Idioma.
- language_id: PK. ID único.
- language_code:  Nombre idioma (abreviatura).
- last_modified: Ultima fecha de moficación del registro.

**Regions**: Regiones/País.
- region_id: PK. ID único.
- region_code:  Codigo de región (abreviatura).
- last_modified: Ultima fecha de moficación del registro.

**Genres**: Géneros.
- genre_id: PK. ID único.
- genre_name:  Nombre género.
- last_modified: Ultima fecha de moficación del registro.

**Person**: Información respectiva a personas involucradas en los titulos.
- person_id: PK. ID único.
- primary_name: Nombre.
- birth_year: Año nacimiento.
- death_year: Año fallecimiento.
- primary_profession: Profesión por la que es más conocido.
- last_modified: Ultima fecha de moficación del registro.

**Episodes**: Relaciona los titulos que son episodios con el titulo general que describe una serie. Aporta también información sobre el episodio en particular.
- episode_id: PK. ID único.
- title_id: FK. Referencia a la tabla Titles para el titulo del episodio.
- title_parent_id: FK. Referencia a la tabla Titles para el titulo de la serie.
- season_numer: Número de temporada.
- episode_number: Número de capítulo
- last_modified: Ultima fecha de moficación del registro.

**Profession**: Tabla donde se listan los distintos tipos de profesiones de las personas.
- profession_id: PK. ID único.
- profession_name: Nombre de la profesión.
- last_modified: Ultima fecha de moficación del registro.

**Title_Genres**: Tabla intermedia donde relacionamos peliculas con sus generos.
- title_genre_id: PK. ID único.
- title_id: FK. Referencia a la tabla Titles para el titulo del episodio.
- genre_id: FK. Referencia a la tabla Genres.

<br>

## Views

<br>

Creamos 5 views para estas tablas hasta el momento:
<br>

**VW_films_type_dire_writer**: 
<br>

- Tablas involucradas: Crew, Titles, Person, Profession, Title_types.
- Detalle: Vamos a generar un reporte donde figuren todos los titulos para los cuales tengamos información sobre Directores y Escritories (en tabla Crew). Vamos a recibir un reporte con tres columnas _'Titulo original'_, _'Tipo de Título'_ y _'Directores/Escritores'_. La útlima columna es un campo concatenado donde se leen los nombres de directores y escritores con su rol entre paréntesis.
Como partimos desde la tabla crew donde están cargados estos roles junto con las peliculas solo obtenemos los titulos para los cuales hay datos.



**VW_crew_to_complete**:
<br>

- Tablas involucradas: Titles, Crew.
- Detalle: Generamos una vista que nos de el porcentaje titulos que todavía no tiene cargado ningun escritos ni director. Para eso hacemos join en _'Titles'_ y _'Crew'_ para ver cuantos titles_id hay que no tengan un crew_id asociado en ese join. Es decir, contamos todos los titles_id donde crew_id sea null. A ese valor lo dividimos por la subconsulta que nos devuelve el total de titulos en la tabla _'Titles'_. 

**VW_quantity_per_genre**
<br>

- Tablas involucradas: Titles, Genres, Title_Genres
- Detalle: Obtenemos un resumen de la cantidad de titulos que tenemos cargados por genero en la base de datos. Para eso creamos un join entre _'Titles'_ y _'Genres'_ a partir de la tabla intermedia _'Title_Genres'_. Sobre la tabla resultante creamos un group by a partir de la columna _genre_name_ de la tabla _'Genres'_ ejecutando un COUNT en el SELECT sobre cualquier columna, en este caso, sobre la columna 'title_original' de la tabla _'Titles'_. 

**VW_profession_count**
<br>

- Tablas involucradas: Person, Profession.
- Detalle: Obtenemos un resumen sobre la cantidad de profesiones de las personas que tenemos cargada en nuestra base de datos. Muy similar al caso anterior, pero esta vez sobre las tablas _'Person'_ y _'Profession'_ aplicando un group by sobre la columna 'profession_name' de la tabla _'Profession'_.

**VW_titles_last_3_years**
<br>

- Tablas involucradas: Titles
- Detalle: Utilizando solo la tabla _'Titles'_ filtramos los titulos que hayan sido lanzados dentro de los ultimos 3 años. Para ello usamos las funciones nativas NOW() y YEAR() para extraer el año actual al momento de ejecutar la consulta, sustraemos el año de lanzamiento del titulo ubicado la columna 'title_start_year' y aplicamos el filtro en la clausula WHERE para aquellos registros cuyo resultado en esta operación sea menor o igual a 3.

<br>

## Functions

<br>

Creamos 2 funciones hasta el momento:

<br>


**quantity_of_crew**
<br>

- Tablas involucradas: Crew.
- Detalle: La función recibe como parametro un INTEGER que corresponde a un title_id. Retorna un COUNT() de la columna 'title_id' en la tabla Crew donde coincida con el id pasado como parametro. El resultado es saber la cantidad de escritores/directores que ese titulo posee.

**ads_budget**
<br>

- Tablas involucradas: Titles, Crew, Profession.
- Situación: _Desde gerencia van a aplicar una campaña de difusión de peliculas que se hayan lanzado luego del AÑO_X (Parametro de entrada). Se va a dar un presupuesto por titulo equivalente a $500 por cada director y $250 por cada escritor que esté cargado en la base datos. Para aquellos titulos sobre los cuales no tengamos ningun director ni escritor cargado van a asignar $50. Nos piden que se pueda ingresar el año de corte a partir del cual se van contar los titulos como parametro de la función._
- Detalle: Primero hacemos un join de las tres tablas detalladas. Luego agrupamos por titulo y profesion, haciendo un COUNT() sobre la columna 'crew_id' para obtener la cantidad de escritores/directores involucrados en cada film. Además realizamos un CASE sobre 'profession_name' para tener una columna con el precio a pagar en cada caso (500 en caso que sea director, 250 escritores y 50 si el campo professión queda nulo). Todo este primer proceso se vuelve una subconsulta sobre la cual trabajamos para realizar la suma a pagar. Para esto volvemos a utilizar un CASE que nos permita asignar el valor 1 a la columna cantidad cuando sea 0. La suma resultante se asigna a la variables _campaing_cost_ que es la que retorna nuestra función.

<br>

## Stored Procedures

<br>

Para los stored procedures también hemos creado dos diferentes.

<br>

**SP_titles_last_x_years**
<br>

- Tablas involucradas: Titles.
- Detalle: Este procedimiento viene a complementar una view generada anteriormente. Pero esta vez permite que nosotros pasamos el año desde el cual queremos filtrar los titulos a partir de su fecha de lanzamiento dada por la columns 'start_year'. <br>
En la rutina `SP_titles_last_x_years` tenemos los parametros: <br>
__x_years__: Filtra los titulos desde X años atras con este valor. <br>
__column_sort__: Columna a utilizar para ordenar los valores. <br>
__is_ascending__: Booleano. Si es True ordena de forma ascendente, caso contrario de forma descendente. <br>
Generamos una consulta sql simple a partir de concatenar los distintos valores suministrados en los parametros de entrada, ejecturamos la misma y eso es retornado al usuario. El resultado es un listado de la tabla _'Titles'_ filtrado a partir de la fecha suministrada y ordenado por la columna indicada de forma ascendente o descendente si el parametro is_ascending es verdadero o falso respectivamente.

<br>

**SP_delete_last_person_added**
<br>

- Tablas involucradas: Person.
- Situación: Necesitamos crear rutina que nos permita eliminar el último registro cargado en la tabla Person. Se puede pensar como el boton de Deshacer luego de una acción de inserción.
- Detalle: En esta rutina se busca, a partir de la función MAX() en la columna de la primary key, el último registro ingresado. Esa id es guardada en una variable y luego utilizada para filtrar el registro en la sentencia de eliminación.
<br>


## Triggers

<br>

**insert_titles_log_trigger**
<br>

- Este trigger se dispara cuando se inserta una valor en la tabla Titles, la cual es nuestra tabla más importante en la base de datos. Este trigger guarda la misma información que la tabla Titles en una nueva tabla llamada `Log_titles` pero también agrega información relacionada al usuario que realizó la operación.
<br>

**update_titles_log_trigger**
<br>

- Guarda la misma información que el trigger anterior pero en el contexto de un update a la tabla Titles.
<br>

**delete_titles_log_trigger**
<br>

- Guarda la misma información que el trigger anterior pero en el contexto de un delete a la tabla Titles.
<br>

**insert_language_trigger**
<br>

- Este trigger convierte a minúsculas los datos que se están por grabar en la tabla Languages antes de cada inserción. Con el mismo nos aseguramos que todos los valores cargados en esta tabla sean lowercase.
<br>