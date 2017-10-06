@ECHO OFF
REM Extract a PostgreSQL database into archive file

REM Clear rails waste file
CALL "proj_clear.bat" 1

REM Папка запуска скрипта, переходим выше и чистим лог-файлы
CALL "%~dp0..\start.bat"
