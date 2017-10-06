@ECHO OFF
REM PostgreSQL server status

REM Read settings in variables
CALL "%~dp0\pg_read_settings.bat"

ECHO "%~dp0..\pg_read_settings.bat"

TITLE Service [ %PgServiceName% ] server [ %PGHOST%:%PGPORT% ] status

pg_ctl status
ECHO[
ECHO ***

sc query %PgServiceName%

ECHO[
ECHO ***
ECHO Service [ %PgServiceName% ] server [ %PGHOST%:%PGPORT% ] info
ECHO[
ECHO ON
PAUSE

