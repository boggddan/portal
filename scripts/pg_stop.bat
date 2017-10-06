@ECHO OFF
REM PostgreSQL server stop

REM Read settings in variables
CALL "%~dp0\pg_read_settings.bat"

TITLE Service [ %PgServiceName% ] server [ %PGHOST%:%PGPORT% ] stop

REM pg_ctl stop

NET STOP %PgServiceName%

ECHO[
ECHO ***
ECHO Service [ %PgServiceName% ] server [ %PGHOST%:%PGPORT% ] stop
ECHO[
ECHO ON
PAUSE
