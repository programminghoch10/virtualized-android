#!/bin/bash
set -e
set -x
cd "$(dirname "$0")"

IMAGENAME="virtualized-android"
CONTAINERNAME="virtualized-android"

CONTAINER_ARGS=(
    --name "$CONTAINERNAME"
    --tty
    --rm
    --interactive
    --shm-size=8G
    --pids-limit -1
)

podman container rm --force --volumes "$CONTAINERNAME"

podman build \
    -t $IMAGENAME \
    --pull=newer \
    --layers \
    --arch=$(uname -m) \
    .

podman image inspect localhost/"$IMAGE_NAME" -f '{{ .Size }} {{ index .RepoTags 0 }}' | numfmt --to=si

exec \
podman container run \
    "${CONTAINER_ARGS[@]}" \
    localhost/$IMAGENAME \
    "$@"
