# Gitea Testrepo

Spawns a Gitea based test pepository for Git testing. Useful when running CI/CD `git` unittests and having the need of an remote test repository.
Obviously: never expose this on a public network, never use this as a production repo and never re-use the pre-configured credentials and ssh keys for anything else then your `git` unittests.

The provided setup/start/stop scripts are for Windows environments and the used Docker image expects Linux containers. If you got the time feel free to re-write the scripts as `bash` scripts for Linux environments and submit a PR.

## Usage

Simply execute `setup.cmd` the first time you want to setup the environment. Gitea will be available at `https://localhost:4433` and you can login with the pre-configured admin user `robot` and it's password `Top!S3crETPassw0rd$`.
Also there will be two test repositories pre-created: a [public repository 'a'](https://localhost:4433/robot/a) and a [private repository 'b'](https://localhost:4433/robot/b). The private repository has pre-configured SSH keys which you'll find in the `keys` folder of this project.
You can use the supplied convenient scripts `stop.cmd`, `start.cmd`, `enter.cmd`, `logs.cmd` and `delete.cmd` as needed. You can temporarily trust the SSL certificate used for localhost, `ssl.crt`, if needed.

Git's SSH will listen on port `2222`.
