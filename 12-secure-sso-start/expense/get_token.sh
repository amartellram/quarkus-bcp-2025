#!/bin/env bash

if [ $# -lt 2 ]; then
  echo 1>&2 "Usage: . $0 username password"
  echo 1>&2 "  available users (username/password):"
  echo 1>&2 "    user/redhat"
  echo 1>&2 "    superuser/redhat"
  exit 1
fi

SERVER="http://localhost:8888/realms/quarkus/protocol/openid-connect/token"
SECRET_ID="backend-service"
SECRET_PW="secret"
USERNAME="user"
PASSWORD="redhat"

RESPONSE=$(curl --insecure -s -X POST "$SERVER" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "client_id=${SECRET_ID}" \
  -d "client_secret=${SECRET_PW}" \
  -d "username=${USERNAME}" \
  -d "password=${PASSWORD}" \
  -d 'grant_type=password')

echo "Respuesta completa de Keycloak:"
echo "$RESPONSE"

export TOKEN=$(echo "$RESPONSE" | jq --raw-output '.access_token')


if [[ "$TOKEN" == "null" ]] || [[ "$TOKEN" == ""  ]]; then
    echo 1>&2 "Token was not retrieved! Review input parameters."
else
    echo 1>&2 "Token succesfuly retrieved."
fi
