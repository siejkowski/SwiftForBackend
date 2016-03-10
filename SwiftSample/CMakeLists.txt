cmake_minimum_required(VERSION 3.4)
project(SwiftSample)

add_custom_target(SwiftSample
        COMMAND /Users/krzysztofsiejkowski/.swiftenv/shims/swift build
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        SOURCES Package.swift Source/main.swift)
