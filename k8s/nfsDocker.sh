#!/usr/bin/env bash
docker run --restart=always -d --name nfs --privileged --net=host  \
    -v /nfs:/nfs -e SHARED_DIRECTORY=/nfs \
    itsthenetwork/nfs-server-alpine:latest
