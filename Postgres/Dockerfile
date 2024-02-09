FROM docker.io/library/postgres:latest

# Copy in entrypoint to check for required variables
COPY entrypoint.sh /usr/local/bin/

ENTRYPOINT ["entrypoint.sh"]