@ECHO OFF

REM Read settings in variables
CALL "%~dp0\scripts\pg_read_settings.bat"

REM Script folder to current folder
CD "%ProjectPath%"

REM Заголовок для консоли
TITLE [ %ProjectName% ] -%Env%- [ %PORT% ] [ %CD% ]

REM Запуск сервера
foreman start --env .env.%Env% --procfile Procfile.%Env%

ECHO ON
