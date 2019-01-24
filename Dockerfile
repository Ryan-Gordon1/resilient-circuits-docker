# Building on top of 3.6 image as resilient circuits is just a python app
FROM python:3.6-alpine
#FROM registry.access.redhat.com/rhel7/rhel:7.4

# Label the maintainer / author
LABEL maintainer="ryan.gordon1@ibm.com"

# Explicity install resilient -- this can be removed in favour of requirements.txt to enable users to select specific versions
#RUN pip install resilient resilient-circuits

# Add compiler support
RUN apk add --no-cache --virtual .build-deps build-base gcc abuild binutils libffi libffi-dev openssl openssl-dev bash git \
  && apk add --no-cache su-exec 

# Install Resilient Circuits
COPY requirements.txt /  
RUN pip install -r requirements.txt 

# Install integrations and remove build time deps
COPY install_integrations_public_git.sh /
RUN bash install_integrations_public_git.sh  && apk del .build-deps

# Expose 80 also in some cases
EXPOSE 443
EXPOSE 9443
EXPOSE 65000

# Optionally could try using volumes
#VOLUME ["/root/.resilient/"]

# Start resilient-circuits
CMD ["resilient-circuits", "run"]
