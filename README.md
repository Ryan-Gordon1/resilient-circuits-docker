# res-circuits-docker
A DockerFile build of resilient, resilient-circuits and steps to include other packages

## Installation and Build Notes

### Getting Started

This repo has almost everything you need to run a containerised version of a resilient-circuits instance.

To build this Dockerfile into an image run :

```bash
docker build -t resilient-circuits .
```

Which will build an image called `resilient-circuits`. We can then run a containor based on this image using :

```bash
docker run --rm -v /path/to/app/data:/app resilient-circuits
```

#### Opening ports on demand

Depending on which integrations you want to use with Resilient Circuits, you may need to open more ports to enable these integrations to work. Examples of this are integrations which use different protocols such as AMQP. To open a port: edit the Docker run command with a `--port` flag followed by which port pair you want to open. 

Example :

```bash
docker run --port 8080:80
```

This example will open port 80 on the containor (right side) and then publish it on port 8080 of the host machine (left side.)

## Extra Notes

### Adding other PyPi packages needed by your circuits integrations

Very often you will need to depend on another package such as requests, lxml or some package specific to a product.
The easiest way to have these packages built out and installed into the container is through the use of the provided `requirements.txt` file.
Any dependancies you need can be appended to this file, one per line. 

Specific versions can be specified using `package==1.0.0`.
