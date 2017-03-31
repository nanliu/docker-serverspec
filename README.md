# docker-serverspec

[![Build Status](https://travis-ci.org/nanliu/docker-serverspec.svg?branch=master)](https://travis-ci.org/nanliu/docker-serverspec)
[![Image Layers](https://images.microbadger.com/badges/image/nanliu/serverspec.svg)](https://microbadger.com/images/nanliu/serverspec)

Docker container to run serverspec via Docker-in-Docker.

## Usage

Docker-ception in action:
```
$ docker pull nanliu/serverspec:alpine
$ docker run -v /var/run/docker.sock:/var/run/docker.sock \
  -it nanliu/serverspec:alpine /bin/sh
```

You should see all running containers in the serverspec container and all your docker images
```
# docker ps
CONTAINER ID        IMAGE                             COMMAND                  CREATED             STATUS              PORTS               NAMES
405492d2c3fa        nanliu/serverspec:alpine   "docker-entrypoint.sh"   8 seconds ago       Up 7 seconds                            vibrant_wright
# docker images
...
# exit
```

Run a serverspec test:
```
$ git clone https://github.com/nanliu/docker-serverspec.git
$ cd docker-serverspec
$ docker run -v /var/run/docker.sock:/var/run/docker.sock \
  -v "$(pwd)":/serverspec \
  -it nanliu/serverspec:alpine /bin/sh -c "cd /serverspec && rspec snap_spec.rb"
```

Run a serverspec test with pry rescue:
```
$ cd docker-serverspec
$ docker run -v /var/run/docker.sock:/var/run/docker.sock \
  -v "$(pwd)":/serverspec \
  -it nanliu/serverspec:alpine /bin/sh -c "cd /serverspec && rescue rspec snap_spec.rb"
```

## Writing the Test

### Docker Metadata
* Change [`snap/Dockerfile`](snap/Dockerfile) to a new maintainer (your own name)
```
MAINTAINER your name <your@email.com>
```
* Update [`snap_spec.rb`](snap_spec.rb) to match this change.

### Serverspec
* Change the COPY entry in [`snap/Dockerfile`](snap/Dockerfile) to match the following:
```
COPY snapteld.conf /etc/snapteld.conf
```
* Update [`snap_spec.rb`](snap_spec.rb) to match this change.

this will cause the symlink tests to fail

* Update [`snap/init_snap`](snap/init_snap) to match this change.
```
[ -f /etc/snap/snapd.conf ] || ln -s /etc/snapteld.conf /etc/snap/snapd.conf
```

### Run containers

* Change the ['snap_spec.rb'](snap_spec.rb) to run the snap container directly instead of building it first.

hint:
```
describe docker_run('intelsdi/snap:alpine')
  #test
end
```

### Custom Test

* Create mysql_spec.rb to test the dockerfile in mysql directory.

hint:
* create mysql_spec.rb
```
$ vim mysql_spec.rb
describe docker_build('/serverspec/mysql/.')
  describe docker_run(described_image) do
    #test
  end
end
```
* Test your spec:
```
$ cd docker-serverspec
$ docker run -v /var/run/docker.sock:/var/run/docker.sock \
  -v "$(pwd)":/serverspec \
  -it nanliu/serverspec:alpine /bin/sh -c "cd /serverspec && rspec mysql_spec.rb"
```
