# ==============================================================================
# Project: SOLIS_CMAKE
# 
# Configuration file for this project
# 
# Author    Meltwin (github@meltwin.fr)
# Date      18/10/2025 (created 18/10/2025)
# Version   1.0.0
# Copyright Solis Forge | 2025 
#           Distributed under MIT License (https://opensource.org/licenses/MIT)
# ==============================================================================

cmake_minimum_required(VERSION 3.25)
project(solis_cmake)

include(solis_cmake_utils/solis_cmake_utils.cmake)
include(solis_cmake_targets/solis_cmake_targets.cmake)
include(solis_cmake_package/solis_cmake_package.cmake)

# Run everything that should be done at the start of a project configuration
# E.g clearing all caches
include(special/auto_run.cmake)

# Export the CMake files
add_solis_cmake_module(
    DIRECTORIES "solis_cmake_utils" 
                "solis_cmake_targets" 
                "solis_cmake_package"
)
# Register the script to be run at the start of each project configuration
add_solis_cmake(FILES "special/auto_run.cmake")

# Package this project
solis_package()