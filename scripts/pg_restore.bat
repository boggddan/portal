@ECHO OFF
REM Restore a PostgreSQL database from an archive file created by pg_dump

REM Read settings in variables
CALL "%~dp0\pg_read_settings.bat"

TITLE Restore backup-file to database [ %PGDATABASE% ] on server [ %PGHOST%:%PGPORT% ]

REM File name is [database]_[current date]_[current time]
SET BackupFile=%BackupPath%%PGDATABASE%
REM SET /P BackupFile="Put in path to backup-file [%BackupFile%]: "

REM IF NOT EXIST %BackupFile% (
REM   ECHO ***
REM   ECHO Error: Backup-file [%BackupFile%] is not found!
REM   GOTO :exit
REM )

TITLE Restore file [ %BackupFile% ] to database [ %PGDATABASE% ] on server [ %PGHOST%:%PGPORT% ]

ECHO ***
ECHO Server: [ %PGHOST%:%PGPORT% ]
ECHO Database: [%PGDATABASE%]
ECHO Backup-file: [%BackupFile%]
ECHO[

REM SET /P ComfirmExec=Are you sure (Y/[N])?
REM IF /I [%ComfirmExec%] NEQ [Y] GOTO :EOF

FOR %%* IN ( "%BackupFile%" ) DO SET LogFile="%BackupPath%%%~n*--%PGDATABASE%.log"

ECHO Please, wait...
ECHO[

REM ECHO ***
REM ECHO Kill all connections
REM SET KillConnections="SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity WHERE datname = '%PGDATABASE%' AND pid <> pg_backend_pid();"
REM psql --echo-all --command=%KillConnections% --host=%PGHOST% --port=%PGPORT% --username=%PGUSER% --dbname=%PGDATABASE%
REM ECHO[

REM ECHO ***
REM ECHO Remove database
REM dropdb  --echo --if-exists --host=%PGHOST% --port=%PGPORT% --username=%PGUSER% %PGDATABASE%
REM ECHO[

REM ECHO ***
REM ECHO Create database
REM createdb --echo --host=%PGHOST% --port=%PGPORT% --username=%PGUSER% --locale=%Locale% --encoding=%Encoding% %PGDATABASE%
REM ECHO[

REM REM "--clean --if-exists"is generate error!!!

ECHO %BackupFile%

ECHO ***
ECHO Restore database
REM pg_restore --format=custom --dbname=%PGDATABASE% "%BackupFile%"
REM  %LogFile% 2>&1


REM Display result from log-file
TYPE %LogFile%

ECHO[
ECHO ***
ECHO Restore file [ %BackupFile% ] to database [ %PGDATABASE% ] on server [ %PGHOST%:%PGPORT% ] complete!
ECHO Read log-file [ %LogFile% ]
ECHO[

REM :exit
ECHO ON
PAUSE
