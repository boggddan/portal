@ECHO OFF
REM Remove a PostgreSQL database

REM Read settings in variables
call pg_read_settings.bat

TITLE Remove database [%Database%]

%DropDB%  --echo --if-exists --interactive --host=%Server% --port=%Port% --username=%User% %Database%

ECHO[
ECHO ***
ECHO Database [ %Database% ] remove!
ECHO ON
PAUSE
