# virtualized-android

## Usage

1. Use `./run.sh` to build and start the container with all required flags.

### Userdata Persistency
AVD userdata is saved in `/root/.android/avd/device.avd`.
Mount a volume onto it to persist userdata:
```sh
--volume virtualized-android:/root/.android/avd/device.avd
```
