# =============================================================================
# Project: SOLIS_CMAKE
# 
# Entry-point of the targets-related CMake module
# 
# Author    Meltwin (github@meltwin.fr)
# Date      12/12/2025 (created 10/12/2025)
# Version   1.0.0
# Copyright Solis Forge | 2025 
#           Distributed under MIT License (https://opensource.org/licenses/MIT)
# =============================================================================

include("${CMAKE_CURRENT_LIST_DIR}/targets_cmake.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/targets_cxx.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/targets_python.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/targets_scripts.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/targets_test.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/project_properties.cmake")