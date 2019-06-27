# Building on top of 3.6 image as resilient circuits is just a python app
FROM python:3.6-alpine

# Label the maintainers / authors
LABEL authors="craig.roberts@uk.ibm.com,ryan.gordon1@ibm.com,simon.bradish@ibm.com"

# Create the app.config during build for customize command
ARG TMP_APP_CONFIG
RUN echo "$TMP_APP_CONFIG" > /tmp/app.config

# Install bash 
RUN apk update && apk add bash

# Create the app directory
WORKDIR /app

# Copy files needed by install.sh
COPY integration_list.txt /tmp
COPY /assets/integrations /tmp/integrations
COPY /assets/requirements.txt /tmp
COPY /assets/install.sh /tmp
COPY /assets/entrypoint.sh /tmp

# Set environment variables for circuits and logging 
ENV APP_CONFIG_FILE /app/app.config
ENV APP_LOG_DIR /app

# Install the main app content
RUN bash /tmp/install.sh && apk del .build-deps

# Setup the entrypoint for container start
ENTRYPOINT [ "sh", "/tmp/entrypoint.sh" ]