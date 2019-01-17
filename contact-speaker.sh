#!/bin/bash

export MYSQL_PASSWD=`grep MYSQL_PASSWORD /prj/osem/docker-compose.env | cut -d= -f2`
export OSEM_SMTP_USERNAME=`grep OSEM_SMTP_USERNAME /prj/osem/docker-compose.env | cut -d= -f2`
export OSEM_SMTP_PASSWORD=`grep OSEM_SMTP_PASSWORD /prj/osem/docker-compose.env | cut -d= -f2`
export MYSQL_SRV=`docker exec osem-database ip a | grep inet | grep 172 | awk '{print $2}' | cut -d/ -f1`
docker build -t osem-script --build-arg MYSQL_PASSWD --build-arg MYSQL_SRV --build-arg OSEM_SMTP_USERNAME --build-arg OSEM_SMTP_PASSWORD .
docker run --net host osem-script 
