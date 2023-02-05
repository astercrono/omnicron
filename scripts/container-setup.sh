script_name="$0"
project_dir=$(cd .. && pwd)
docker_project="/app/omnicron"
image_name="omnicron"
container_name="omnicron"

usage () {
    echo "Usage: $script_name -c <config-filename>"
    exit 1
}

while getopts c: flag
do
    case "${flag}" in
        c) config_filename=${OPTARG};;
    esac
done

if [ -z $config_filename ]; then
    echo "Missing required argument: <config-filename>"
    usage
fi

config_dir="$project_dir/config"
log_dir="$project_dir/logs"
data_dir="$project_dir/data"
