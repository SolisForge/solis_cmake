# ==============================================================================
# Project: SOLIS_CMAKE
# 
# Configuration file for this project
# 
# Author    Meltwin (github@meltwin.fr)
# Date      12/10/2025 (created 16/09/2025)
# Version   1.0.0
# Copyright Solis Forge | 2025 
#           Distributed under MIT License (https://opensource.org/licenses/MIT)
# ==============================================================================

cmake_minimum_required(VERSION 3.25)
project(solis_cmake)

include(solis_cmake_utils/solis_cmake_utils.cmake)
include(solis_cmake_targets/solis_cmake_targets.cmake)
include(solis_cmake_package/solis_cmake_package.cmake)

log_section("Configuring package [solis_cmake]")

add_solis_cmake(cmake_files
    DIRECTORIES "solis_cmake_utils" "solis_cmake_targets" "solis_cmake_package"
)

message("CMAKE: ${${PROJECT_NAME}_TARGETS_CMAKE}")

# Package this project
solis_package()