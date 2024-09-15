#!/bin/bash
set -e
set -x

EMULATOR_ARGS=()
[ ! -c /dev/kvm ] && EMULATOR_ARGS+=(-no-accel)

move() {
    mkdir -p $(dirname "$2")
    mv "$1" "$2"
}

[ -f /root/package.zip ] && {
    unzip -q /root/package.zip -d /root/manual
    ARCH="$(uname -m)"
    [ ! -d /root/manual/"$ARCH" ] && ARCH=$(ls /root/manual | head -1)
    ANDROID_SDK_VERSION=$(grep '^AndroidVersion\.ApiLevel=' < /root/manual/"$ARCH"/source.properties | cut -d'=' -f2)
    ANDROID_SDK_VERSION_TAG=$(grep '^SystemImage\.TagId=' < /root/manual/"$ARCH"/source.properties | cut -d'=' -f2)
    move /root/manual "$ANDROID_SDK_ROOT"/system-images/android-"$ANDROID_SDK_VERSION"/"$ANDROID_SDK_VERSION_TAG"
    avdmanager --verbose create avd \
        --force \
        --name device \
        --device "$ANDROID_DEVICE" \
        --package system-images\;android-"$ANDROID_SDK_VERSION"\;"$ANDROID_SDK_VERSION_TAG"\;"$ARCH"
}

# make ports accessible outside of localhost
socat tcp4-listen:5554,fork,reuseaddr,bind=0.0.0.0 tcp4:localhost:5552 &
socat tcp4-listen:5555,fork,reuseaddr,bind=0.0.0.0 tcp4:localhost:5553 &

[ -z "$CPU_CORES" ] && CPU_CORES=$(nproc)
[ "$CPU_CORES" -gt "$(nproc)" ] && CPU_CORES=$(nproc)

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
    -cores "$CPU_CORES" \
    -memory "$MEMORY_SIZE" \
    -camera-back none \
    -camera-front none \
    -writable-system \
    -ports 5552,5553 \
    -logcat '*:i'
    "${EMULATOR_ARGS[@]}"
    # -shell \
