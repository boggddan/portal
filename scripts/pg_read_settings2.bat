REM Read settings in variables

SET FileConfig=pg_88.cfg

REM Смена кодировки
chcp 1251 > NUL

FOR /F "delims==; tokens=1,2" %%a IN ( %FileConfig% ) DO (
  IF /I %%a EQU Database SET Database=%%b
  IF /I %%a EQU ProgramPath SET ProgramPath=%%b
  IF /I %%a EQU Server SET Server=%%b
  IF /I %%a EQU Port SET Port=%%b
  IF /I %%a EQU User SET User=%%b
  IF /I %%a EQU Password SET PGPASSWORD=%%b

)

REM Change console color
COLOR %Color%

REM Specifies the file system location of the database configuration files
SET DataPath="%ProgramPath%data\"


REM Extract a PostgreSQL database into a script file or other archive file
SET PgDump="%ProgramPath%bin\pg_dump.exe"

REM Restore a PostgreSQL database from an archive file created by pg_dump
SET PgRestore="%ProgramPath%bin\pg_restore.exe"
