#     #           "      m                   mmmm   mmmm   mmmm  mmmmmm
#  mmm#  mmmmm  mmm    mm#mm   m mm  m   m  "   "# m"  "m #    #     #"
# #" "#  # # #    #      #     #"  " "m m"      m" #  m # "mmmm"    m" 
# #   #  # # #    #      #     #      #m#     m"   #    # #   "#   m"  
# "#m##  # # #  mm#mm    "mm   #      "#    m#mmmm  #mm#  "#mmm"  m"   
#                                     m"                               
# ASCII ART Studio

cmake_minimum_required(VERSION 3.20)
project(AsciiArtStudio LANGUAGES CXX)

# Стандарт C++
set(CMAKE_CXX_STANDARD 20)  # Используем C++20
set(CMAKE_CXX_STANDARD_REQUIRED ON) # Обязательный стандарт
set(CMAKE_CXX_EXTENSIONS OFF)   # Без расширений компилятора для лучшей кроссплатформенности

# Пути
set(SOURCE ${CMAKE_SOURCE_DIR}/source)
set(EXTERNAL ${CMAKE_SOURCE_DIR}/external)
set(RESOURCES ${CMAKE_SOURCE_DIR}/Resources)
set(JSON ${EXTERNAL}/json)
set(STB ${EXTERNAL}/stb)
set(IMGUI ${EXTERNAL}/imgui)
set(MAC_GUI ${SOURCE}/gui/macos)
set(LINUX_GUI ${SOURCE}/gui/linux)
set(ASCII_CORE ${SOURCE}/ascii_core)

# Подключаем общую библиотеку core на C++
add_library(CORE
    ${ASCII_CORE}/ascii_converter.cpp
    ${ASCII_CORE}/ascii_converter.hpp
)

# Указываем, что библиотека ascii_core (оно же ядро проекта) зависит от внешних библиотек
target_include_directories(CORE 
    PUBLIC ${ASCII_CORE}
    PRIVATE ${JSON} ${STB}      # json.hpp и stb_image.h
)

# Определяем файлы ресурсов
set(RESOURCE_FILES
    ${RESOURCES}/ascii_font.json
    ${RESOURCES}/icon.png
)

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

    add_executable(${PROJECT_NAME}
        ${MAC_GUI}/App.swift
        ${MAC_GUI}/AppSettings.swift
        ${MAC_GUI}/MainMenuView.swift
        ${MAC_GUI}/ImageToASCIIView.swift
        ${MAC_GUI}/TextToASCIIView.swift
        ${MAC_GUI}/SharedComponents.swift
        ${MAC_GUI}/SettingsView.swift
        ${MAC_GUI}/MenuScreenView.swift
        ${MAC_GUI}/AnimationType.swift
        ${MAC_GUI}/AlertManager.swift
        ${MAC_GUI}/AppMode.swift
        ${MAC_GUI}/AnimationViewModel.swift
        ${MAC_GUI}/BackgroundAnimationView.swift
        ${MAC_GUI}/Extensions.swift
        ${MAC_GUI}/ImageToASCIIViewModel.swift
        ${MAC_GUI}/TextToASCIIViewModel.swift
        ${RESOURCE_FILES}
    )

    # Указываем, что файлы ресурсов должны быть помещены в папку Resources бандла
    set_source_files_properties(${RESOURCE_FILES} PROPERTIES
        MACOSX_PACKAGE_LOCATION Resources
    )

    target_link_libraries(${PROJECT_NAME} PRIVATE CORE)   
    set_target_properties(${PROJECT_NAME} PROPERTIES
        XCODE_ATTRIBUTE_SWIFT_VERSION "5.9"  # Указываем версию Swift для Xcode
        XCODE_ATTRIBUTE_SWIFT_OBJC_BRIDGING_HEADER "source/gui/macos/ASCIIConverterBridging.h" # Путь к заголовочному файлу для Swift
        MACOSX_BUNDLE TRUE  # Указываем, что это macOS приложение
        MACOSX_BUNDLE_BUNDLE_NAME "ASCII Art Studio"  # Имя приложения
        MACOSX_BUNDLE_BUNDLE_VERSION "1.0.0"  # Версия приложения
        MACOSX_BUNDLE_INFO_STRING "ASCII ART Studio for macOS"  # Описание приложения
        MACOSX_BUNDLE_COPYRIGHT "Copyright © 2025 dmitry2087"  # Авторские права
        MACOSX_BUNDLE_ICON_FILE "icon"  # Указываем имя файла иконки (без расширения .png)
    )

elseif(UNIX)
    message(STATUS "Building Linux app with ImGui (C++) GUI")

    # Разрешаем и ARM64 и x86_64
    if(NOT (CMAKE_SYSTEM_PROCESSOR MATCHES "aarch64|arm64|x86_64|AMD64"))
        message(WARNING "Unknown architecture: ${CMAKE_SYSTEM_PROCESSOR}")
    endif()

    # Требуем OpenGL
    find_package(OpenGL REQUIRED)
    # Требуем GLFW 3.3 или новее
    find_package(glfw3 3.3 REQUIRED)

    # Создаем исполняемый файл для Linux GUI на C++
    add_executable(AsciiArtStudio
        ${LINUX_GUI}/main.cpp
        ${LINUX_GUI}/gui.cpp
        ${LINUX_GUI}/gui.hpp
        ${RESOURCE_FILES}
    )

    # Подключаем библиотеку ImGui для Linux GUI на C++
    add_library(imgui
        ${IMGUI}/imgui.cpp
        ${IMGUI}/imgui.h
        ${IMGUI}/imgui_draw.cpp
        ${IMGUI}/imgui_widgets.cpp
        ${IMGUI}/imgui_tables.cpp
        ${IMGUI}/imgui_impl_glfw.cpp
        ${IMGUI}/imgui_impl_glfw.h
        ${IMGUI}/imgui_impl_opengl3.cpp
        ${IMGUI}/imgui_impl_opengl3.h
        ${IMGUI}/imgui_impl_opengl3_loader.h
        ${IMGUI}/imconfig.h
        ${IMGUI}/imgui_internal.h
        ${IMGUI}/imstb_rectpack.h
        ${IMGUI}/imstb_textedit.h
        ${IMGUI}/imstb_truetype.h
    )

    target_include_directories(${PROJECT_NAME} 
        PRIVATE ${IMGUI}     # imgui files
    )  

    target_link_libraries(${PROJECT_NAME} 
        PRIVATE CORE imgui glfw OpenGL::GL dl # Подключаем библиотеки: CORE, imgui, glfw, OpenGL и dl
    ) 

    file(COPY ${RESOURCES}/ascii_font.json DESTINATION ${CMAKE_BINARY_DIR}/Resources)
    file(COPY ${RESOURCES}/icon.png DESTINATION ${CMAKE_BINARY_DIR}/Resources)

else()
    message(FATAL_ERROR "Unsupported platform")
endif()