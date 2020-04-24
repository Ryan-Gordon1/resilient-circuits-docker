# Resilient Circuits in Docker
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
![IBM Security](./assets/IBM_Security_lockup_pos_RGB.png)


- [Resilient Circuits in Docker](#resilient-circuits-in-docker)
  - [Overview](#overview)
  - [Whats in this repository](#whats-in-this-repository)
  - [Using resilient-community-apps submodule](#using-resilient-community-apps-submodule)
- [Building images and running containers](#building-images-and-running-containers)
  - [Building images and running containers - Red Hat UBI](#building-images-and-running-containers---red-hat-ubi)
    - [Building the images](#building-the-images)
    - [Running the container](#running-the-container)
  - [Building images and running containers - Alpine and Python](#building-images-and-running-containers---alpine-and-python)
    - [Building the Images](#building-the-images-1)
    - [Configuring the container host](#configuring-the-container-host)
    - [Running the container](#running-the-container-1)
  - [Note on entrypoints](#note-on-entrypoints)

## Overview
This repository is a community submission detailing how you can use Docker to containerize an integration for Resilient Circuits. 
Integrations used with resilient_circuits are Python packages which are typically installed before use and Circuits itself is also a Python package. 
Through this repo you can instead pre-prepare a number of Docker images which can then be repeatedly deployed with both the integration code and an instance of resilient_circuits.

One benefit to this approach is how dependencies for each integration are isolated within that specific image reducing the chances of dependency conflict when using more than 1 integration.

Configuration options such as credentials are handled in the same way as expected; through an app.config file with the difference being that this file is mounted to each docker container as a volume. [More on Docker Volumes](https://docs.docker.com/storage/volumes/)


## Whats in this repository 

There are a number of ways you can use docker and resilient_circuits. In this repo we cover: 

+ Creating a minimal image of resilient_circuits with alpine or python base images
+ Creating a resilient_circuits image based on the Redhat Universal Base Image format. 
  - A Dockerfile file is provided for both UBI 7 and 8
+ Creating an image based on one of the above bases which contains a given integration or app.


## Using resilient-community-apps submodule
Included with this repo is a submodule link to the resilient-community-apps repo giving you access to existing integrations which can be wrapped as Docker containers.

The public [resilient-community-apps](https://github.com/ibmresilient/resilient-community-apps) github repo is a git submodule of this repo.
It's configured to use the master branch.
It's not cloned by default - because it's quite big. 
To clone it, run the following commands from the root of this repo: `git submodule init; git submodule update`

Once it's cloned you can get the latest code or change branches of _resilient-community-apps_ by `cd`'ing into `resilient-community-apps` and running the usual git commands.
The commands will operate against resilient-community-apps repo.  For example `git fetch`, `git pull`, `git checkout` and so on.

# Building images and running containers
Provided in this README is two methods for build images. 

The first involves a more standards-orientated setup, using Red Hat UBI as the base image for a resilient_circuits image.
The resilient_circuits image; tagged `circuits-ubi7` in this project is then further built upon for each specific integration. 
This means all integration images use `circuits-ubi7` which in turn uses `registry.access.redhat.com/ubi7/python-36` as its base image.

Link: [Building images and running containers - Red Hat UBI](#building-images-and-running-containers---red-hat-ubi)

The second method provides a more basic all-in approach, where `python:3.7-alpine` is used as the base image.
In this case, a script `install.sh` is used to install needed packages and also both resilient_circuits and any specified integrations from `resilient-community-apps`
Before finishing some build dependencies are removed to try and keep the image size lean.

Through this second method the default behavior is you will end up with 1 docker image containing all your specified integrations and gives you a very portable integration server.

Link: [Building images and running containers - Alpine and Python](#building-images-and-running-containers---alpine-and-python)



## Building images and running containers - Red Hat UBI 
### Building the images 

A circuits base image is built using either alpine or Red Hat's Universal Base Image (ubi) base.

This contains the required OS and python packages and circuits as well as some default locations for `app.config`
The Dockerfiles for these are in the `<os-base>-base-image` directories.

To build a circuits base image called `circuits-ubi7:34` (circuits from RHEL UBI7 with circuits 34) run:
```
docker build -t circuits-ubi7:34 -f ubi7-base-image/Dockerfile .
```

To build an image with a given integration installed either use the Dockerfiles in `integration-images` directory or
create a new Dockerfile.  For example: 

```
docker build -t circuits-fn-whois -f integration-images/Dockerfile-fn-whois .
```

Contributions of Dockerfiles for new images are welcome.

### Running the container
Create a valid app.config in the `circuits` directory and run your integration container, for example
```
docker run --rm -d -v $PWD/circuits:/etc/circuits --name circuits-fn-whois circuits-fn-whois
```
To watch its logs use `docker logs -f circuits-fn-whois`.  To kill it `docker kill circuits-fn-whois`.

## Building images and running containers - Alpine and Python
 
### Building the Images 

Clone this repository to a server or system you want to run it on. 

>`git clone <url>`

>`cd ./resilient_circuits_docker`

Now we need to configure it for our integrations, in the integration_list.txt use the integration name from the [Github Repository](https://github.com/ibmresilient/resilient-community-apps), each integration should be on a separate line. 

>_Note_ If you are using your own custom repository then you can change it in the build.sh at the top of the file.

Run the build script.

>`./build.sh`

This build script installs all specified integrations through the public Resilient-community-apps repo. Additionally it attempts to install all integration packages left in the `assets/integrations` directory giving a way to setup the docker image offline.

This will build the container image - this should be visible after building through `docker images` it will look like the following. 

```
~$ docker images
REPOSITORY           TAG                 IMAGE ID
resilient_circuits   latest              40c3443d5cd1    
```

This means you have packaged it ready for production - you can move this to another server or push it into an enterprise docker registry etc. 

In this case we are starting simple so we are going to launch it on the host. 

### Configuring the container host 

You need to make sure you have an app config somewhere on the server - this must have the bare minimum configuration of below. On startup of the container it will run resilient-circuits config -u to check you have all the app configs loaded too. 

```
[resilient]
host=resilient.example.com
port=443
email=email@example.com
org=Example
password=secret
```

### Running the container 

>`docker run --rm -v /some/path/.resilient:/etc/circuits resilient_circuits`

You will see Resilient Circuits Start. 

## Note on entrypoints

Provided are two entrypoint scripts which are referenced in the Dockerfiles as a part of the image building process. 

`assets/simple-entrypoint.sh` contains just the command to start resilient-circuits
`assets/entrypoint.sh` contains a command to start resilient-circuits and watches the app.config file for changes. 
Before starting, the hash of the app.config file is recorded with `sha256sum` and if the app.config file is removed or updated with new entries, the next check of the file will cause the circuits process to be killed. This is particularly useful in a kubernetes context as kubernetes will manage the restarting of the killed container for us bringing the app.config changes into effect.