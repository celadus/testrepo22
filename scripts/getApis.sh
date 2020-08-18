#!/bin/bash

if [[ $# -lt 2 ]] ; then
    echo 'you need to specify tag and container-name for exporting artifact'
    echo "Usage: $0 <tag_name> <container-name>"
    exit 1
fi
SCRIPT_ROOT=/home/centos/demo
CONTAINERID=$(docker ps | grep $2 | awk -F " " '{print $1}')
APIDIR=/usr/local/tomcat/LAC_REPO/teamspaces/default/apis/

mkdir -p $SCRIPT_ROOT/scripts/exports/$1
docker cp $CONTAINERID:$APIDIR $SCRIPT_ROOT/scripts/exports/$1
ORGDIR=$(pwd)
cd $SCRIPT_ROOT/scripts/exports/$1
tar czf ../api_export_$1.tar.gz .
echo EXPORTFILE=$SCRIPT_ROOT/scripts/exports/$1/api_export_$1.tar.gz
cd ..
rm -rf $1
mkdir -p $1
mv api_export_$1.tar.gz $1
cd $ORGDIR
chown -R centos $SCRIPT_ROOT/scripts/exports
