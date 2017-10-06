@ECHO OFF
REM Clear rails log - Script for task schedule

REM Папка запуска скрипта, переходим выше и чистим лог-файлы
CD "%~dp0.." && rails log:clear

ECHO ON

