#!/bin/bash

echo "Building Resilient Circuits Docker Image"

echo "The build uses your default app.config from ~/.resilient"
DEFAULT_IMAGE_NAME="resilient_circuits"
# If no arguments were provided
if [ -z "$1" ] 
# Use a default PYTHON_VIRTUAL_ENV name and create using rh-python36
then
    echo "No image name supplied, creating a image with the default name $DEFAULT_IMAGE_NAME"
    docker build --rm -f "Dockerfile" -t $DEFAULT_IMAGE_NAME:latest --build-arg TMP_APP_CONFIG="$(cat ~/.resilient/app.config)" .

# else, args were provided; pass them to the python3 command to create an env or do something else
else
    docker build --rm -f "Dockerfile" -t $1:latest --build-arg TMP_APP_CONFIG="$(cat ~/.resilient/app.config)" .

fi
