#!/bin/bash

#Variables
declare -a GIT_LIBS=("fn_whois" "fn_ipinfo")
BUILD_DIR="/tmp/resilient-community-apps"

echo ">>> Integrations to be installed : ${GIT_LIBS[@]}";

# Remove any previous checkout (there should not be but just in case)
if [ -d ${BUILD_DIR} ]; then
    rm -rf ${BUILD_DIR}
fi

# Clone the GIT repo 
git clone -b master https://github.com/ibmresilient/resilient-community-apps ${BUILD_DIR};

# find all packages with a setup.py file to build
for INTEGRATION in ${GIT_LIBS[@]};
do  
    echo ">>> Installing ${INTEGRATION}";
    (cd "${BUILD_DIR}/${INTEGRATION}/" && python setup.py install);
done

# Remove the repo/cleanup
echo ">>> Cleaning up"
rm -rf ${BUILD_DIR}