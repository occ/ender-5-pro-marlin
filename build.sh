#!/usr/bin/env bash

ARDUINO_IDE_VERSION="1.8.12"
MARLIN_VERSION="2.0.5.3"

# Setup Arduino
wget https://downloads.arduino.cc/arduino-${ARDUINO_IDE_VERSION}-linux64.tar.xz -O /tmp/arduino.tar.xz
tar xf /tmp/arduino.tar.xz -C $HOME/arduino/ --strip-components=1
export PATH="$HOME/arduino:$PATH"

# Setup Marlin
wget https://github.com/MarlinFirmware/Marlin/archive/${MARLIN_VERSION}.zip
unzip ${MARLIN_VERSION}.zip
mv Marlin-${MARLIN_VERSION} Marlin

# Copy customizations
cp configuration/* Marlin/Marlin/

arduino --pref "boardsmanager.additional.urls=https://raw.githubusercontent.com/Lauszus/Sanguino/master/package_lauszus_sanguino_index.json,https://adafruit.github.io/arduino-board-index/package_adafruit_index.json,http://arduino.esp8266.com/stable/package_esp8266com_index.json,https://dl.espressif.com/dl/package_esp32_index.json" --save-prefs
arduino --pref "compiler.warning_flags.more=-Wall -Wno-expansion-to-defined" --save-prefs
arduino --pref "compiler.warning_flags.all=-Wall -Wextra -Wno-expansion-to-defined" --save-prefs

arduino --install-boards Sanguino:avr
arduino --install-library "U8glib"
arduino --verify --board Sanguino:avr:sanguino:cpu=atmega1284p Marlin/Marlin/Marlin.ino
