cmake_minimum_required(VERSION 3.4)
project(Backend)

add_custom_target(Backend
        COMMAND bash build_linux.sh
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        SOURCES )