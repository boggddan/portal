@ECHO OFF
REM PostgreSQL server restart

REM Read settings in variables
CALL "%~dp0\pg_read_settings.bat"

TITLE Service [ %PgServiceName% ] server [ %PGHOST%:%PGPORT% ] restart

REM pg_ctl -w restart

NET STOP %PgServiceName% & NET START %PgServiceName%

ECHO[
ECHO ***
ECHO Service [ %PgServiceName% ] server [ %PGHOST%:%PGPORT% ] restart
ECHO[
ECHO ON
PAUSE
