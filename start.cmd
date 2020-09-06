@echo off
docker-compose -p gitea start
if %errorlevel% == 0 (
	FOR /F %%i IN ('docker-compose -p gitea ps -q server') DO SET SERVER=%%i
	FOR /F %%i IN ('docker inspect --format="{{(index (index .NetworkSettings.Ports \"3000/tcp\") 0).HostPort}}" %SERVER%') DO SET HTTPS=%%i
	FOR /F %%i IN ('docker inspect --format="{{(index (index .NetworkSettings.Ports \"22/tcp\") 0).HostPort}}" %SERVER%') DO SET SSH=%%i
	echo.
	echo Gitea running at https://localhost:%HTTPS%
	echo Username: %USERNAME%
	echo Password: %PASSWORD%
	echo.
	echo SSH running at localhost:%SSH%
	echo Find your SSH keys in the keys directory
)