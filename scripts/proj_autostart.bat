@ECHO OFF
REM Autostart project - Script for task schedule

REM Clear rails waste file
CALL "%~dp0proj_clear.bat" 1

REM Project run
CALL "%~dp0..\start.bat"
