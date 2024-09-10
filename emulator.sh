#!/bin/bash

EMULATOR_ARGS=()
[ ! -c /dev/kvm ] && EMULATOR_ARGS+=(-no-accel)

# make ports accessible outside of localhost
socat tcp4-listen:5554,fork,reuseaddr,bind=0.0.0.0 tcp4:localhost:5552 &
socat tcp4-listen:5555,fork,reuseaddr,bind=0.0.0.0 tcp4:localhost:5553 &

exec \
emulator \
    @device \
    -verbose \
    -no-metrics \
    -gpu off \
    -no-window \
    -no-snapshot \
    -no-audio \
    -no-skin \
    -no-boot-anim \
    -no-jni \
    -cores $(nproc) \
    -memory "$MEMORY_SIZE" \
    -camera-back none \
    -camera-front none \
    -writable-system \
    -ports 5552,5553 \
    -logcat '*:i'
    "${EMULATOR_ARGS[@]}"
    # -shell \
