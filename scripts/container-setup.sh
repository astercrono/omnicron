script_name="$0"
project_dir=$(cd .. && pwd)
docker_project="/app/omnicron"
image_name="omnicron"
container_name="omnicron"
container_name_extra=""

usage () {
    echo "Usage: $script_name -c <config-filename> [-n container-name-extra]"
    echo ""
    echo "    config-filename      : Config filename to use. (Required)"
    echo "    container-name-extra : Additional string to add to container name. (Optional)"
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

if [ -z "$config_filename" ]; then
    echo "Missing required argument: <config-filename>"
    echo ""
    usage
fi

if [ -n "$container_name_extra" ]; then
    container_name="$container_name-$container_name_extra"
fi

config_dir="$project_dir/config"
log_dir="$project_dir/logs"
data_dir="$project_dir/data"
