@ECHO OFF
REM Remove old backup files

REM Read settings in variables
CALL "%~dp0\pg_read_settings.bat"

SET Title=Remove old backup project [ %ProjectName% ], DB [ %PGDATABASE% ] files from [ %BackupPath% ]
TITLE %Title%

SET Skip=2

IF %SkipBackup% GEQ 1 SET SkipCommand=skip=%SkipBackup%

ECHO.
ECHO ***
ECHO %Title%
ECHO.

SETLOCAL ENABLEDELAYEDEXPANSION

FOR %%# IN ( %ProjectName% %PGDATABASE% ) DO (
  IF /I [%%#] EQU [%ProjectName%] ( SET ExtFile=_*.zip ) ELSE ( SET ExtFile=_*.dump )

  REM ECHO !ExtFile!
  SET LogFile=%BackupPath%%%#_remove.log
  SET FileRemove=%BackupPath%%%#!ExtFile!

  ECHO. >> !LogFile!
  ECHO.%DATE% %cTIME:~0,2%:%TIME:~3,2%:%TIME:~6,2% >> !LogFile!

  FOR /F "usebackq %SkipCommand%" %%* IN (`DIR !FileRemove! /B /O:-D /A:-D 2^>NUL`) DO (
    ECHO %%~n*
    DEL %BackupPath%%%*
  ) >> !LogFile!

  ECHO Remove old project [ %%# ] files. Watch result in file [ !LogFile! ] complete!
)

ENDLOCAL

ECHO.

REM Pause when manual start
IF [%1] EQU [] PAUSE

ECHO ON
