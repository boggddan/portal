@ECHO OFF

REM Папка запуска скрипта, переходим выше и чистим лог-файлы
CD "%~dp0.." && rails log:clear
rails log:clear

@ECHO ON

