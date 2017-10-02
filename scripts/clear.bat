@ECHO OFF

CD ..

IF EXIST log RMDIR log /s /q
IF EXIST public\assets RMDIR public\assets /s /q
IF EXIST public\pack RMDIR public\pack /s /q
IF EXIST tmp RMDIR tmp /s /q

ECHO Delete file was complete!

REM Наличие параметров для запуска с других батиков, что бы
REM не останавливало программу
IF [%1] EQU [] (
  PAUSE
  ECHO ON
)
