@ECHO OFF
REM Remove old backup

REM Read settings in variables
CALL "%~dp0\pg_read_settings.bat"

REM File name is [project name]_[current date]_[current time].zip
SET BackupFile="%BackupPath%%ProjectName%_%CurrentDatetime%.zip"

TITLE Create a archive file [ %BackupFile% ] from project [ %ProjectName% ] [ %ProjectPath% ]


for /f "skip=10 eol=: delims=" %%F in ('DIR *.bat /B /O:-D /A:-D') DO ECHO "%%F"

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
