@ECHO OFF

SET PathPortal=D:\ProjectRuby\portal

CD %PathPortal%

REM В переменную записывем с файла "env" активный режим
SET /P Env=< env

REM С файла настроек ".env.*" считываем порт
FOR /F "delims==; tokens=1,2" %%a IN ( .env.%Env% ) DO IF /I %%a==PORT SET Port=%%b

REM Текущее имя папки
FOR %%* in (.) DO SET CurrDirName=%%~nx*

REM Заголовок для консоли
TITLE [%CurrDirName%] -%Env%- [%Port%]

REM Запуск сервера
foreman start --env .env.%Env% --procfile Procfile.%Env%

@ECHO ON
