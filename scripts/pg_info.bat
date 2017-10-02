@ECHO OFF
REM PostgreSQL server status

REM Read settings in variables
call pg_read_settings.bat

TITLE Server status [%Server%:%Port%]

%PgCtl% status --pgdata %DataPath%

ECHO ON
PAUSE

