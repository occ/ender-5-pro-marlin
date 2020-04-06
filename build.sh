#!/usr/bin/env bash

MARLIN_VERSION="2.0.5.3"

wget https://github.com/MarlinFirmware/Marlin/archive/${MARLIN_VERSION}.zip
unzip ${MARLIN_VERSION}.zip
mv Marlin-${MARLIN_VERSION} Marlin

arduino --pref "boardsmanager.additional.urls=https://raw.githubusercontent.com/Lauszus/Sanguino/master/package_lauszus_sanguino_index.json,https://adafruit.github.io/arduino-board-index/package_adafruit_index.json,http://arduino.esp8266.com/stable/package_esp8266com_index.json,https://dl.espressif.com/dl/package_esp32_index.json" --save-prefs
arduino --install-boards Sanguino:avr
arduino --verify --board Sanguino:avr:sanguino:cpu=atmega1284p Marlin/Marlin/Marlin.ino
