@ECHO OFF
REM Archive rails project

REM Read settings in variables
CALL "%~dp0\pg_read_settings.bat"

REM File name is [project name]_[current date]_[current time].zip
SET BackupFile="%BackupPath%%ProjectName%_%CurrentDatetime%.zip"

TITLE Create a archive file [ %BackupFile% ] from project [ %ProjectName% ] [ %ProjectPath% ]

7z a %BackupFile% "%ProjectPath%" -x@"%ProjectPath%\.7zignore"

ECHO[
ECHO ***
ECHO Backup-file [ %BackupFile% ] from project [ %ProjectName% ] [ %ProjectPath% ] complete!
ECHO[

REM Наличие параметров для запуска с других батиков, что бы
REM не останавливало программу
IF [%1] EQU [] (
  ECHO ON
  PAUSE
)
