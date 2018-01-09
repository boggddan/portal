@echo OFF

REM Read settings in variables

SET BaseConfig=%~dp0..\config\database.yml

REM Change codepage
chcp 1251 > NUL

SETLOCAL ENABLEDELAYEDEXPANSION

FOR /F "delims=:; tokens=1,2" %%a IN ( %BaseConfig% ) DO (
  CALL :Trim "%%a" Key
  CALL :Trim "%%b" Value
  IF /I !Key! EQU database SET PGDATABASE=!Value!
  IF /I !Key! EQU host SET PGHOST=!Value!
  IF /I !Key! EQU port SET PGPORT=!Value!
  IF /I !Key! EQU username SET PGUSER=!Value!
  IF /I !Key! EQU password SET PGPASSWORD=!Value!
)

ENDLOCAL ^
  && SET PGDATABASE=%PGDATABASE% ^
  && SET PGHOST=%PGHOST% ^
  && SET PGPORT=%PGPORT% ^
  && SET PGUSER=%PGUSER% ^
  && SET PGPASSWORD=%PGPASSWORD%

ECHO %PGDATABASE%
ECHO %PGHOST%
ECHO %PGPORT%
ECHO %PGUSER%
ECHO %PGPASSWORD%


GOTO :EOF

REM========================================================
REM Function remove leading and ending spaces
:Trim

SETLOCAL
SET localInput=%1

REM Exclamation mark "!" change for "EnableDelayedExpansion'
SET localInputChange=%localInput:!=^^^!%

SETLOCAL ENABLEDELAYEDEXPANSION

SET localResult=

FOR /F %%* in ('ECHO(%localInputChange: ="^&ECHO("%') DO (
  IF %%* NEQ "" (
    REM If variable not defined - not add leading space
    REM And ending spaces not add, because they add to word
    IF NOT DEFINED localResult (SET "localResult=%%~*"
      ) ELSE SET "localResult=!localResult! !spaces!%%~*"
    SET spaces=
    )

  REM Count spaces between word
  IF %%* EQU "" SET "spaces= !spaces!"
)

REM Only for testing
REM ECHO.&& ECHO input=[!localInput:~1,-1!]&& ECHO result=[!localResult!]

ENDLOCAL && SET "returnResult=%localResult%"
ENDLOCAL && SET "%~2=%returnResult%"
GOTO :EOF

