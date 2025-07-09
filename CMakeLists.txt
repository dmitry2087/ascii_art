cmake_minimum_required(VERSION 3.20)
project(AsciiArtApp LANGUAGES CXX Swift)

set(CMAKE_CXX_STANDARD 20)              # C++20 и выше
set(CMAKE_Swift_LANGUAGE_VERSION 5.9)   # Swift 5.9 и выше

# Архитектурные настройки
if(APPLE)
    set(CMAKE_OSX_ARCHITECTURES arm64)
    enable_language(Swift)
else()
    if(CMAKE_SYSTEM_PROCESSOR MATCHES "aarch64|arm64")
        set(CMAKE_OSX_ARCHITECTURES arm64)
    elseif(CMAKE_SYSTEM_PROCESSOR MATCHES "x86_64|AMD64")
        set(CMAKE_OSX_ARCHITECTURES x86_64)
    endif()
endif()

add_subdirectory(source/core)

if(APPLE)
    add_executable(AsciiArtApp
        source/main/macos_main.swift
        source/gui/macos/App.swift
        source/gui/macos/MainMenuView.swift
        source/gui/macos/ImageToASCIIView.swift
        source/gui/macos/TextToASCIIView.swift
        source/gui/macos/SharedComponents.swift
        source/gui/macos/AnimationType.swift
    )
    
    target_link_libraries(AsciiArtApp PRIVATE ascii_core)
    
    set(ICON_FILE ${CMAKE_CURRENT_SOURCE_DIR}/Resources/icon.png)
    set_target_properties(AsciiArtApp PROPERTIES
        RESOURCE "${ICON_FILE}"
        MACOSX_BUNDLE TRUE
    )
else()
    add_executable(AsciiArtApp
        source/main/linux_main.cpp
        source/gui/linux/main.cpp
    )
    
    target_link_libraries(AsciiArtApp PRIVATE ascii_core imgui stb pthread)

    set(ICON_FILE ${CMAKE_CURRENT_SOURCE_DIR}/Resources/icon.png)
    set_target_properties(AsciiArtApp PROPERTIES
        RESOURCE "${ICON_FILE}"
        LINUX_BUNDLE TRUE
endif()
