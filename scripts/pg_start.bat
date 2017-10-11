@ECHO OFF
REM PostgreSQL server start

REM Read settings in variables
CALL "%~dp0\pg_read_settings.bat"

SET Title=Service [ %PgServiceName% ] server [ %PGHOST%:%PGPORT% ] start
TITLE %Title%

ECHO.
ECHO ***
ECHO %Title%
ECHO.

REM pg_ctl start

NET START "%PgServiceName%"

ECHO ON
PAUSE
