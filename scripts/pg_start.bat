@ECHO OFF
REM PostgreSQL server start

REM Read settings in variables
call pg_read_settings.bat

TITLE Server start [%Server%:%Port%]

%PgCtl% start --pgdata %DataPath%

ECHO ON
PAUSE
