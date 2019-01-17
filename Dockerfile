FROM python:3.6
# Building on top of 3.6 image as resilient circuits is just a python app

# WIP; Can use either alpine of rhel as a base image 
#FROM alpine:3.6
#FROM registry.access.redhat.com/rhel7/rhel:7.4

# Label the maintainer / author
LABEL maintainer="ryan.gordon1@ibm.com"

# Explicity install resilient -- this can be removed in favour of requirements.txt to enable users to select specific versions
#RUN pip install resilient resilient-circuits

# Bring in the requirements.txt file 
COPY requirements.txt /

# Install the requirements
RUN pip install -r requirements.txt

COPY install_integrations_public_git.sh /
RUN bash install_integrations_public_git.sh
# Expose 80 also in some cases
EXPOSE 443
EXPOSE 9443
EXPOSE 65000

# Optionally could try using volumes
#VOLUME ["/root/.resilient/"]

# Start resilient-circuits
CMD ["resilient-circuits", "run"]