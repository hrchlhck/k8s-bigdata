#!/bin/bash

set -e

TAG=latest

### FUNCTIONS ###
# Build a docker image
function docker_build() {
    local name=$1
    local prefix=$2
    local image=vpemfh7/$prefix-$name:$TAG
    cd $([ -z "$3" ] && echo "$prefix/$name" || echo "$3")
    echo "-------------------------" building image $image in $(pwd)
    docker build --rm -t $image . 
    cd -
}


function docker_push() {
	local name=$1
	local prefix=$2
	docker push vpemfh7/$prefix-$name:$TAG
}

function build_all() {
	local flag=$1
	local base_dir=$2
	local prefix=$base_dir

	if [[ $flag == "-S" ]]; then
		echo "Building subdirectories"
		for dir in $(ls $base_dir); do
			docker_build $dir $prefix
		done
	else
		docker_build $1
	fi
}

function push_all() {
	local user=$1
	local repo_prefix=$2
	for image in $(ls $repo_prefix); do
		docker push $user/$repo_prefix-$image
	done
}

# Build every directory passed as parameter of the script
# E.g. ./build.sh hibench namenode
# The command above will build Dockerfiles inside ./hibench and ./namenode

build_all "-S" "hadoop" 
build_all "" "hibench"
build_all "-S" "spark"  
push_all "vpemfh7" "hadoop"
for dockerimage in $@; do
    docker_push $dockerimage
done
