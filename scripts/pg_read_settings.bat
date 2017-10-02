REM Read settings in variables

COLOR F0

SET FileConfig=pg.cfg

FOR /F "delims==; tokens=1,2" %%a IN ( %FileConfig% ) DO (
  IF /I %%a EQU Database SET Database=%%b
  IF /I %%a EQU ProgramPath SET ProgramPath=%%b
  IF /I %%a EQU Server SET Server=%%b
  IF /I %%a EQU Port SET Port=%%b
  IF /I %%a EQU User SET User=%%b
  IF /I %%a EQU Password SET PGPASSWORD=%%b

  REM Specifies the character encoding scheme to be used in this database
  IF /I %%a EQU Encoding SET Encoding=%%b

  REM Specifies the locale to be used in this database
  IF /I %%a EQU Locale SET Locale=%%b

  IF /I %%a EQU BackupPath SET BackupPath=%%b
)

REM Specifies the file system location of the database configuration files
SET DataPath="%ProgramPath%data\"

REM Create a new PostgreSQL database
SET CreateDB="%ProgramPath%bin\createdb.exe"

REM Remove a PostgreSQL database
SET DropDB="%ProgramPath%bin\dropdb.exe"

REM Initialize, start, stop, or control a PostgreSQL server
SET PgCtl="%ProgramPath%bin\pg_ctl.exe"

REM Extract a PostgreSQL database into a script file or other archive file
SET PgDump="%ProgramPath%bin\pg_dump.exe"

REM Restore a PostgreSQL database from an archive file created by pg_dump
SET PgRestore="%ProgramPath%bin\pg_restore.exe"

REM PostgreSQL interactive terminal
SET Psql="%ProgramPath%bin\psql.exe"
