# Base image using Red Hat's universal base image (rhel 7) for python
FROM registry.access.redhat.com/ubi7/python-36

# Update to latest packages, user 0 for root privilege
USER 0
RUN yum -y update && yum clean all

# Update to latest pip
RUN pip install --upgrade pip

# Install circuits
RUN  pip install resilient-circuits>=34.0.195


# Set up configuration and log locations using /etc and /var/log, the conventional locations for config and logs
RUN mkdir /etc/circuits
ENV APP_CONFIG_FILE /etc/circuits/app.config

# create directory for logs and set to be root group to allow access by non root processes
# See https://docs.openshift.com/container-platform/4.2/openshift_images/create-images.html#images-create-guide-openshift_create-images
RUN mkdir /var/log/circuits && \
    chgrp -R 0 /var/log/circuits && \
    chmod -R g=u /var/log/circuits
ENV APP_LOG_DIR /var/log/circuits

# Entrypoint for circuits.  Use /opt, the conventional location for optional software on Linux
RUN mkdir /opt/circuits
COPY /assets/entrypoint.sh /opt/circuits/entrypoint.sh

# arbitrary user, support running as non-root.  Required on OpenShift.
# Generally a good practice.
USER 1001
ENTRYPOINT [ "sh", "/opt/circuits/entrypoint.sh" ]