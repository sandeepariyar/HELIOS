cmake_minimum_required(VERSION 3.21)
project(Helios VERSION 0.3 LANGUAGES CXX)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
find_package(Qt6 6.5 REQUIRED COMPONENTS Quick Network)
# Optional: free Qt Multimedia component for low-latency WAV alerts.
if(NOT EMSCRIPTEN)
    find_package(Qt6 QUIET COMPONENTS Multimedia)
endif()
qt_standard_project_setup()
# QML must be installed under :/qt/qml/ for loadFromModule() on static/WebAssembly Qt.
# Without this, Qt can compile the app but fail at runtime with
# "Module \"Helios\" contains no type named \"Main\"".
qt_policy(SET QTP0001 NEW)

option(HELIOS_FETCH_FONTS "Fetch freely licensed OFL fonts if not present" ON)
if(HELIOS_FETCH_FONTS)
    find_package(Python3 QUIET COMPONENTS Interpreter)
    if(Python3_Interpreter_FOUND)
        execute_process(
            COMMAND "${Python3_EXECUTABLE}" "${CMAKE_CURRENT_SOURCE_DIR}/scripts/download_fonts.py" "${CMAKE_CURRENT_SOURCE_DIR}/fonts"
            RESULT_VARIABLE font_result TIMEOUT 30
        )
        if(NOT font_result EQUAL 0)
            message(WARNING "Font download failed; system font fallback will be used")
        endif()
    endif()
endif()

file(GLOB MCU_ASSETS RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}" CONFIGURE_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/assets/*.png")
file(GLOB MCU_FONTS RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}" CONFIGURE_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/fonts/*.ttf")
# Track source PNG bytes to make optimization savings visible in DEV metrics.
set(HELIOS_PNG_SOURCE_BYTES 0)
foreach(asset IN LISTS MCU_ASSETS)
    file(SIZE "${CMAKE_CURRENT_SOURCE_DIR}/${asset}" this_png_size)
    math(EXPR HELIOS_PNG_SOURCE_BYTES "${HELIOS_PNG_SOURCE_BYTES} + ${this_png_size}")
endforeach()
list(LENGTH MCU_ASSETS HELIOS_PNG_COUNT)
foreach(f IN ITEMS Main McuSlider McuRadialSlider UiButton DevMetricsPanel)
    set_source_files_properties("qml/${f}.qml" PROPERTIES QT_RESOURCE_ALIAS "${f}.qml")
endforeach()
qt_add_executable(Helios src/main.cpp src/EnergyBackend.cpp src/EnergyBackend.h)
# Keeping NO_CACHEGEN avoids MinGW assembler's 'too many sections' on auto-generated views.
qt_add_qml_module(Helios URI Helios VERSION 1.0 NO_CACHEGEN
    QML_FILES qml/Main.qml qml/McuSlider.qml qml/McuRadialSlider.qml qml/UiButton.qml qml/DevMetricsPanel.qml
    RESOURCES ${MCU_ASSETS} ${MCU_FONTS}
)
qt_add_resources(Helios "helios_sounds" PREFIX "/" FILES
    sounds/confirm.wav sounds/warning.wav sounds/trip.wav)
# Release ZIP size is a fixed build-snapshot field; this is *not* the user's changing working tree size.
set(HELIOS_RELEASE_ZIP_BYTES 576147 CACHE STRING "Published source ZIP size in bytes; set by release packager")
target_compile_definitions(Helios PRIVATE
    HELIOS_PNG_COUNT=${HELIOS_PNG_COUNT}
    HELIOS_PNG_SOURCE_BYTES=${HELIOS_PNG_SOURCE_BYTES}
    HELIOS_RELEASE_ZIP_BYTES=${HELIOS_RELEASE_ZIP_BYTES}
)
target_link_libraries(Helios PRIVATE Qt6::Quick Qt6::Network)
if(TARGET Qt6::Multimedia)
    target_link_libraries(Helios PRIVATE Qt6::Multimedia)
    target_compile_definitions(Helios PRIVATE HELIOS_HAS_MULTIMEDIA=1)
    message(STATUS "HELIOS audio: Qt Multimedia enabled")
else()
    message(WARNING "Qt Multimedia not installed: visual and controls work, sounds will be silent")
endif()

if(WIN32)
    target_link_libraries(Helios PRIVATE user32)
endif()
