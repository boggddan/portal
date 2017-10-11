@ECHO OFF
REM Create a new PostgreSQL database

REM Read settings in variables
CALL "%~dp0\pg_read_settings.bat"

SET Title=Create a new database on server [ %PGHOST%:%PGPORT% ]
TITLE %Title%

ECHO.
ECHO %Title%
ECHO.

SET /P PGDATABASE="Put in database name [ %PGDATABASE% ]: "

TITLE Create database [ %PGDATABASE% ] on server [ %PGHOST%:%PGPORT% ]

ECHO.

SET /P ComfirmExec=Are you sure (Y/[N])?
ECHO.
IF /I [%ComfirmExec%] NEQ [Y] GOTO :EOF

createdb --echo --locale=%Locale% --encoding=%Encoding%

ECHO ON
PAUSE
