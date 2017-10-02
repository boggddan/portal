@ECHO OFF
REM PostgreSQL server psql runner script for Windows

REM Смена кодировки
chcp 1251 > NUL

SET Util="C:\Program Files\PostgreSQL\9.6\bin\psql.exe"
SET Server=localhost
SET Database=portal
SET Port=5446
SET Username=postgres
SET PGPASSWORD=1

%Util% --host=%Server% --username=%Username% --dbname=%Database% --port=%Port%

REM "\conninfo" -- информация о текущем соединении
REM "ALTER SYSTEM SET port = 5446" - изменить порт(требуется перегрузка сервера)
REM "SHOW port" - отобразить значение переменной порта

"data/postgresql.auto.conf" - значения которые задаются через psql - приоритетней
"data/postgresql.conf" - стандартный файл конфигурации

ECHO ON
PAUSE
