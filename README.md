# motion-docker

This container is built automatically whenever code is pushed to master at https://github.com/Motion-Project/motion .

Caveats;
> If you use /dev/video or database features of Motion, this container won't work for you at this stage.  
> Bleeding edge code, if you want something more stable grab a prebuilt release from [here](https://github.com/Motion-Project/motion/releases).

Run via something like this;

```
docker run -d --name=motion-project \
    -p 7999:7999 \
    -p 8081:8081 \
    -p 8082:8082 \
    -p 8083:8083 \
    -p 8084:8084 \
    -p 8085:8085 \
    -p 8087:8087 \
    -e TZ="Australia/Brisbane" \
    -v /volume1/motion/config:/usr/local/etc/motion \
    -v /volume1/motion/storage:/var/lib/motion \
    --restart=always \
    motionproject/motion:latest
```
