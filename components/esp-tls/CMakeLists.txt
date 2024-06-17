set(srcs esp_tls.c esp-tls-crypto/esp_tls_crypto.c esp_tls_error_capture.c esp_tls_platform_port.c)
if(CONFIG_ESP_TLS_USING_MBEDTLS)
    list(APPEND srcs
        "esp_tls_mbedtls.c")
endif()

if(CONFIG_ESP_TLS_USING_WOLFSSL)
    list(APPEND srcs
        "esp_tls_wolfssl.c")
endif()

set(priv_req http_parser esp_timer)
if(NOT ${IDF_TARGET} STREQUAL "linux")
    list(APPEND priv_req lwip)
endif()

idf_component_register(SRCS "${srcs}"
                    INCLUDE_DIRS ${CMAKE_CURRENT_SOURCE_DIR} esp-tls-crypto
                    PRIV_INCLUDE_DIRS "private_include"
                    # mbedtls is public requirements because esp_tls.h
                    # includes mbedtls header files.
                    REQUIRES mbedtls
                    PRIV_REQUIRES ${priv_req})

# When using wolfSSL for the ESP-TLS (see emnuconfig),
# There are two options:
#   1) A specified source directory, typically a wolfssl git clone
#   2) The esp-wolfssl
if(CONFIG_ESP_TLS_USING_WOLFSSL)
    # See https://github.com/wolfSSL/wolfssl/
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DWOLFSSL_ESPIDF")
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DWOLFSSL_USER_SETTINGS")

    if (CONFIG_ESP_TLS_USING_WOLFSSL_SPECIFIED)
        get_filename_component(CUSTOM_SETTING_WOLFSSL_ROOT_PATH "${CUSTOM_SETTING_WOLFSSL_ROOT}" ABSOLUTE)
        if (EXISTS "${CUSTOM_SETTING_WOLFSSL_ROOT_PATH}/wolfcrypt/src")
            message(STATUS "ESP-TLS using wolfSSL in: ${CUSTOM_SETTING_WOLFSSL_ROOT_PATH}")
        else()
            message(STATUS "ESP-TLS specified directory does not contain wolfSSL: ${CUSTOM_SETTING_WOLFSSL_ROOT_PATH}")
        endif()
        idf_component_get_property(wolfssl wolfssl COMPONENT_LIB)
        target_link_libraries(${COMPONENT_LIB} PUBLIC ${wolfssl})
    else()
        message(STATUS "ESP-TLS wolfSSL directory not specified in menuconfig / sdkconfig. Using legacy esp-wolfssl, instead.")
        # See https://github.com/espressif/esp-idf
        message(STATUS "ESP-TLS Using esp-wolfssl")

 #      idf_component_get_property(wolfssl esp-wolfssl COMPONENT_LIB)
        idf_component_get_property(wolfssl wolfssl__wolfssl COMPONENT_LIB)
        target_link_libraries(${COMPONENT_LIB} PUBLIC ${wolfssl})
    endif()
else()
    message(STATUS "ESP-TLS is not configured to use wolfSSL.")
endif()

if(NOT ${IDF_TARGET} STREQUAL "linux")
# Increase link multiplicity to get some lwip symbols correctly resolved by the linker
# due to cyclic dependencies present in IDF for lwip/esp_netif/mbedtls
idf_component_get_property(lwip lwip COMPONENT_LIB)
set_property(TARGET ${lwip} APPEND PROPERTY LINK_INTERFACE_MULTIPLICITY 5)
else()
    # Check if LWIP in the build for linux target to adapt esp-tls compatibility layer
    idf_build_get_property(build_components BUILD_COMPONENTS)
    if(CONFIG_LWIP_ENABLE)
        target_compile_definitions(${COMPONENT_LIB} PRIVATE ESP_TLS_WITH_LWIP=1)
    endif()
endif()


if(CONFIG_ESP_TLS_USE_SECURE_ELEMENT)
    idf_component_optional_requires(PRIVATE espressif__esp-cryptoauthlib esp-cryptoauthlib)
endif()
