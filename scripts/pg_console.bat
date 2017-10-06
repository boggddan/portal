@ECHO OFF
REM PostgreSQL server psql runner script for Windows

REM Read settings in variables
CALL "%~dp0\pg_read_settings.bat"

TITLE Console for database [ %PGDATABASE% ] on server [ %PGHOST%:%PGPORT% ]

psql --echo-all

REM "\conninfo" -- информация о текущем соединении
REM "ALTER SYSTEM SET port = 5446" - изменить порт(требуется перегрузка сервера)
REM "SHOW port" - отобразить значение переменной порта

REM "data/postgresql.auto.conf" - значения которые задаются через psql - приоритетней
REM "data/postgresql.conf" - стандартный файл конфигурации

ECHO ON
