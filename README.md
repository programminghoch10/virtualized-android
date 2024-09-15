# virtualized-android

## Usage

1. Use `./run.sh` to build and start the container with all required flags.

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
