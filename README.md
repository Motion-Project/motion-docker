# motion-docker

This container is built automatically whenever code is pushed to master at https://github.com/Motion-Project/motion .

## Caveats
- If you use /dev/video, locally attached cameras or the database features of Motion, this container won't work for you at this stage.  
- This is built directly from git master, if you want something more stable grab a prebuilt release from [here](https://github.com/Motion-Project/motion/releases) and install manually.

## How to run

something like this;

```
docker run -d --name=motion \
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
## How to Update

```
docker stop motion
docker rm motion
docker pull motionproject/motion:latest
- rerun above run command
```


## Things you may need to change
- name = a label for the container, should be motion or motion-project (but can be anything)
- ports = each -p line denotes 1 camera and its stream port
- TZ = the timezone the container will be running
- volumes = /dockerserver/path/to/config
          = /dockerserver/path/to/storage
          
## Release Notes
- 30/11/18 Bumped to Ubuntu 18.04
- 30/11/18 Cosmetic changes and added x264 package
- 29/11/18 Initial build of Docker container 
- 29/10/18 Motion 4.2 released
