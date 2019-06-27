#!/bin/bash

echo "Building Resilient Circuits Docker Image"

echo "The build uses your default app.config from ~/.resilient"

docker build --rm -f "Dockerfile" -t resilient_circuits:latest --build-arg TMP_APP_CONFIG="$(cat ~/.resilient/app.config)" .
