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


function create-api {
	REQ_URL=" https://apim-ssg.camena.com:9443/api-management/1.0/apis"
	sleep 2
	#curl -s -d@$1 -X POST -H "Content-Type: application/json" -H "Authorization: Bearer $2" $REQ_URL --insecure -o result.txt
	curl  -s -X POST --header "Authorization:Bearer $1"  --header "Content-Type:application/json" -d@./temp.txt https://apim-ssg.camena.com:9443/portal/api-management/1.0/apis --insecure -o result.txt
	
	API_UUID=""
	API_UUID=$(cat result.txt | awk -F "uuid" '{print $2}' | awk -F "\"" '{print $3}')


	sleep 2

	curl "https://apim-ssg.camena.com:9443/portal/api-management/1.0/apis/$API_UUID/policy-entities?"   -X 'PUT'   -H 'Connection: keep-alive'   -H 'Accept: */*'   -H "Authorization: Bearer $1"   -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.105 Safari/537.36'   -H 'Content-Type: application/json'  -H 'Accept-Language: en-US,en;q=0.9,tr;q=0.8'   -d@$SCRIPT_ROOT/resources/api-policies.txt   --compressed   --insecure
}


function publish-api {
	REQ_URL=" https://apim-ssg.camena.com:9443/portal/api-management/1.0/apis/$2/publish"

	curl $REQ_URL   -X 'PUT'   -H 'Connection: keep-alive'   -H 'Accept: */*'   -H "Authorization: Bearer $1"   -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.105 Safari/537.36'   -H 'Content-Type: application/json'  -H 'Accept-Language: en-US,en;q=0.9,tr;q=0.8'   -d@./temp.txt   --compressed   --insecure

}
function cleanup {
	rm -rf ./temp.txt
	rm -rf ./result*.txt
}

if [[ $# -ne 3 ]]; then
	echo Usage "$0  <API-NAME> <SSG-RESOLUTION-URL> <BACKEND-URL>"
	exit 1
fi
CURRDIR=$(pwd)
cd $SCRIPT_ROOT
get_access_token
#echo $ACCESS_TOKEN

UUID=$(cat /proc/sys/kernel/random/uuid)
cp $SCRIPT_ROOT/resources/create_api_template.txt ./temp.txt 
sed -i ~s~REPLACE_LOCATION_URL~$3~ ./temp.txt
sed -i ~s~REPLACE_API_NAME~$1~ ./temp.txt
sed -i ~s~REPLACE_SSG_URL~$2~ ./temp.txt
#cat ./temp.txt
create-api $ACCESS_TOKEN
publish-api $ACCESS_TOKEN $API_UUID
if [[ $API_UUID == "" ]]; then
	cat result.txt
	cat result2.txt
else
	echo Generated API UUID : $API_UUID
fi
cleanup
cd $CURRDIR
