#!/bin/bash 

if [ "$#" -ne 2 ]; then
    echo "Illegal number of parameters"
    echo "Usage: build.sh DEV_NAME PKG_NAME"
    exit 1
fi

HUB_USER=bug313
REPO_NAME=empkg
DEV_NAME=$1
PKG_NAME=$2
LOCAL_IMAGE=$REPO_NAME:$DEV_NAME-$PKG_NAME
REMOTE_IMAGE=$HUB_USER/$LOCAL_IMAGE

echo "LOCAL_IMAGE  = $LOCAL_IMAGE"
echo "REMOTE_IMAGE = $REMOTE_IMAGE"

mkdir -p $DEV_NAME/$PKG_NAME/packages

docker build -t $LOCAL_IMAGE $DEV_NAME/$PKG_NAME/ && \
rm -rf /tmp/$REPO_NAME/$DEV_NAME/$PKG_NAME && \
mkdir -p /tmp/$REPO_NAME/$DEV_NAME/$PKG_NAME && \
./extract.sh $LOCAL_IMAGE /_$REPO_NAME/$PKG_NAME /tmp/$REPO_NAME/$DEV_NAME && \
mv /tmp/$REPO_NAME/$DEV_NAME/$PKG_NAME/* $DEV_NAME/$PKG_NAME/packages && \
rm -rf /tmp/$REPO_NAME/$DEV_NAME/$PKG_NAME

docker tag $LOCAL_IMAGE $REMOTE_IMAGE
#docker push $REMOTE_IMAGE