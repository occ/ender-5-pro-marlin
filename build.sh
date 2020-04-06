#!/usr/bin/env bash

set -e
set -x

ARDUINO_VERSION="1.8.12"
ARDUINO_PATH="$HOME/arduino"
MARLIN_VERSION="2.0.5.3"

# Setup Arduino
mkdir $ARDUINO_PATH
wget https://downloads.arduino.cc/arduino-${ARDUINO_VERSION}-linux64.tar.xz -O /tmp/arduino.tar.xz
tar xf /tmp/arduino.tar.xz -C $ARDUINO_PATH --strip-components=1
export PATH="$ARDUINO_PATH:$PATH"

# Setup Marlin
wget https://github.com/MarlinFirmware/Marlin/archive/${MARLIN_VERSION}.zip
unzip -q ${MARLIN_VERSION}.zip
mv Marlin-${MARLIN_VERSION} Marlin

# Copy customizations
cp configuration/* Marlin/Marlin/

# Install Sanguino board support
arduino --pref "boardsmanager.additional.urls=https://raw.githubusercontent.com/Lauszus/Sanguino/master/package_lauszus_sanguino_index.json,https://adafruit.github.io/arduino-board-index/package_adafruit_index.json,http://arduino.esp8266.com/stable/package_esp8266com_index.json,https://dl.espressif.com/dl/package_esp32_index.json" --save-prefs
arduino --install-boards Sanguino:avr

# Suppress expansion-to-defined warnings
arduino --pref "compiler.warning_flags.more=-Wall -Wno-expansion-to-defined" --save-prefs
arduino --pref "compiler.warning_flags.all=-Wall -Wextra -Wno-expansion-to-defined" --save-prefs

# Install required libraries
arduino --install-library "U8glib"

# Build marlin
arduino --verify --board Sanguino:avr:sanguino:cpu=atmega1284p Marlin/Marlin/Marlin.ino

## Debug – list artifacts
ls -al Marlin/Marlin
ls -al
find . -iname '*.hex'
