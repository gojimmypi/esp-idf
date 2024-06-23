#!/bin/bash
#

MY_SHELLCHECK="shellcheck"

# Check if the executable is available in the PATH
if command -v "$MY_SHELLCHECK" >/dev/null 2>&1; then
    # Run your command here
    shellcheck "$0" || exit 1
else
    echo "$MY_SHELLCHECK is not installed. Please install it if changes to this script have been made."
fi

# check if IDF_PATH is set
if [ -z "$IDF_PATH" ]; then
    echo ""
    echo "Please follow the instruction of ESP-IDF installation and set IDF_PATH."
    exit 1
fi

# make sure it actually exists
if [ ! -d "$IDF_PATH" ]; then
    echo ""
    echo "ESP-IDF Development Framework doesn't exist.: $IDF_PATH"
    exit 1
fi

echo "Check components/esp-tls/Kconfig"
python -m kconfcheck /mnt/c/SysGCC/esp32-master/esp-idf/v5.4-master/components/esp-tls/Kconfig

echo ""
echo "Check components/mbedtls/Kconfig"
python -m kconfcheck /mnt/c/SysGCC/esp32-master/esp-idf/v5.4-master/components/mbedtls/Kconfig

echo ""
echo "Check esp_http_client_example/components/wolfssl/Kconfig"
python -m kconfcheck /mnt/c/workspace/wolfssl-gojimmypi/IDE/Espressif/ESP-IDF/examples/esp_http_client_example/components/wolfssl/Kconfig
