#!/bin/bash
set -e
set -x
cd "$(dirname "$0")"

IMAGENAME="virtualized-android"
CONTAINERNAME="virtualized-android"

podman container rm --force --volumes "$CONTAINERNAME"

podman build \
    -t $IMAGENAME \
    --pull=newer \
    --layers \
    --arch=$(uname -m) \
    .

podman image inspect localhost/"$IMAGENAME" -f '{{ .Size }} {{ index .RepoTags 0 }}' | numfmt --to=si

CONTAINER_ARGS=(
    --name "$CONTAINERNAME"
    #--tty
    #--interactive
    --rm
    --device /dev/kvm
    --group-add keep-groups
    --publish 5554:5554
    --publish 5555:5555
)

exec \
podman container run \
    "${CONTAINER_ARGS[@]}" \
    localhost/$IMAGENAME \
    "$@"
