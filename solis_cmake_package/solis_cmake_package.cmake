# =============================================================================
# Project: SOLIS_CMAKE
# 
# This file contains the include calls for all packaging CMake functions.
# 
# Author    Meltwin (github@meltwin.fr)
# Date      19/10/2025 (created 19/10/2025)
# Version   1.0.0
# Copyright Solis Forge | 2025 
#           Distributed under MIT License (https://opensource.org/licenses/MIT)
# =============================================================================

include(GNUInstallDirs)
include(CMakePackageConfigHelpers)

if (WIN32)
    set(IS_WIN "1")
else()
    set(IS_WIN "0")
endif()

# =============================================================================
# Define some directory short-hand for configuring the project
# =============================================================================
# Build directory for share files
set(PROJECT_BUILD_DATAROOTDIR "${PROJECT_BINARY_DIR}/share")
# Build directory to generate CMake files
set(PROJECT_BUILD_CMAKEDIR "${PROJECT_BUILD_DATAROOTDIR}/${PROJECT_NAME}/cmake")
# Directory in which to install CMake files
set(PROJECT_INSTALL_CMAKEDIR "${CMAKE_INSTALL_DATAROOTDIR}/${PROJECT_NAME}")
# Directory in which to install Python files
set(PROJECT_INSTALL_PYTHONDIR "${CMAKE_INSTALL_LIBDIR}/python3/$<IF:${IS_WIN},site-packages,dist-packages>" )

# =============================================================================
# Include all function of this module
# =============================================================================
include(${CMAKE_CURRENT_LIST_DIR}/install_targets.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/make_config.cmake)

# =============================================================================
# Launch the packaging sequence of the project
#
# Author: Meltwin
# Since : 1.0.0
# =============================================================================
function(solis_package)
    log_section("Packaging the project \"${PROJECT_NAME}\"" ORIGIN "solis")
    _solis_install_cmake()
    _solis_install_cxx()
    _solis_install_python_modules()
    mk_solis_config()
endfunction()