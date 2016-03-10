cmake_minimum_required(VERSION 3.4)
project(KituraSample)

add_custom_target(KituraSample
        COMMAND bash clean.sh && bash build_linux.sh
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        SOURCES )