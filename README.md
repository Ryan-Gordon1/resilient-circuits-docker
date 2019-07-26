# Resilient Circuits in Docker
## Craig Roberts & Ryan Gordon

## Building images and running containers - the new way
### Building
A circuits base image is built using either alpine or Red Hat's Univeral Base Image (ubi) base.
This contains the required OS and python packages and circuits as well as some default locations for `app.config`
The Dockerfiles for these are in the `<os-base>-base-image` directories.

To build a circuits base image called `circuits-ubi7-31` (circuits from RHEL UBI7 with circuits 31) run:
```
docker build -t circuits-ubi7-31 -f ubi7-base-image/Dockerfile .
```

To build an image with a given integration installed either use the Dockerfiles in `integration-images` directory or
create a new Docerfile.  For example:  
```
docker build -t circuits-fn-whois -f integration-images/Dockerfile-fn-whois .
```

Contributions of Dockerfiles for new images are welcome.

### Running
Create a valid app.config in the `circuits` directory and run your integration container, for example
```
docker run -rm -d -v $PWD/circuits:/etc/circuits circuits-fn-whois
```

## Building the Container - the old way

Clone this repository to a server or system you want to run it on. 

>`git clone <url>`

>`cd ./resilient_circuits_docker`

Now we need to configure it for our integrations, in the integration_list.txt use the integration name from the [Github Repository](https://github.com/ibmresilient/resilient-community-apps), each integration should be on a seperate line. 

>_Note_ If you are using your own custom repository then you can change it in the build.sh at the top of the file.

Run the build script.

>`./build.sh`

This will build the container image - you will it if you run `docker images` it will look like the following. 

```
~$ docker images
REPOSITORY           TAG                 IMAGE ID
resilient_circuits   latest              40c3443d5cd1    
```

This means you have packaged it ready for production - you can move this to another server or push it into an enterprise docker registry etc. 

In this case we are starting simple so we are going to launch it on the host. 

## Configuring the container host 

You need to make sure you have an app config somewhere on the server - this must have the bare minimum configuration of below. On startup of the container it will run resilient-circuits config -u to check you have all the app configs loaded too. 

```
[resilient]
host=resilient.example.com
port=443
email=email@example.com
org=Example
password=secret
```

## Running the container 

>`docker run --rm -v /some/path/.resilient:/app resilient_circuits`

You will see Resilient Circuits Start. 