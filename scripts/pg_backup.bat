@ECHO OFF
REM Extract a PostgreSQL database into archive file

REM Read settings in variables
CALL "%~dp0\pg_read_settings.bat"

REM File name [database]_[current date]_[current time].dump
SET BackupFile="%BackupPath%%PGDATABASE%_%CurrentDatetime%.dump"

SET Title=Create a archive file [ %BackupFile% ] from database [ %PGDATABASE% ] on server [ %PGHOST%:%PGPORT% ]
TITLE %Title%

ECHO.
ECHO %Title%
ECHO.

pg_dump --file=%BackupFile% --format=custom --verbose

ECHO.
ECHO ***
ECHO Backup-file [ %BackupFile% ] from database [ %PGDATABASE% ] on server [ %PGHOST%:%PGPORT% ] complete!
ECHO.

REM Pause when manual start
IF [%1] EQU [] PAUSE

ECHO ON
