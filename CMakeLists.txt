#     #           "      m                   mmmm   mmmm   mmmm  mmmmmm
#  mmm#  mmmmm  mmm    mm#mm   m mm  m   m  "   "# m"  "m #    #     #"
# #" "#  # # #    #      #     #"  " "m m"      m" #  m # "mmmm"    m" 
# #   #  # # #    #      #     #      #m#     m"   #    # #   "#   m"  
# "#m##  # # #  mm#mm    "mm   #      "#    m#mmmm  #mm#  "#mmm"  m"   
#                                     m"                               
# Ascii Art Application

cmake_minimum_required(VERSION 3.20)
project(AsciiArtApp LANGUAGES CXX)

# Стандарт C++
set(CMAKE_CXX_STANDARD 20)  # Используем C++20
set(CMAKE_CXX_STANDARD_REQUIRED ON) # Обязательный стандарт
set(CMAKE_CXX_EXTENSIONS OFF)   # Без расширений компилятора для лучшей кроссплатформенности

# Подключаем общую библиотеку core на C++
add_library(ascii_core
    source/ascii_core/ascii_converter.cpp
    source/ascii_core/ascii_converter.hpp
)
target_include_directories(ascii_core PUBLIC source/ascii_core)

# Платформенные ветви
if(APPLE)
    enable_language(Swift)  # Включаем Swift для macOS
    set(CMAKE_Swift_LANGUAGE_VERSION 5.9)   # Указываем версию Swift (5.9+)
    message(STATUS "Building macOS app with SwiftUI GUI")

    # Проверяем архитектуру строго на ARM (Apple Silicon)
    if(NOT CMAKE_SYSTEM_PROCESSOR MATCHES "arm64")
        message(FATAL_ERROR "This project supports only Apple Silicon (arm64) on macOS.")
    endif()

    set(CMAKE_OSX_ARCHITECTURES arm64)

    # Определяем файлы ресурсов
    set(RESOURCE_FILES
        Resources/ascii_font.json
        Resources/icon.png
)

    add_executable(AsciiArtApp
        source/gui/macos/App.swift
        source/gui/macos/MainMenuView.swift
        source/gui/macos/ImageToASCIIView.swift
        source/gui/macos/TextToASCIIView.swift
        source/gui/macos/SharedComponents.swift
        source/gui/macos/AnimationType.swift
        source/gui/macos/ASCIIConverterBridging.h  # Заголовочный файл для Swift
        ${RESOURCE_FILES}
    )

    # Указываем, что файлы ресурсов должны быть помещены в папку Resources бандла
    set_source_files_properties(${RESOURCE_FILES} PROPERTIES
        MACOSX_PACKAGE_LOCATION Resources
)

    target_link_libraries(AsciiArtApp PRIVATE ascii_core)   
    set_target_properties(AsciiArtApp PROPERTIES
        XCODE_ATTRIBUTE_SWIFT_VERSION "5.9"  # Указываем версию Swift для Xcode
        XCODE_ATTRIBUTE_SWIFT_OBJC_BRIDGING_HEADER "source/gui/macos/ASCIIConverterBridging.h" # Путь к заголовочному файлу для Swift
        MACOSX_BUNDLE TRUE  # Указываем, что это macOS приложение
        MACOSX_BUNDLE_BUNDLE_NAME "ASCII Art Studio"  # Имя приложения
        MACOSX_BUNDLE_BUNDLE_VERSION "1.0.0"  # Версия приложения
        MACOSX_BUNDLE_ICON_FILE "icon"  # Указываем имя файла иконки (без расширения .png)
    )

elseif(UNIX)
    message(STATUS "Building Linux app with ImGui (C++) GUI")

    # Разрешаем и ARM64 и x86_64
    if(NOT (CMAKE_SYSTEM_PROCESSOR MATCHES "aarch64|arm64|x86_64|AMD64"))
        message(WARNING "Unknown architecture: ${CMAKE_SYSTEM_PROCESSOR}")
    endif()

    add_executable(AsciiArtApp
        source/gui/linux/main.cpp
    )

    target_link_libraries(AsciiArtApp PRIVATE ascii_core imgui stb pthread) 

else()
    message(FATAL_ERROR "Unsupported platform")
endif()
