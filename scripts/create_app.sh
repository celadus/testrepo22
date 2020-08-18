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



function create-app {
	cd $SCRIPT_ROOT
	UUID1=$(cat /proc/sys/kernel/random/uuid)
	UUID2=$(cat /proc/sys/kernel/random/uuid)
	UUID3=$(cat /proc/sys/kernel/random/uuid)
	UUID4=$(cat /proc/sys/kernel/random/uuid)
	cp resources/create-app-template.txt ./temp.txt
	sed -i ~s~REPLACE_UUID1~$UUID1~ ./temp.txt
	sed -i ~s~REPLACE_UUID2~$UUID2~ ./temp.txt
	sed -i ~s~REPLACE_UUID3~$UUID3~ ./temp.txt
	sed -i ~s~REPLACE_UUID4~$UUID4~ ./temp.txt
	sed -i ~s~REPLACE_APPNAME~$2~ ./temp.txt
	sed -i ~s~REPLACE_APIID~$3~ ./temp.txt
	sed -i ~s~REPLACE_OAUTH_SCOPE~$4~ ./temp.txt
	#cat ./temp.txt
	REQ_URL="https://apim-ssg.camena.com:9443/portal/Applications"
	curl $REQ_URL   -X 'POST'   -H 'Connection: keep-alive'   -H 'Accept: */*'   -H "Authorization: Bearer $1"   -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.105 Safari/537.36'   -H 'Content-Type: application/json'  -H 'Accept-Language: en-US,en;q=0.9,tr;q=0.8'   -d@./temp.txt   --compressed   --insecure
	cd -

}
if [[ $# -ne 3 ]]; then
	echo Usage "$0  <APP_NAME>  <API_UUID> <OAUTH_SCOPE>"
	exit 1
fi
get_access_token
create-app $ACCESS_TOKEN $1 $2 $3
