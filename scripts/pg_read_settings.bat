REM Read settings in variables

SET FileConfig=%~dp0..\pg.cfg

REM Change codepage
chcp 1251 > NUL

FOR /F "delims==; tokens=1,2" %%a IN ( %FileConfig% ) DO (
  IF /I %%a EQU PgServiceName SET PgServiceName=%%b
  IF /I %%a EQU PGDATABASE SET PGDATABASE=%%b
  IF /I %%a EQU PGHOST SET PGHOST=%%b
  IF /I %%a EQU PGPORT SET PGPORT=%%b
  IF /I %%a EQU PGUSER SET PGUSER=%%b
  IF /I %%a EQU PGPASSWORD SET PGPASSWORD=%%b

  REM Specifies the file system location of the database configuration files
  IF /I %%a EQU PGDATA SET PGDATA=%%b

  IF /I %%a EQU PgBin SET PgBin=%%b

  REM Specifies the character encoding scheme to be used in this database
  IF /I %%a EQU Encoding SET Encoding=%%b

  REM Specifies the locale to be used in this database
  IF /I %%a EQU Locale SET Locale=%%b

  IF /I %%a EQU BackupPath SET BackupPath=%%b
  IF /I %%a EQU ArhPath SET ArhPath=%%b
  IF /I %%a EQU SkipBackup SET SkipBackup=%%b

  IF /I %%a EQU Color SET Color=%%b
)

REM Change console color
COLOR %Color%

SET PATH=%PgBin%;%ArhPath%;%PATH%

REM Current time with leading zero
SET cTime=%TIME: =0%

REM Current dateTime yyyymmdd_hhmmss
SET CurrentDatetime=%DATE:~-4%%DATE:~3,2%%DATE:~0,2%_%cTIME:~0,2%%TIME:~3,2%%TIME:~6,2%

REM Project path
FOR %%* in ("%~dp0..") DO SET ProjectPath=%%~f*

REM Project dir name
FOR %%* IN ( "%ProjectPath%" ) DO SET ProjectName=%%~n*
