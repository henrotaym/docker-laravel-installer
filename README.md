Run this command inside your projects directory

```shell
docker run --rm \
    --interactive \
    --tty \
    --volume $PWD:/opt/apps/app \
    --workdir /opt/apps/app \
    --user $(id -u):$(id -g) \
    henrotaym/laravel-installer:0.0.1
```
