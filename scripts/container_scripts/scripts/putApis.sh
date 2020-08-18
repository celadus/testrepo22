#!/bin/bash
APIDIR=/usr/local/tomcat/LAC_REPO/teamspaces/default/apis
ORGDIR=$(pwd)
cd $APIDIR
cd ..
mv apis apis.$(date +%s)
mv /tmp/apis .
cd $ORGDIR
