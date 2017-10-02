@ECHO OFF
REM Create a new PostgreSQL database

REM Read settings in variables
call pg_read_settings.bat

TITLE Create a new database [%Database%]

%CreateDB% --echo --host=%Server% --port=%Port% --username=%User% --locale=%Locale% --encoding=%Encoding% %Database%

ECHO[
ECHO ***
ECHO Database [ %Database% ] create!
ECHO ON
PAUSE
