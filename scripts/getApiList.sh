#!/bin/bash

if [[ $# -lt 1 ]] ; then
    echo 'you need to specify  container-name for exporting artifact'
    echo "Usage: $0 <container-name>"
    exit 1
fi
CONTAINERID=$(docker ps | grep $1 | awk -F " " '{print $1}')
APIDIR=/usr/local/tomcat/LAC_REPO/teamspaces/default/apis/
DATE=$(date +%s)
mkdir -p $(pwd)/exports/$DATE
docker cp $CONTAINERID:$APIDIR $(pwd)/exports/$DATE
ORGDIR=$(pwd)
cd $(pwd)/exports/$DATE
LS_OUTPUT=$(ls -A1 apis)
cd $ORGDIR
LS_OUTPUT=$(echo $LS_OUTPUT| sed 's/ /,/g')
rm -rf $(pwd)/exports/$DATE
echo APILIST=$LS_OUTPUT
