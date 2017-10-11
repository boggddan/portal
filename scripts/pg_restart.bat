@ECHO OFF
REM PostgreSQL server restart

REM Read settings in variables
CALL "%~dp0\pg_read_settings.bat"

SET Title=Service [ %PgServiceName% ] server [ %PGHOST%:%PGPORT% ] restart
TITLE %Title%

ECHO.
ECHO ***
ECHO %Title%
ECHO.

REM pg_ctl -w restart

NET STOP "%PgServiceName%" & NET START "%PgServiceName%"

ECHO ON
PAUSE
