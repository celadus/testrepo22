#!/bin/bash

if [[ $# -lt 2 ]] ; then
    echo 'you need to specify tag and container name  for importing artifact'
    echo "Usage: $0 <tag_name> <container_name>" 
    exit 1
fi
CONTAINERID=$(docker ps | grep $2 | awk -F " " '{print $1}')
APIDIR=/usr/local/tomcat/LAC_REPO/teamspaces/default/apis/

SCRIPT_ROOT=/home/centos/demo
ORGDIR=$(pwd)
cd $SCRIPT_ROOT/scripts/imports/$1
pwd
tar zxf *.tar.gz
docker cp apis $CONTAINERID:/tmp
docker exec  $CONTAINERID /usr/local/tomcat/scripts/putApis.sh
echo Killing container with id $CONTAINERID
docker kill $CONTAINERID
