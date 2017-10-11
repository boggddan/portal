@ECHO OFF
REM Clear rails waste file

REM Read settings in variables
CALL "%~dp0\pg_read_settings.bat"

SET Title=Clear rails waste file from project [ %ProjectName% ] [ %ProjectPath% ]
TITLE %Title%

ECHO.
ECHO ***
ECHO %Title%
ECHO Please, wait...

IF EXIST "%ProjectPath%\log" RMDIR "%ProjectPath%\log" /s /q
IF EXIST "%ProjectPath%\public\assets" RMDIR "%ProjectPath%\public\assets" /s /q
IF EXIST "%ProjectPath%\tmp" RMDIR "%ProjectPath%\tmp" /s /q

ECHO.
ECHO ***
ECHO Remove all waste file complete!
ECHO.

REM Pause when manual start
IF [%1] EQU [] (
  PAUSE
  ECHO ON
)
