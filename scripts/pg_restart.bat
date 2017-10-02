@ECHO OFF
REM PostgreSQL server restart

REM Read settings in variables
call pg_read_settings.bat

TITLE Server restart [%Server%:%Port%]

%PgCtl% -w restart --pgdata %PathData%

ECHO ON
PAUSE
