#!/bin/bash

. /prj/osem/docker-compose.env
docker build -t osem-script --build-arg PASS=$MYSQL_PASSWORD .
#docker run osem-script
