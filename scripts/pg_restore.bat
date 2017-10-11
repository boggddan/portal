@ECHO OFF
REM Restore a PostgreSQL database from an archive file created by pg_dump

REM Read settings in variables
CALL "%~dp0\pg_read_settings.bat"

SET Title=Restore backup-file to database [ %PGDATABASE% ] on server [ %PGHOST%:%PGPORT% ]
TITLE %Title%

ECHO.
ECHO %Title%
ECHO.

REM File name is [database]_[current date]_[current time]
SET BackupFile=%BackupPath%%PGDATABASE%.dump
SET /P BackupFile="Put in path to backup-file [ %BackupFile% ]: "

IF NOT EXIST %BackupFile% (
  ECHO ***
  ECHO Error: Backup-file [%BackupFile%] is not found!
  GOTO :exit
)

SET Title=Restore file [ %BackupFile% ] to database [ %PGDATABASE% ] on server [ %PGHOST%:%PGPORT% ]

TITLE %Title%

ECHO.
ECHO %Title%
ECHO.

SET /P ComfirmExec=Are you sure (Y/[N])?
IF /I [%ComfirmExec%] NEQ [Y] GOTO :EOF

FOR %%* IN ( "%BackupFile%" ) DO SET LogFile="%BackupPath%%%~n*--%PGDATABASE%.log"

ECHO Please, wait...
ECHO.

ECHO ***
ECHO Kill all connections
SET KillConnections="SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity WHERE datname = '%PGDATABASE%' AND pid <> pg_backend_pid();"
psql --echo-all --command=%KillConnections%
ECHO.

ECHO ***
ECHO Remove database
dropdb  --echo --if-exists %PGDATABASE%
ECHO.

ECHO ***
ECHO Create database
createdb --echo --locale=%Locale% --encoding=%Encoding% %PGDATABASE%
ECHO.

REM "--clean --if-exists"is generate error!!!

ECHO ***
ECHO Restore database
pg_restore.exe --format=custom --exit-on-error --verbose --dbname=%PGDATABASE% "%BackupFile%" > %LogFile% 2>&1

REM Display result from log-file
TYPE %LogFile%

ECHO.
ECHO ***
ECHO Restore file [ %BackupFile% ] to database [ %PGDATABASE% ] on server [ %PGHOST%:%PGPORT% ] complete!
ECHO Read log-file [ %LogFile% ]
ECHO.

:exit
ECHO ON
PAUSE
