cmake_minimum_required(VERSION 3.20)
project(AsciiArtApp LANGUAGES CXX Swift)

set(CMAKE_CXX_STANDARD 20)            # C++20+
set(CMAKE_Swift_LANGUAGE_VERSION 5.9) # Swift 5.9+

add_subdirectory(source/core)

if(APPLE)
    enable_language(Swift)
    add_executable(AsciiArtApp
        source/main/macos_main.swift
        source/gui/macos/App.swift
        source/gui/macos/ContentView.swift
        # ... может другие .swift файлы 
    )
    target_link_libraries(AsciiArtApp PRIVATE ascii_core)
else()
    add_executable(AsciiArtApp
        source/main/linux_main.cpp
        source/gui/linux/main.cpp
        # ... может другие .cpp/.hpp файлы
    )
    target_link_libraries(AsciiArtApp PRIVATE ascii_core imgui stb)
endif()
