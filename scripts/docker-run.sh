#!/bin/bash
source ./container-setup.sh

docker run -d -v $config_dir:$docker_project/config \
    -v $log_dir:$docker_project/logs \
    -v $data_dir:$docker_project/data \
    --name $container_name $image_name \
    /bin/bash -c "ruby run.rb --config config/$config_filename"
