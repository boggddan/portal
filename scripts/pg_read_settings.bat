@ECHO OFF
REM Read settings in variables

REM Change codepage
chcp 1251 > NUL

REM Project path
FOR %%* in ("%~dp0..") DO SET ProjectPath=%%~f*

SET FileConfig=%ProjectPath%\project.cfg
SET BaseConfig=%ProjectPath%\config\database.yml

REM В переменную записывем с файла "env" активный режим
SET /P Env=< %ProjectPath%\env

REM С файла настроек ".env.*" считываем порт
FOR /F "delims==; tokens=1,2" %%a IN ( %ProjectPath%\.env.%Env% ) DO (
  IF /I %%a==PORT SET PORT=%%b
  IF /I %%a==COLOR SET Color=%%b
)

REM Change console color
COLOR %Color%

REM Project dir name
FOR %%* IN ( "%ProjectPath%" ) DO SET ProjectName=%%~n*

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
  && SET "PGDATABASE=%PGDATABASE%" ^
  && SET "PGHOST=%PGHOST%" ^
  && SET "PGPORT=%PGPORT%" ^
  && SET "PGUSER=%PGUSER%" ^
  && SET "PGPASSWORD=%PGPASSWORD%"

FOR /F "delims==; tokens=1,2" %%a IN ( %FileConfig% ) DO (
  IF /I %%a EQU PgServiceName SET PgServiceName=%%b

  REM Specifies the file system location of the database configuration files
  IF /I %%a EQU PGDATA SET PGDATA=%%b

  IF /I %%a EQU PgBin SET PgBin=%%b

  REM Specifies the character encoding scheme to be used in this database
  IF /I %%a EQU PgEncoding SET PgEncoding=%%b

  REM Specifies the locale to be used in this database
  IF /I %%a EQU PgLocale SET PgLocale=%%b

  IF /I %%a EQU BackupPath SET BackupPath=%%b
  IF /I %%a EQU ArhPath SET ArhPath=%%b
  IF /I %%a EQU SkipBackup SET SkipBackup=%%b
)

SET PATH=%PgBin%;%ArhPath%;%PATH%

REM Current time with leading zero
SET cTime=%TIME: =0%

REM Current dateTime yyyymmdd_hhmmss
SET CurrentDatetime=%DATE:~-4%%DATE:~3,2%%DATE:~0,2%_%cTIME:~0,2%%TIME:~3,2%%TIME:~6,2%

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

