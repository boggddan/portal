@ECHO OFF
REM PostgreSQL server stop

REM Read settings in variables
CALL "%~dp0\pg_read_settings.bat"

SET Title=Service [ %PgServiceName% ] server [ %PGHOST%:%PGPORT% ] stop
TITLE %Title%

ECHO.
ECHO ***
ECHO %Title%
ECHO.

REM pg_ctl stop

NET STOP "%PgServiceName%"

ECHO ON
PAUSE
