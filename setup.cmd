@echo off
REM Creating a Newline variable (the two blank lines are required!)
echo.
docker-compose -p gitea up -d
FOR /F %%i IN ('docker-compose -p gitea ps -q server') DO set SERVER=%%i
echo Initializing gitea database, please wait...
timeout /T 10 /nobreak
REM Create the initial user 'robot' with password 'Top!S3crETPassw0rd$'. This user's base64 encoded basic auth credentials will be used for the following REST API commands.
SET USERNAME=robot
SET PASSWORD=Top!S3crETPassw0rd$
docker exec --user git -it %SERVER% gitea admin create-user --username %USERNAME% --password %PASSWORD% --email noreply@mail.domain --admin --must-change-password=false
REM Create a private repository named "a".
docker exec -it %SERVER% curl -k -s -X POST "https://localhost:3000/api/v1/user/repos" -H  "accept: application/json" -H  "authorization: Basic cm9ib3Q6VG9wIVMzY3JFVFBhc3N3MHJkJA==" -H  "Content-Type: application/json" -d "{  \"auto_init\": true,  \"name\": \"a\",  \"private\": false}"
REM Create a private repository named "b".
docker exec -it %SERVER% curl -k -s -X POST "https://localhost:3000/api/v1/user/repos" -H  "accept: application/json" -H  "authorization: Basic cm9ib3Q6VG9wIVMzY3JFVFBhc3N3MHJkJA==" -H  "Content-Type: application/json" -d "{  \"auto_init\": true,  \"name\": \"b\",  \"private\": true}"
REM Add a RO key without a passphrase
docker exec -it %SERVER% curl -k -s -X POST "https://localhost:3000/api/v1/repos/robot/b/keys" -H  "accept: application/json" -H  "authorization: Basic cm9ib3Q6VG9wIVMzY3JFVFBhc3N3MHJkJA==" -H  "Content-Type: application/json" -d "{  \"key\": \"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCuH5Q5BDDX1jg1h7dFa94jXUMkRel+CxsPyaf00NMTjhlCrHXlhqQ2kjKJxtxVU79DlJFJley28PYxp/xnX/gPM3C8ZNAZ6okIOuq0OMmpUvWYfNc0Ydi5gtt/4vNNEQLOdaO0e657d5O9tDkN3/TSM+oEg9SD1zDKYatgIh3h5UqyPs8qT85beddtA4F0Z0EgarO6ayNZGDECuutRBsy/rC5Tq11phBFyGFchLNvwY7ThCoy/lc+snFWwrljENojfTxXJLJ/fbk5tSH/4FBPkzNvhJN3Hzw7DW36KMYdimkh0Y6MQPggHF6FJYwB7feo/gNK6Aqt1QjOh4mt9d0nJ\",  \"read_only\": true,  \"title\": \"ro\"}"
REM Add a RW key without a passphrase
docker exec -it %SERVER% curl -k -s -X POST "https://localhost:3000/api/v1/repos/robot/b/keys" -H  "accept: application/json" -H  "authorization: Basic cm9ib3Q6VG9wIVMzY3JFVFBhc3N3MHJkJA==" -H  "Content-Type: application/json" -d "{  \"key\": \"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDr3t3XsV30kRGycxNZ1HlX2tr5qAdy1lU2v/ZDQ36Mlqo1tOWYWXBsa4KAles5J0mJh/27uC4ee5DQpbkBYJjuinnEIgp0xXtl6St5sRQABIEfcJt/qdTH3ur/Sa4UuPISm8yPWzp7kd/UAJW58zx4AejJyhqtlfTGXqS6SVTvBkV5DEdr9g+lv1Yv3HgKg6moSccMom5gl+Qu8FZW3lueUw1FgCc0BHEIUr6sNP4FBuXBcIr+30gZdi6Bld2/IY3rwYk0JJ+HGS5odAQkPlB3WD5iJ2qpuKxochinCLq8sVQpYBzspYcbWeWE6laVe8uapAPsayZ2wxOmBrBN9cdz\",  \"read_only\": false,  \"title\": \"rw\"}"
REM Add a RW key with a passphrase. The passphrase used is 'S3crET'.
docker exec -it %SERVER% curl -k -s -X POST "https://localhost:3000/api/v1/repos/robot/b/keys" -H  "accept: application/json" -H  "authorization: Basic cm9ib3Q6VG9wIVMzY3JFVFBhc3N3MHJkJA==" -H  "Content-Type: application/json" -d "{  \"key\": \"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDmfE+ie3FNEHFoont/84uK7c8BBH6bjhrL9a+4i7NOW74UD9EweZcKPohkWnbUFLlrAjvDMOlmlx5b3gE9Hmn+85Tk6AHT3WlbeHbobGrfl3901RxBwV+yFtLlEkqKhBmb260EjYk7Y/dKqENJWxbzv3JYdOBSaNHT1cL+PXTskgYSNuaZt/tNqveA5Yz3bfvyxuJUFyqFbigrOt1PyM1l25H6W9rqIT2jPtoLBQ7cTmW/+G46lP4hoH6pdAhxdAVW67XPDUY5n8NQQbzG0qLc8Ndwj4gAuwb0eOqh/92XCU/67mgX1rc3OottrCpFS5zJRZcPrMpIVWB+NVWe+UoN\",  \"read_only\": false,  \"title\": \"pt\"}"

FOR /F %%i IN ('docker inspect --format="{{(index (index .NetworkSettings.Ports \"3000/tcp\") 0).HostPort}}" %SERVER%') DO SET HTTPS=%%i
FOR /F %%i IN ('docker inspect --format="{{(index (index .NetworkSettings.Ports \"22/tcp\") 0).HostPort}}" %SERVER%') DO SET SSH=%%i
echo.
echo Gitea running at https://localhost:%HTTPS%
echo Username: %USERNAME%
echo Password: %PASSWORD%
echo.
echo SSH running at localhost:%SSH%
echo Find your SSH keys in the keys directory
