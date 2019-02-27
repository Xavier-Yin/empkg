#!/bin/bash 

IMAGE=$1
SRC=$2
DST=$3

id=$(docker create $IMAGE) && \
docker cp $id:$SRC $DST && \
docker rm -v $id
