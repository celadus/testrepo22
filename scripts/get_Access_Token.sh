#!/bin/bash

echo Getting access token

TOKEN_URL=https://apim-ssg.camena.com:9443/auth/oauth/v2/token
POST_BODY="grant_type=client_credentials&scope=OOB"
echo $POST_BODY > /tmp/post.txt
#curl -X POST  -d@/tmp/post.txt -H "Content-Type: application/x-www-form-urlencode"  -H "Authorization: Basic OWFkZGI4MTI2ZDAzNGJjM2I0NzU3MzU2ZmJlZTk1MTI6MzZlZTUwMjdlMjRkNDcwMThhMjU2ZjllYTI5NzEyMmQ="  $TOKEN_URL --insecure
curl -d "$POST_BODY" -X POST -H "Content-Type: application/x-www-form-urlencoded" -H "Authorization: Basic OWFkZGI4MTI2ZDAzNGJjM2I0NzU3MzU2ZmJlZTk1MTI6MzZlZTUwMjdlMjRkNDcwMThhMjU2ZjllYTI5NzEyMmQ=" $TOKEN_URL --insecure

