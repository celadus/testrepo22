#!/bin/bash

echo You are running this script as $(whoami)
if [[ $# -lt 1 ]] ; then
    echo 'you need to specify container-name for generating checksum'
    echo "Usage: $0 <container-name>"
    exit 1
fi

CONTAINERID=$(docker ps | grep $1 | awk -F " " '{print $1}')
#echo Generating checksum for container $CONTAINERID
CHECKSUM=$(docker exec -it $CONTAINERID /usr/local/tomcat/scripts/checksum.sh)
echo CHECKSUM=$CHECKSUM
