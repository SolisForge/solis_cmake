# =============================================================================
# Project: SOLIS_CMAKE
# 
# This file contains the include calls for all exporting solis projects.
# 
# Author    Meltwin (github@meltwin.fr)
# Date      08/11/2025 (created 27/10/2025)
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
# Directory in which to install everything
set(PROJECT_INSTALL_DIR "${CMAKE_INSTALL_PREFIX}")
# Directory in which to install CMake files
set(PROJECT_INSTALL_CMAKEDIR "${CMAKE_INSTALL_DATAROOTDIR}/${PROJECT_NAME}")
# Directory in which to install Python files
set(PROJECT_INSTALL_PYTHONDIR "${CMAKE_INSTALL_LIBDIR}/python3/$<IF:${IS_WIN},site-packages,dist-packages>" )
# Directory in which this file is installed
set(SOLIS_CMAKE_INSTALL_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}")

# =============================================================================
# Include all function of this module
# =============================================================================
include(${CMAKE_CURRENT_LIST_DIR}/install_targets.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/make_config.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/install_env.cmake)

# =============================================================================
# Launch the packaging sequence of the project
#
# Author: Meltwin
# Since : 1.0.0
# =============================================================================
function(solis_install)
    log_section("configuring install phase" ORIGIN "solis-install")
    # Install targets
    _solis_install_cmake()
    _solis_install_cxx()
    _solis_install_python_modules()
    _solis_install_scripts()
    # Make project's config file
    mk_solis_config()
    # Install environement
    add_solis_environment()
endfunction()