#!/bin/bash
#
# ARGUMENTS: $1: Instance number to connect to

if [ -n "$1" ]; then
    port="8${1}86"
else
    port="8186"
fi
    
# Generate the repo name as used by docker compose
repo_name=$(basename $( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd ) | sed -e 's|_||g' | tr '[:upper:]' '[:lower:]')

# Use the image built by docker_compose
container_name="${repo_name}_influxdb1"

docker run --rm -ti $container_name /opt/influxdb/influx -host 172.17.42.1 -port $port -username 'root' -password 'secret' -database 'testdb'

