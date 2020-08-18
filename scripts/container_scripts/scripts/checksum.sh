#!/bin/bash
APIDIR=/usr/local/tomcat/LAC_REPO/teamspaces/default/apis
CHECKSUM=$(find $APIDIR -type f -exec md5sum {} \; | sort -k 2 | md5sum | awk -F " " '{print $1}')
echo $CHECKSUM
