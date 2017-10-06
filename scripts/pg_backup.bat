@ECHO OFF
REM Extract a PostgreSQL database into archive file

REM Read settings in variables
CALL "%~dp0\pg_read_settings.bat"

REM File name [database]_[current date]_[current time].dump
SET BackupFile="%BackupPath%%PGDATABASE%_%CurrentDatetime%.dump"

TITLE Create a archive file [ %BackupFile% ] from database [ %PGDATABASE% ] on server [ %PGHOST%:%PGPORT% ]
echo %PGDATABASE%
pg_dump --file=%BackupFile% --format=custom --verbose

ECHO[
ECHO ***
ECHO Backup-file [ %BackupFile% ] from database [ %PGDATABASE% ] on server [ %PGHOST%:%PGPORT% ] complete!
ECHO[

REM Наличие параметров для запуска с других батиков, что бы
REM не останавливало программу
IF [%1] EQU [] (
  ECHO ON
  PAUSE
)
