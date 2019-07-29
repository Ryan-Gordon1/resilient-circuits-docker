# Resilient Circuits in Docker
## Craig Roberts & Ryan Gordon

## Using resilient-community-apps submodule
The public [resilient-community-apps](https://github.com/ibmresilient/resilient-community-apps) github repo is a git submodule of this repo.
It's configured to use the master branch.
It's not cloned by default - because it's quite big. 
To clone it, run the following commands from the root of this repo: `git submodule init; git submodule update`

Once it's cloned you can get the latest code or change branches of _resilient-community-apps_ by `cd`'ing into `resilient-community-apps` and running the usual git commands.
The commands will operate against resilient-community-apps repo.  For example `git fetch`, `git pull`, `git checkout` and so on.
 
## Building the Container 

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