#!/bin/bash
source ./container-setup.sh

usage () {
    echo "Usage: $script_name -c <config-filename>"
    exit 1
}

while getopts ":c:n:" flag
do
    case "${flag}" in
        c) config_filename=${OPTARG}
           ;;
        n) container_name_extra=${OPTARG}
           ;;
        *)
            usage
    esac
done

docker run -d -v $config_dir:$docker_project/config \
    -v $log_dir:$docker_project/logs \
    -v $data_dir:$docker_project/data \
    --name $container_name $image_name \
    /bin/bash -c "bundle exec run.rb --config config/$config_filename"
