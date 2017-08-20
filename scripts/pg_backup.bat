@ECHO OFF
SET cTime=%TIME: =0%

SET PathUtil="C:\Program Files (x86)\pgAdmin 4\v1\runtime\"
SET Datebase=portal_edu
SET Server=localhost
SET Port=5432
SET User=postgres
SET FileBackup=C:\Arhiv_portal\%Datebase%_%DATE:~-4%%DATE:~3,2%%DATE:~0,2%_%cTIME:~0,2%%TIME:~3,2%%TIME:~6,2%.sql
SET PGPASSWORD=6k3vddrb2v

%PathUtil%pg_dump -v -c -h %Server% -p %Port% -U %User% -d %Datebase% -f %FileBackup%

EXIT
