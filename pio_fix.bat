SET SRC=C:\SysGCC\esp32-master\esp-idf\v5.4-master
SET DST=C:\Users\gojimmypi\.platformio\packages\framework-espidf

SET THIS_FILE=components\esp-tls\CMakeLists.txt
copy %SRC%\%THIS_FILE%    %DST%\%THIS_FILE%

SET THIS_FILE=components\esp-tls\Kconfig
copy %SRC%\%THIS_FILE%    %DST%\%THIS_FILE%

SET THIS_FILE=components\esp-tls\esp-tls-crypto\esp_tls_crypto.c
copy %SRC%\%THIS_FILE%    %DST%\%THIS_FILE%

SET THIS_FILE=components\esp-tls\esp_tls.c
copy %SRC%\%THIS_FILE%    %DST%\%THIS_FILE%

SET THIS_FILE=components\esp-tls\esp_tls_wolfssl.c
copy %SRC%\%THIS_FILE%    %DST%\%THIS_FILE%

SET THIS_FILE=components\esp_http_client\esp_http_client.c
copy %SRC%\%THIS_FILE%    %DST%\%THIS_FILE%

SET THIS_FILE=components\mbedtls\Kconfig
copy %SRC%\%THIS_FILE%    %DST%\%THIS_FILE%

SET THIS_FILE=components\tcp_transport\transport_ssl.c
copy %SRC%\%THIS_FILE%    %DST%\%THIS_FILE%

SET THIS_FILE=tools\cmake\build.cmake
copy %SRC%\%THIS_FILE%    %DST%\%THIS_FILE%

SET THIS_FILE=tools\cmake\component.cmake
copy %SRC%\%THIS_FILE%    %DST%\%THIS_FILE%

SET THIS_FILE=components\esp-tls\esp_tls_platform_port.c
copy %SRC%\%THIS_FILE%    %DST%\%THIS_FILE%

SET THIS_FILE=components\esp-tls\private_include\esp_tls_platform_port.h
copy %SRC%\%THIS_FILE%    %DST%\%THIS_FILE%
