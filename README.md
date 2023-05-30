# Proyecto Final Curso SQL - Coderhouse

*Comisión 43410*

**Juan Ignacio Landolfi**

<br>

## Objetivo del Trabajo

<br>
Crear y normalizar los datasets provenientes de IMDb relacionado a peliculas y series. Los datasets tienen datos sobre peliculas, cortos, series como ser: duración, género, año de lanzamiento, personas involucradas con sus roles respectivos, etc.
<br>

Queremos poder ser capaces de:
- Buscar titulos por nombre, director, categoría, etc.
- Obtener listados de las peliculas del ultimo año con mayor rating.
- Consultar el director con mayor rating promedio en sus producciones.
- Actores con mayor cantidad de titulos en la db.
- Etc.

<br>

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
