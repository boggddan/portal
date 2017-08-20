@ECHO OFF

SET PathToBackup=C:\Arhiv_portal\
SET Util="C:\Program Files\7-Zip\7z.exe"

REM Чистим файлы и перемещаемся в каталог выше
CALL clean.bat 1

@ECHO OFF

REM Формат времени с лидирующим нулем
SET cTime=%TIME: =0%

REM Текущее имя папки
FOR %%* in (.) DO SET CurrDirName=%%~nx*

REM Текущее имя папки
SET FileBackup=%PathToBackup%%CurrDirName%_%DATE:~-4%%DATE:~3,2%%DATE:~0,2%_%cTIME:~0,2%%TIME:~3,2%%TIME:~6,2%.zip

%Util% a -x!.git\* %FileBackup% * -r

ECHO[
ECHO Backup was create! [%FileBackup%]

PAUSE

@ECHO ON
