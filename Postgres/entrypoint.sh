#!/bin/bash

REQUIRED_VARIABLES="POSTGRES_USER POSTGRES_PASSWORD POSTGRES_DB"

echo $POSTGRES_USER

for var in $REQUIRED_VARIABLES; do
    if [ -z "${!var}" ]; then
        echo "ERROR: ${var} is unset."
        exit 1
    fi
done;

exec /usr/local/bin/docker-entrypoint.sh postgres