@ECHO OFF
REM PostgreSQL server status

REM Read settings in variables
CALL "%~dp0\pg_read_settings.bat"

SET Title=Service [ %PgServiceName% ] server [ %PGHOST%:%PGPORT% ] status
TITLE %Title%

ECHO.
ECHO ***
ECHO %Title%
ECHO.

pg_ctl status

ECHO.
ECHO ***

sc query "%PgServiceName%"

ECHO ON
PAUSE

