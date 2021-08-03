#!/bin/bash

docker stop apache
docker rm apache
docker run --name apache -d -p 80:80 -p 2222:22 nxsjung/ubuntu-apache:16.04