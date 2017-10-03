@ECHO OFF
REM Restore a PostgreSQL database from an archive file created by pg_dump

REM Read settings in variables
call pg_read_settings.bat

REM File name is [database]_[current date]_[current time]
SET cTime=%TIME: =0%
REM SET RestoreFile=%BackupPath%\portal_edu_20171002_155600
SET RestoreFile=portal_edu_20171003_161654

FOR %%# IN ( "%RestoreFile%" ) DO SET LogFile="%BackupPath%%%~n#--%Database%.log"

TITLE Restore file [ %RestoreFile% ] to database [ %Database% ]

ECHO Please, wait...
ECHO[

ECHO ***
ECHO Kill all connections
SET KillConnections="SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity WHERE datname = '%Database%' AND pid <> pg_backend_pid();"
%Psql% --echo-all --command=%KillConnections% --host=%Server% --port=%Port% --username=%User% --dbname=%Database%
ECHO[

ECHO ***
ECHO Remove database
%DropDB%  --echo --if-exists --host=%Server% --port=%Port% --username=%User% %Database%
ECHO[

ECHO ***
ECHO Create database
%CreateDB% --echo --host=%Server% --port=%Port% --username=%User% --locale=%Locale% --encoding=%Encoding% %Database%
ECHO[

REM REM "--clean --if-exists"is generate error!!!

ECHO ***
ECHO Restore database
%PgRestore% --format=custom --host=%Server% --port=%Port% --username=%User% --dbname=%Database% "%RestoreFile%" > %LogFile% 2>&1
REM %PgRestore% --clean --if-exists --format=custom --host=%Server% --port=%Port% --username=%User% --dbname=%Database% "%RestoreFile%" > %LogFile% 2>&1

REM Display result from log-file
TYPE %LogFile%

ECHO[
ECHO ***
ECHO Restore file [ %RestoreFile% ] to database [ %Database% ] complete!
ECHO Read log-file [ %LogFile% ]
ECHO ON
PAUSE
