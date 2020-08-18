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


function publish-to-proxy {
	cd $SCRIPT_ROOT
	if [[ $3 == "STAGING" ]]; then
		cp resources/publish-template-gw1.txt ./temp.txt
		PROXY_UUID=6bed3b10-2ea5-46dd-8975-89e924b0d59a
	elif [[ $3 == "PROD" ]]; then
		cp resources/publish-template-gw2.txt ./temp.txt
		PROXY_UUID=ee407ac3-c4bb-4751-af86-5ef5f72d08ff
	else 
		echo unknown proxy $3
		exit 1
	fi
	REQ_URL="https://apim-ssg.camena.com:9443/portal/deployments/1.0/apis/$2/proxies"
	curl $REQ_URL   -X 'POST'   -H 'Connection: keep-alive'   -H 'Accept: */*'   -H "Authorization: Bearer $1"   -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.105 Safari/537.36'   -H 'Content-Type: application/json'  -H 'Accept-Language: en-US,en;q=0.9,tr;q=0.8'   -d@./temp.txt   --compressed   --insecure
	cd -

}

if [[ $# -ne 2 ]]; then
	echo Usage "$0  <API_UUID> <STAGING|PROD>"
	exit 1
fi
get_access_token
publish-to-proxy $ACCESS_TOKEN $1 $2
