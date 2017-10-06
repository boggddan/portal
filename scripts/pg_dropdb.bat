@ECHO OFF
REM Remove a PostgreSQL database

REM Read settings in variables
CALL "%~dp0\pg_read_settings.bat"

TITLE Remove database [ %PGDATABASE% ] on server [ %PGHOST%:%PGPORT% ]

SET /P PGDATABASE="Put in database name [ %PGDATABASE% ]: "

TITLE Remove database [ %PGDATABASE% ] on server [ %PGHOST%:%PGPORT% ]

ECHO[
ECHO ***
ECHO Database [ %PGDATABASE% ] on server [ %PGHOST%:%PGPORT% ]

dropdb --echo --if-exists --interactive %PGDATABASE%

ECHO[
ECHO ***
ECHO Database [ %PGDATABASE% ] on server [ %PGHOST%:%PGPORT% ] remove!
ECHO[
ECHO ON
PAUSE
