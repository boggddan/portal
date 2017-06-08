@ECHO OFF
REM SET Env=production
SET Env=development

TITLE RELEASE -%Env%- [8084]

@ECHO ON
CD C:\portal_production\ && foreman start --env %Env%.env --procfile Procfile.%Env%
