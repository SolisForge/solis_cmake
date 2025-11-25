# ==============================================================================
# Project: SOLIS_CMAKE
# 
# Configuration file for this project
# 
# Author    Meltwin (github@meltwin.fr)
# Date      25/11/2025 (created 25/11/2025)
# Version   1.0.0
# Copyright Solis Forge | 2025 
#           Distributed under MIT License (https://opensource.org/licenses/MIT)
# ==============================================================================

cmake_minimum_required(VERSION 3.25)
project(solis_cmake)

# =============================================================================
# Include CMake compilation for this project
# =============================================================================

include(solis_cmake_utils/solis_cmake_utils.cmake)
include(solis_cmake_targets/solis_cmake_targets.cmake)
include(solis_cmake_install/solis_cmake_install.cmake)

# Run everything that should be done at the start of a project configuration
# E.g clearing all caches
include(special/auto_run.cmake)

# =============================================================================
# Export SOLIS CMake wrapper
# =============================================================================
# Export the CMake files
add_solis_cmake_module(
    DIRECTORIES "solis_cmake_utils" 
                "solis_cmake_targets" 
                "solis_cmake_install"
                "solis_cmake_tests"
)
# Register the script to be run at the start of each project configuration
add_solis_cmake(FILES "special/auto_run.cmake")

# Add others files
install(
    FILES solis_cmake_install/setup.sh
    DESTINATION ${PROJECT_INSTALL_CMAKEDIR}/solis_cmake_install
)

# =============================================================================
# External libraries
# =============================================================================
include(ExternalProject)
find_package(Git REQUIRED)

ExternalProject_Add(
    doctest_src
    TMP_DIR ${CMAKE_CURRENT_BINARY_DIR}/doctest/tmp
    STAMP_DIR ${CMAKE_CURRENT_BINARY_DIR}/doctest/stamp
    LOG_DIR ${CMAKE_CURRENT_BINARY_DIR}/doctest/logs
    SOURCE_DIR ${CMAKE_CURRENT_LIST_DIR}/libs/doctest
    BINARY_DIR ${CMAKE_CURRENT_BINARY_DIR}/doctest/doctest
    GIT_REPOSITORY https://github.com/doctest/doctest.git
    TIMEOUT 10
    UPDATE_COMMAND ${GIT_EXECUTABLE} pull
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
    LOG_DOWNLOAD OFF
)
add_solis_library( doctest
    PUBLIC_HEADER "libs/doctest/doctest"
    HEADER_BASE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/libs/doctest"
    HEADER_DIR solis_ext
    NAMESPACE solis_external
)

# =============================================================================
# Package this project
# =============================================================================
solis_install()