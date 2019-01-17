#!/bin/bash

export MYSQL_PASSWD=`grep MYSQL_PASSWORD /prj/osem/docker-compose.env | cut -d= -f2`
export MYSQL_SRV=`docker exec osem-database ip a | grep inet | grep 172 | awk '{print $2}' | cut -d/ -f1`
docker build -t osem-script --build-arg MYSQL_PASSWD --build-arg MYSQL_SRV .
docker run --net host osem-script 
