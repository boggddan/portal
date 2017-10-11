@ECHO OFF
REM Archive rails project

REM Read settings in variables
CALL "%~dp0\pg_read_settings.bat"

REM File name is [project name]_[current date]_[current time].zip
SET BackupFile="%BackupPath%%ProjectName%_%CurrentDatetime%.zip"

SET Title=Create a archive file [ %BackupFile% ] from project [ %ProjectName% ] [ %ProjectPath% ]
TITLE %Title%

ECHO.
ECHO ***
ECHO %Title%
ECHO.

7z a %BackupFile% "%ProjectPath%" -x@"%ProjectPath%\.7zignore"

REM Pause when manual start
IF [%1] EQU [] PAUSE

ECHO ON
