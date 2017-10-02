@ECHO OFF
REM Restore a PostgreSQL database from an archive file created by pg_dump

REM Read settings in variables
call pg_read_settings.bat

REM File name is [database]_[current date]_[current time]
SET cTime=%TIME: =0%
SET RestoreFile="%BackupPath%\portal_edu_20171002_155600"

FOR %%# IN ( "%RestoreFile%" ) DO SET LogFile="%BackupPath%%%~n#--%Database%.log"

TITLE Restore file [ %RestoreFile% ] to database [ %Database% ]

ECHO Please, wait...
ECHO[

%PgRestore% --clean --if-exists --format=custom --host=%Server% --port=%Port% --username=%User% --dbname=%Database% %RestoreFile% > %LogFile%

REM Display result from log-file
TYPE %LogFile%

ECHO[
ECHO ***
ECHO Restore file [ %RestoreFile% ] to database [ %Database% ] complete!
ECHO Read log-file [ %LogFile% ]
ECHO ON
PAUSE
