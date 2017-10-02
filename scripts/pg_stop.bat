@ECHO OFF
REM PostgreSQL server stop

REM Read settings in variables
call pg_read_settings.bat

TITLE Server stop [%Server%:%Port%]

%PgCtl% stop --pgdata %DataPath%

ECHO ON
PAUSE
