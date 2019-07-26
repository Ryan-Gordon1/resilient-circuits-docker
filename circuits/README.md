This directory holds the files used to configure circuits.
To use it directly:
* create a circuits configuration file called app.config and set your configuraiton values
* If your resilient server has a non trusted certificate (e.g. self signed) then get it's certificate
 and place it in a file called `resilient-host-cacerts.pem` as described in the
 [docs](https://developer.ibm.com/security/resilient/certificates/)
* mount it as a volume into the container at runtime `docker run -v <absolute path to this directory>:/etc/circuits ...`