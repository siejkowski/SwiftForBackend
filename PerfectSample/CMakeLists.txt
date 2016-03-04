cmake_minimum_required(VERSION 3.4)
project(PerfectSample)
add_custom_target(PerfectSample
        COMMAND /Users/krzysztofsiejkowski/.swiftenv/shims/swift build
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        SOURCES )
