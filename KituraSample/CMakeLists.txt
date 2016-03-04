cmake_minimum_required(VERSION 3.4)
project(KituraSample)

add_custom_target(KituraSample
        COMMAND /Users/krzysztofsiejkowski/.swiftenv/shims/swift build
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        SOURCES Package.swift Sources/Router.swift)