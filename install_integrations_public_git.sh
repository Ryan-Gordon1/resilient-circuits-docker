#!/bin/bash


# collect all the public facing community apps and package as source distributions (tar.gz files)
function buildCommApps () {
    local comm_apps=$1
    shift
    local repo_branch=$1
    shift
    RC_APPS="${TMP_DIR}/resilient-community-apps"
    #
    if [ -d ${RC_APPS} ]; then
    rm -Rf ${RC_APPS}
    fi
    #
    echo ">>> Integrations to be installed : $@";
    git clone -b master https://github.com/ibmresilient/resilient-community-apps ${RC_APPS};
    # find all packages with a setup.py file to build

    for integration in $@;
    do
    echo $integration
    
    #full_path="${RC_APPS}/${integration}/"
    #pkg_dir=$(dirname "$full_path")
    #echo ">>> $pkg_dir";
    #(cd "${RC_APPS}/${integration}/" && python setup.py develop);
    done
}
#Variables
declare -a GIT_LIBS=("fn_whois" "fn_ipinfo")
RESILIENT_COMM_APPS='git@github.ibm.com:Resilient/resilient-community-apps.git'
REPO_BRANCH=master
TMP_DIR='/tmp'


# add community apps
buildCommApps ${RESILIENT_COMM_APPS} ${REPO_BRANCH} "${GIT_LIBS[@]}"