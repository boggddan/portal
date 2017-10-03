REM @ECHO OFF
REM Extract a PostgreSQL database into a script file or other archive file

REM Read settings in variables
call pg_read_settings2.bat

REM File name is [database]_[current date]_[current time]
SET cTime=%TIME: =0%
SET BackupFile="%BackupPath%%Database%_%DATE:~-4%%DATE:~3,2%%DATE:~0,2%_%cTIME:~0,2%%TIME:~3,2%%TIME:~6,2%"

TITLE Create a archive file [%Database%]

%PgDump% --file=%BackupFile% --format=c --verbose --host=%Server% --port=%Port% --username=%User% --dbname=%Database%

ECHO[
ECHO ***
ECHO Backup File [%BackupFile%] create!
ECHO ON
PAUSE
