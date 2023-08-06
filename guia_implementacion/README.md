## Guía de implementación.
<br>

Para reproducir el schema ejecutar los scripts sql ubicados en `/sql_scripts/ENTREGA_FINAL` en el siguiente orden:
<br>

- 00_schema_table_creation.sql
- 01_insert_language.sql
- 02_insert_region.sql
- 03_insert_title_types.sql
- 04_insert_profession.sql
- 05_insert_genres.sql
- 06_insert_title.sql
- 07_insert_title_genres.sql
- 08_insert_titles_akas.sql
- 09_insert_episodes.sql
- 10_insert_person.sql
- 11_insert_crew.sql
- 12_views.sql
- 13_functions.sql
- 14_stored_procedure.sql
- 15_triggers.sql
- 16_DCL.sql
- 17_TCL.sql
- 18_backup.sql

<br>

En caso de tener problemas en ejecutar los archivos grandes es posible realizar la importación desde un csv. Estos se pueden encontrar en la carpeta `csv` en el root del repositorio.
Los files que pueden presentar problemas son los siguientes:

<br>

- 06_insert_titles.csv
- 08_insert_titles_akas.csv
- 10_insert_person.csv
- 11_insert_crew.csv