@ECHO OFF
REM Remove a PostgreSQL database

REM Read settings in variables
CALL "%~dp0\pg_read_settings.bat"

SET Title=Remove database on server [ %PGHOST%:%PGPORT% ]
TITLE %Title%

ECHO.
ECHO %Title%
ECHO.

SET /P PGDATABASE="Put in database name [ %PGDATABASE% ]: "
ECHO.

TITLE=Remove database [ %PGDATABASE% ] on server [ %PGHOST%:%PGPORT% ]

ECHO.
ECHO ***
ECHO Database [ %PGDATABASE% ] on server [ %PGHOST%:%PGPORT% ]

dropdb --echo --if-exists --interactive %PGDATABASE%

ECHO ON
PAUSE
