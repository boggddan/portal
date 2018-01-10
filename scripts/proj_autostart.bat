@ECHO OFF
REM Autostart project - Script for task schedule

REM Locks the workstation's display
rundll32 user32.dll, LockWorkStation

FOR %%* in ("%~dp0") DO SET localProjectPath=%%~f*

REM Clear rails waste file
CALL "%localProjectPath%proj_clear.bat" 1

REM Project run
CALL "%localProjectPath%..\start.bat"
