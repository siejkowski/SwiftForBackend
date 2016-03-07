cmake_minimum_required(VERSION 3.4)
project(KituraSample)

add_custom_target(KituraSample
        COMMAND bash build.sh
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        SOURCES )