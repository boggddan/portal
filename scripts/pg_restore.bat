@ECHO OFF

SET PathUtil="C:\Program Files (x86)\pgAdmin 4\v1\runtime\"
SET Datebase=portal
SET Server=localhost
SET Port=5432
SET User=postgres
SET FileLog=D:\portal_restore.log
SET FileBackup=D:\portal_edu_20170817_092749.sql

%PathUtil%psql -b -h %Server% -p %Port% -U %User% -d %Datebase% -f %FileBackup% -o %FileLog%

EXIT
