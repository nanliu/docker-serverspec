# docker-serverspec

Docker container to run serverspec via Docker-in-Docker.

## Usage

Docker-ception in action:
```
$ docker pull nanliu/docker_serverspec:alpine
$ docker run -v /var/run/docker.sock:/var/run/docker.sock \
  -it nanliu/docker_serverspec:alpine /bin/sh
```

You should see all running containers in the serverspec container and all your docker images
```
# docker ps
CONTAINER ID        IMAGE                             COMMAND                  CREATED             STATUS              PORTS               NAMES
405492d2c3fa        nanliu/docker_serverspec:alpine   "docker-entrypoint.sh"   8 seconds ago       Up 7 seconds                            vibrant_wright
# docker images
...
# exit
```

Run a serverspec test:
```
$ cd docker-serverspec
$ docker run -v /var/run/docker.sock:/var/run/docker.sock \
  -v "$($pwd)":/serverspec
  -it nanliu/docker_serverspec:alpine /bin/sh "cd /serverspec && rspec snap_spec.rb"
```

Run a serverspec test with pry rescue:
```
$ cd docker-serverspec
$ docker run -v /var/run/docker.sock:/var/run/docker.sock \
  -v "$($pwd)":/serverspec
  -it nanliu/docker_serverspec:alpine /bin/sh "cd /serverspec && rescue snap_spec.rb"
```

## Writing Test

### Docker Metadata
* Change [`snap/Dockerfile`](snap/Dockerfile) to a new maintainer (your own name)
* Fix [`snap_spec.rb`](snap_spec.rb) to match this change.

### Serverspec
* Change [`snap/Dockerfile`](snap/Dockerfile) configuration file to the following path:
```
COPY snapteld.conf /etc/snapteld.conf
```
* Fix [`snap_spec.rb`](snap_spec.rb) to match this change.

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
  -v "$($pwd)":/serverspec
  -it nanliu/docker_serverspec:alpine /bin/sh "cd /serverspec && rspec mysql_spec.rb"
```
