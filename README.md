# Espressif IoT Development Framework

This is the gojimmypi experimental version for PlatformIO.

See [platform-espressif32/issues/1398](https://github.com/platformio/platform-espressif32/issues/1398#issuecomment-2198553046):

- [ ] Fork the IDF version you want to use. 
- [ ] Do your changes. 
- [ ] Add a valid `package.json` and `version.txt` in the root. 
- [ ] Create a UNIQUE tag. It MUST have `v` prefix! Ensure proper branch is selected.
- [ ] Create a release. The github function release will NOT work since it does not include the git submodules. The generated release can be used with platform_packages
- [ ] Confirm action is running at https://github.com/gojimmypi/esp-idf/actions (wait ~15 minutes to complete)
- [ ] Use newly created, 3rd asset file, listed typically at top with name `esp-idf-v[version id].zip`.

```
cd /mnt/c/SysGCC/esp32/esp-idf/v5.2-master
git fetch --tags
git checkout tags/v5.2.1 -b my_521a

cp version.txt.ref version.txt
cp package.json.ref package.json

git tag -a v5.2.1a -m "Tagging version 5.2.1a"

# This kicks off the action:
git push origin v5.2.1a

# wait ~15 minutes
# view release at https://github.com/gojimmypi/esp-idf/releases
# e.g. https://github.com/gojimmypi/esp-idf/releases/download/untagged-a785c422b95d2e1846a3/esp-idf-v5.2.1a.zip
```

Sample `platformio.ini` file:

```ini
[env:esp32dev]
platform = espressif32
board = esp32dev
framework = espidf
monitor_speed = 115200
platform_packages =
	; Successful v5.2+my02 custom release:
    framework-espidf @ https://github.com/gojimmypi/esp-idf/releases/download/v5.2.0+my02/esp-idf-v5.2.0+my02.zip

	; Failing v5.4.1k custom release needs updated toolchain, here with local VisualGDB; error: ld.exe:sections.ld:497: syntax error collect2.exe: error: ld returned 1 exit status
    ; framework-espidf @ https://github.com/gojimmypi/esp-idf/releases/download/v5.4.1k/esp-idf-v5.4.1k.zip
    ; toolchain-xtensa-esp-elf @ file:///SysGCC//esp32-master//tools//xtensa-esp-elf//esp-13.2.0_20240530//xtensa-esp-elf

    ; Failing v5.2-my01 (this is what happens if `package.json` and `version.txt` files are missing)
	; framework-espidf @ https://github.com/gojimmypi/esp-idf/releases/download/v5.2-my01/esp-idf-v5.2-my01.zip

	; framework-espidf @ https://dl.espressif.com/github_assets/espressif/esp-idf/releases/download/v5.2.2/esp-idf-v5.2.2.zip
	; toolchain-xtensa-esp-elf @ https://github.com/espressif/crosstool-NG/releases/download/esp-13.2.0_20240530/xtensa-esp-elf-13.2.0_20240530-x86_64-w64-mingw32.zip
    ; toolchain-xtensa-esp-elf @ https://github.com/espressif/crosstool-NG/releases/download/esp-13.2.0_20240530/xtensa-esp-elf-13.2.0_20240530-x86_64-linux-gnu.tar.gz
lib_deps = wolfssl/wolfssl@^5.7.0-rev.3d
```

See https://github.com/gojimmypi/esp-idf/releases and https://github.com/gojimmypi/github-actions/tree/master/release_zips

Example can be seen here https://github.com/Jason2866/esp-idf and working PlatformIO releases https://github.com/Jason2866/esp-idf/releases

Important! [Espressif Releases](https://github.com/espressif/esp-idf/releases) CANNOT be used directly!


* [中文版](./README_CN.md)

ESP-IDF is the development framework for Espressif SoCs supported on Windows, Linux and macOS.

# ESP-IDF Release Support Schedule

![Support Schedule](https://dl.espressif.com/dl/esp-idf/support-periods.svg?v=1)

- Please read [the support policy](SUPPORT_POLICY.md) and [the documentation](https://docs.espressif.com/projects/esp-idf/en/latest/esp32/versions.html) for more information about ESP-IDF versions.
- Please see the [End-of-Life Advisories](https://www.espressif.com/en/support/documents/advisories?keys=&field_type_of_advisory_tid%5B%5D=817) for information about ESP-IDF releases with discontinued support.

# ESP-IDF Release and SoC Compatibility

The following table shows ESP-IDF support of Espressif SoCs where ![alt text][preview] and ![alt text][supported] denote preview status and support, respectively. The preview support is usually limited in time and intended for beta versions of chips. Please use an ESP-IDF release where the desired SoC is already supported.

|Chip         |         v4.3           |          v4.4          |          v5.0          |         v5.1           |         v5.2           |                                                            |
|:----------- | :---------------------:| :---------------------:| :---------------------:| :--------------------: | :--------------------: | :----------------------------------------------------------|
|ESP32        | ![alt text][supported] | ![alt text][supported] | ![alt text][supported] | ![alt text][supported] | ![alt text][supported] |                                                            |
|ESP32-S2     | ![alt text][supported] | ![alt text][supported] | ![alt text][supported] | ![alt text][supported] | ![alt text][supported] |                                                            |
|ESP32-C3     | ![alt text][supported] | ![alt text][supported] | ![alt text][supported] | ![alt text][supported] | ![alt text][supported] |                                                            |
|ESP32-S3     |                        | ![alt text][supported] | ![alt text][supported] | ![alt text][supported] | ![alt text][supported] | [Announcement](https://www.espressif.com/en/news/ESP32_S3) |
|ESP32-C2     |                        |                        | ![alt text][supported] | ![alt text][supported] | ![alt text][supported] | [Announcement](https://www.espressif.com/en/news/ESP32-C2) |
|ESP32-C6     |                        |                        |                        | ![alt text][supported] | ![alt text][supported] | [Announcement](https://www.espressif.com/en/news/ESP32_C6) |
|ESP32-H2     |                        |                        |                        | ![alt text][supported] | ![alt text][supported] | [Announcement](https://www.espressif.com/en/news/ESP32_H2) |
|ESP32-P4     |                        |                        |                        |                        | ![alt text][preview]   | [Announcement](https://www.espressif.com/en/news/ESP32-P4) |

[supported]: https://img.shields.io/badge/-supported-green "supported"
[preview]: https://img.shields.io/badge/-preview-orange "preview"

There are variants of revisions for a series of chips. See [Compatibility Between ESP-IDF Releases and Revisions of Espressif SoCs](https://github.com/espressif/esp-idf/blob/master/COMPATIBILITY.md) for the details of the compatibility between ESP-IDF and chip revisions.

Espressif SoCs released before 2016 (ESP8266 and ESP8285) are supported by [RTOS SDK](https://github.com/espressif/ESP8266_RTOS_SDK) instead.

# Developing With ESP-IDF

## Setting Up ESP-IDF

See https://idf.espressif.com/ for links to detailed instructions on how to set up the ESP-IDF depending on chip you use.

**Note:** Each SoC series and each ESP-IDF release has its own documentation. Please see Section [Versions](https://docs.espressif.com/projects/esp-idf/en/latest/esp32/versions.html) on how to find documentation and how to checkout specific release of ESP-IDF.

### Non-GitHub forks

ESP-IDF uses relative locations as its submodules URLs ([.gitmodules](.gitmodules)). So they link to GitHub. If ESP-IDF is forked to a Git repository which is not on GitHub, you will need to run the script [tools/set-submodules-to-github.sh](tools/set-submodules-to-github.sh) after git clone.

The script sets absolute URLs for all submodules, allowing `git submodule update --init --recursive` to complete. If cloning ESP-IDF from GitHub, this step is not needed.

## Finding a Project

As well as the [esp-idf-template](https://github.com/espressif/esp-idf-template) project mentioned in Getting Started, ESP-IDF comes with some example projects in the [examples](examples) directory.

Once you've found the project you want to work with, change to its directory and you can configure and build it.

To start your own project based on an example, copy the example project directory outside of the ESP-IDF directory.

# Quick Reference

See the Getting Started guide links above for a detailed setup guide. This is a quick reference for common commands when working with ESP-IDF projects:

## Setup Build Environment

(See the Getting Started guide listed above for a full list of required steps with more details.)

* Install host build dependencies mentioned in the Getting Started guide.
* Run the install script to set up the build environment. The options include `install.bat` or `install.ps1` for Windows, and `install.sh` or `install.fish` for Unix shells.
* Run the export script on Windows (`export.bat`) or source it on Unix (`source export.sh`) in every shell environment before using ESP-IDF.

## Configuring the Project

* `idf.py set-target <chip_name>` sets the target of the project to `<chip_name>`. Run `idf.py set-target` without any arguments to see a list of supported targets.
* `idf.py menuconfig` opens a text-based configuration menu where you can configure the project.

## Compiling the Project

`idf.py build`

... will compile app, bootloader and generate a partition table based on the config.

## Flashing the Project

When the build finishes, it will print a command line to use esptool.py to flash the chip. However you can also do this automatically by running:

`idf.py -p PORT flash`

Replace PORT with the name of your serial port (like `COM3` on Windows, `/dev/ttyUSB0` on Linux, or `/dev/cu.usbserial-X` on MacOS. If the `-p` option is left out, `idf.py flash` will try to flash the first available serial port.

This will flash the entire project (app, bootloader and partition table) to a new chip. The settings for serial port flashing can be configured with `idf.py menuconfig`.

You don't need to run `idf.py build` before running `idf.py flash`, `idf.py flash` will automatically rebuild anything which needs it.

## Viewing Serial Output

The `idf.py monitor` target uses the [esp-idf-monitor tool](https://github.com/espressif/esp-idf-monitor) to display serial output from Espressif SoCs. esp-idf-monitor also has a range of features to decode crash output and interact with the device. [Check the documentation page for details](https://docs.espressif.com/projects/esp-idf/en/latest/get-started/idf-monitor.html).

Exit the monitor by typing Ctrl-].

To build, flash and monitor output in one pass, you can run:

`idf.py flash monitor`

## Compiling & Flashing Only the App

After the initial flash, you may just want to build and flash just your app, not the bootloader and partition table:

* `idf.py app` - build just the app.
* `idf.py app-flash` - flash just the app.

`idf.py app-flash` will automatically rebuild the app if any source files have changed.

(In normal development there's no downside to reflashing the bootloader and partition table each time, if they haven't changed.)

## Erasing Flash

The `idf.py flash` target does not erase the entire flash contents. However it is sometimes useful to set the device back to a totally erased state, particularly when making partition table changes or OTA app updates. To erase the entire flash, run `idf.py erase-flash`.

This can be combined with other targets, ie `idf.py -p PORT erase-flash flash` will erase everything and then re-flash the new app, bootloader and partition table.

# Resources

* Documentation for the latest version: https://docs.espressif.com/projects/esp-idf/. This documentation is built from the [docs directory](docs) of this repository.

* [Beginner's Guide to Key Concepts and Resources of ESP-IDF](https://youtu.be/J8zc8mMNKtc?feature=shared)

* The [esp32.com forum](https://esp32.com/) is a place to ask questions and find community resources.

* [Check the Issues section on github](https://github.com/espressif/esp-idf/issues) if you find a bug or have a feature request. Please check existing Issues before opening a new one.

* If you're interested in contributing to ESP-IDF, please check the [Contributions Guide](https://docs.espressif.com/projects/esp-idf/en/latest/contribute/index.html).
