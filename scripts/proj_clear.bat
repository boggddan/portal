@ECHO OFF
REM Clear rails waste file

REM Read settings in variables
CALL "%~dp0\pg_read_settings.bat"

TITLE Clear rails waste file from project [ %ProjectName% ] [ %ProjectPath% ]

ECHO ***
ECHO Clear rails waste file from project [ %ProjectName% ] [ %ProjectPath% ]
ECHO Please, wait...

IF EXIST "%ProjectPath%\log" RMDIR "%ProjectPath%\log" /s /q
IF EXIST "%ProjectPath%\public\assets" RMDIR "%ProjectPath%\public\assets" /s /q
IF EXIST "%ProjectPath%\tmp" RMDIR "%ProjectPath%\tmp" /s /q

ECHO[
ECHO ***
ECHO Remove all waste file complete!
ECHO[

REM Наличие параметров для запуска с других батиков, что бы
REM не останавливало программу
IF [%1] EQU [] (
  ECHO ON
  PAUSE
)
