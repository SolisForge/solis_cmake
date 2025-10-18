# ==============================================================================
# Project: SOLIS_CMAKE
# 
# Configuration file for this project
# 
# Author    Meltwin (github@meltwin.fr)
# Date      18/10/2025 (created 16/09/2025)
# Version   1.0.0
# Copyright Solis Forge | 2025 
#           Distributed under MIT License (https://opensource.org/licenses/MIT)
# ==============================================================================

cmake_minimum_required(VERSION 3.25)
project(solis_cmake)

include(solis_cmake_utils/solis_cmake_utils.cmake)
include(solis_cmake_targets/solis_cmake_targets.cmake)
include(solis_cmake_package/solis_cmake_package.cmake)

clear_solis_caches()
log_section("Configuring package \"${PROJECT_NAME}\"" ORIGIN "solis")

add_solis_cmake_module(
    DIRECTORIES "solis_cmake_utils" 
                "solis_cmake_targets" 
                "solis_cmake_package"
)

# Package this project
solis_package()