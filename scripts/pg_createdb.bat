@ECHO OFF
REM Create a new PostgreSQL database

REM Read settings in variables
CALL "%~dp0\pg_read_settings.bat"

TITLE Create a new database [%PGDATABASE%][ %PGDATABASE% ] on server [ %PGHOST%:%PGPORT% ]

SET /P PGDATABASE="Put in database name [ %PGDATABASE% ]: "

TITLE Remove database [ %PGDATABASE% ] on server [ %PGHOST%:%PGPORT% ]

ECHO[
ECHO ***
ECHO Database [ %PGDATABASE% ] on server [ %PGHOST%:%PGPORT% ]

SET /P ComfirmExec=Are you sure (Y/[N])?
IF /I [%ComfirmExec%] NEQ [Y] GOTO :EOF

createdb --echo --locale=%Locale% --encoding=%Encoding%

ECHO[
ECHO ***
ECHO Database [ %PGDATABASE% ] on server [ %PGHOST%:%PGPORT% ] create!
ECHO[
ECHO ON
PAUSE
