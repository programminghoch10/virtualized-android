# virtualized-android

## Usage

1. Use `./run.sh` to build and start the container with all required flags.

### Build Arguments

Argument|Description
-|-
ANDROID_SDK_VERSION|Android SDK version integer
ANDROID_SDK_VERSION_TAG|Android SDK emulator image tag
ANDROID_DEVICE|AVD device type

Override them using 
```sh
--build-arg ANDROID_SDK_VERSION=33 \
```
on the `docker build` command.

### Run Environment Variables

Variable|Description
-|-
MEMORY_SIZE|amount of memory available to AVD, in MB, defaults to 8192
CPU_CORES|amount of cpu cores available to AVD, defaults to all

Override them using 
```sh
--env ANDROID_SDK_VERSION=33 \
```
on the `docker run` command.

### Boot custom emulator images
You can boot custom 
[SDK Addon zips](https://wiki.lineageos.org/emulator#exporting-for-use-in-android-studioavd)
by mounting them into the container.
```sh
--volume "$PWD"/sdk_addon.zip:/root/package.zip:ro
```

### Userdata Persistency
AVD userdata is saved in `/root/.android/avd/device.avd`.
Mount a volume onto it to persist userdata:
```sh
--volume virtualized-android:/root/.android/avd/device.avd
```
