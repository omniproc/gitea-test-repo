@echo off
docker-compose -p gitea down
docker-compose -p gitea rm -f -s -v
docker volume rm gitea_data-volume