@ECHO OFF
REM PostgreSQL server start

REM Read settings in variables
CALL "%~dp0\pg_read_settings.bat"

TITLE Service [ %PgServiceName% ] server [ %PGHOST%:%PGPORT% ] start

REM pg_ctl start

NET START %PgServiceName%

ECHO[
ECHO ***
ECHO Service [ %PgServiceName% ] server [ %PGHOST%:%PGPORT% ] start
ECHO[
ECHO ON
PAUSE
