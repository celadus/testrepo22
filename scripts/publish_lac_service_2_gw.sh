#!/bin/bash
SCRIPT_ROOT=/home/centos/demo/scripts


function publish_api {
	echo "Publishing using swagger file $2"
	REQ_URL="https://portal.camena.com:$1/lacman/1.0/publish"
	AUTH_HEADER="YWRtaW46TDdTZWN1cmUkMCM="
	curl -d@$2 -X PUT -H "Content-Type: application/json" -H "Authorization: Basic $AUTH_HEADER" $REQ_URL --insecure 
}

if [[ $# -lt 2 ]]; then
	echo Usage "$0 <GATEWAY_PORT> <SWAGGER_FILE_PATH>"
	exit 1
fi
publish_api $1 $2
