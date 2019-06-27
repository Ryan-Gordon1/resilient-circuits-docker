# Resilient Circuits docker install script 

# Define the github repo you want to use
GITHUB_URL="https://github.com/ibmresilient/resilient-community-apps"

#Variables
mapfile -t INTEGRATIONS < /tmp/integration_list.txt
BUILD_DIR="/tmp/resilient-community-apps"

apk add --no-cache --virtual .build-deps build-base gcc abuild binutils libffi libffi-dev openssl openssl-dev bash git

apk add --no-cache su-exec 

mkdir ~/.resilient

# Install python prereqs
pip install -r /tmp/requirements.txt

echo ">>> Integrations to be installed : ${INTEGRATIONS[@]}";

# Clone extension git
git clone -b master ${GITHUB_URL} ${BUILD_DIR};

# Install extension packages
for INTEGRATION in ${INTEGRATIONS[@]};
do  
    echo ">>> Installing ${INTEGRATION}";
    (cd "${BUILD_DIR}/${INTEGRATION}/" && python setup.py install);
done

# Install any standalone packages 
INTEGRATION_FILES=/tmp/integrations/*.zip
for f in ${INTEGRATION_FILES}
do
    echo "Installing package $f"
    pip install $f
done

# Install any standalone packages 
INTEGRATION_FILES=/tmp/integrations/*.tar.gz
for f in ${INTEGRATION_FILES}
do
    echo "Installing package $f"
    pip install $f
done

export APP_CONFIG_FILE="/tmp/app.config" 

# Run customize for each package
for INTEGRATION in ${INTEGRATIONS[@]};
do 
    INTEGRATION="${INTEGRATION//_/-}"
    echo ">>> Customizing Resilient for ${INTEGRATION}"
    resilient-circuits customize -y -l ${INTEGRATION}
done

# Remove the repo/cleanup
echo ">>> Cleaning up"
rm -rf ${BUILD_DIR}