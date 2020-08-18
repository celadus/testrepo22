#!/bin/bash
SCRIPT_ROOT=/home/centos/demo/scripts
if [[ $# -lt 2 ]] ; then
    echo 'you need to specify apiname and container-name for exporting swagger'
    echo "Usage: $0 <api-name> <container-name>"
    exit 1
fi
PORT=$(docker service ls | grep $2 | awk -F "->" '{print $1}' | awk -F "*:" '{print $2}')
CONTAINERID=$(docker ps | grep $2 | awk -F " " '{print $1}')
docker cp $CONTAINERID:/usr/local/tomcat/LAC_REPO/teamspaces/default/apis/evoby/security/authtokens  .
#echo $PORT
AUTHTOKEN=$(cat authtokens/*.json | grep "authToken" | awk -F ":" '{print $2}' | awk -F "\"" '{print $2}')
rm -rf authtokens
wget http://portal.camena.com:$PORT/CALiveAPICreator/rest/default/$1/v1/@docs?auth=$AUTHTOKEN:1 -O $SCRIPT_ROOT/swaggers/swagger-$1.json > /dev/null 2>&1
ls  $SCRIPT_ROOT/swaggers/swagger-$1.json 
