@echo off
FOR /F %%i IN ('docker-compose -p gitea ps -q server') DO SET SERVER=%%i
docker exec -it %SERVER% /bin/bash