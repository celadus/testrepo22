#!/bin/bash
SCRIPT_ROOT=/home/centos/demo/scripts


function get_access_token {
	#echo Getting access token
	TOKEN_URL=https://apim-ssg.camena.com:9443/auth/oauth/v2/token
	POST_BODY="grant_type=client_credentials&scope=OOB"
	echo $POST_BODY > /tmp/post.txt
	curl -s -d "$POST_BODY" -X POST -H "Content-Type: application/x-www-form-urlencoded" -H "Authorization: Basic OWFkZGI4MTI2ZDAzNGJjM2I0NzU3MzU2ZmJlZTk1MTI6MzZlZTUwMjdlMjRkNDcwMThhMjU2ZjllYTI5NzEyMmQ=" $TOKEN_URL --insecure -o access_token.txt
	ACCESS_TOKEN=$(cat access_token.txt  | grep "access_token" | cut -d: -f2 | cut -d'"' -f2)
	rm access_token.txt
}


function create_proxy {
	REQ_URL=" https://apim-ssg.camena.com:9443/portal/deployments/1.0/proxies"
	echo "creating api proxy using file $1"
	cat $1
	sleep 2
	curl -s -d@$1 -X POST -H "Content-Type: application/json" -H "Authorization: Bearer $2" $REQ_URL --insecure -o result.txt
	ENROLLMENT_URL=$(cat result.txt | awk -F "\"enrollmentUrl\":" '{print $2}' | cut -d'"' -f2)
	rm result.txt
}

if [[ $# -lt 1 ]]; then
	echo Usage "$0  <API_PROXY_NAME>"
	exit 1
fi
get_access_token
echo $ACCESS_TOKEN

UUID=$(cat /proc/sys/kernel/random/uuid)
cp $SCRIPT_ROOT/resources/create_api_proxy_template.txt ./temp.txt 
sed -i ~s~REPLACE_NAME~$1~ ./temp.txt
sed -i ~s~REPLACE_UUID~$UUID~ ./temp.txt

create_proxy ./temp.txt $ACCESS_TOKEN
echo ENROLLMENT_URL=$ENROLLMENT_URL
rm temp.txt
