Run this command inside your projects directory

```shell
docker run --rm \
    --interactive \
    --tty \
    --volume $PWD:/opt/apps/app \
    --workdir /opt/apps/app \
    henrotaym/laravel-installer:0.0.1
```
