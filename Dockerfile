FROM debian
MAINTAINER programminghoch10

# Tell debconf to run in non-interactive mode
ARG DEBIAN_FRONTEND=noninteractive

# install required packages
RUN apt-get update \
    && apt-get full-upgrade --autoremove -y \
    && apt-get install -y --no-install-recommends \
        bash nano \
        wget unzip \
        default-jre-headless \
        xvfb \
        socat \
    && rm -rf /var/lib/apt/lists/*

# set android environment variables
ENV ANDROID_SDK_ROOT=/opt/android-sdk

# install sdkmanager
RUN mkdir -p "$ANDROID_SDK_ROOT"/cmdline-tools \
    && wget --quiet -O commandlinetools.zip https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip \
    && unzip -q commandlinetools.zip -d "$ANDROID_SDK_ROOT"/cmdline-tools \
    && mv "$ANDROID_SDK_ROOT"/cmdline-tools/cmdline-tools "$ANDROID_SDK_ROOT"/cmdline-tools/latest \
    && rm commandlinetools.zip
ENV PATH="$PATH":"$ANDROID_SDK_ROOT"/cmdline-tools/latest/bin

# accept sdkmanager licenses
RUN yes | sdkmanager --licenses

# install platform tools
RUN sdkmanager --no_https platform-tools
ENV PATH="$PATH":"$ANDROID_SDK_ROOT"/platform-tools

# install emulator
RUN sdkmanager --no_https emulator
ENV PATH="$PATH":"$ANDROID_SDK_ROOT"/emulator

# install system image and android platform
ARG ANDROID_SDK_VERSION=34
ARG ANDROID_SDK_VERSION_TAG=default
RUN sdkmanager --no_https \
    system-images\;android-"$ANDROID_SDK_VERSION"\;"$ANDROID_SDK_VERSION_TAG"\;$(uname -m) \
    platforms\;android-"$ANDROID_SDK_VERSION"

# setup avd
ARG ANDROID_DEVICE=medium_phone
RUN avdmanager --verbose create avd \
    --force \
    --name device \
    --device "$ANDROID_DEVICE" \
    --package system-images\;android-"$ANDROID_SDK_VERSION"\;"$ANDROID_SDK_VERSION_TAG"\;$(uname -m)
VOLUME /root/.android/avd/device.avd

# prepare environment variables
ENV \
    ANDROID_SDK_VERSION="$ANDROID_SDK_VERSION" \
    ANDROID_SDK_VERSION_TAG="$ANDROID_SDK_VERSION_TAG" \
    ANDROID_DEVICE="$ANDROID_DEVICE" \
    MEMORY_SIZE=8192 \
    CPU_CORES=""

# prepare launch script
COPY emulator.sh .
EXPOSE 5554 5555
STOPSIGNAL SIGINT
CMD ["bash", "emulator.sh"]
