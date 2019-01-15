#!/bin/bash

export MYSQL_PASSWD=`grep MYSQL_PASSWORD /prj/osem/docker-compose.env | cut -d= -f2`
docker build -t osem-script --build-arg MYSQL_PASSWD .
docker run --network=prj_internal-osem osem-script 
