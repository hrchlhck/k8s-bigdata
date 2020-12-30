#!/bin/bash

set -e

TAG=latest

function build() {
    local name=$1
    local image=vpemfh7/hadoop-$name:$TAG
    cd $([ -z "$2" ] && echo "./$name" || echo "$2")
    echo "-------------------------" building image $image in $(pwd)
    docker build -t $image . && docker push $image
    cd -
}


# Build every directory passed as parameter of the script
# E.g. ./build.sh hibench namenode
# The command above will build Dockerfiles inside ./hibench and ./namenode
for dockerfile in $@; do
    build $dockerfile
done
