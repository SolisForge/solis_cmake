# =============================================================================
# Project: SOLIS_CMAKE
# 
# Definition of CMake targets
# 
# Author    Meltwin (github@meltwin.fr)
# Date      12/10/2025 (created 12/10/2025)
# Version   1.0.0
# Copyright Solis Forge | 2025 
#           Distributed under MIT License (https://opensource.org/licenses/MIT)
# =============================================================================

# =============================================================================
# Register a target to install CMake files into the output directory
#
# Author: Meltwin
# Since : 1.0.0
# =============================================================================
macro(add_solis_cmake)
    cmake_parse_arguments("" "" "" "FILES;DIRECTORIES" ${ARGN})
    get_files(cmake_files EXT ".cmake" FILE ${_FILES} DIRECTORY ${_DIRECTORIES})
    log_step("Registering CMake files")
    solis_register(CMAKE "${cmake_files}")

    # Cleaning local variables
    unset(cmake_files)
endmacro()