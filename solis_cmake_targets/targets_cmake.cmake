# =============================================================================
# Project: SOLIS_CMAKE
# 
# Definition of CMake targets
# 
# Author    Meltwin (github@meltwin.fr)
# Date      18/10/2025 (created 12/10/2025)
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
function(add_solis_cmake)
    cmake_parse_arguments("" "NO_AUTO_LOAD" "" "FILES;DIRECTORIES" ${ARGN})
    get_files(cmake_files EXT ".cmake" FILE ${_FILES} DIRECTORY ${_DIRECTORIES})
    log_step("Registering CMake files")
    if (_NO_AUTO_LOAD)
        register_solis_target(CMAKE_NOLOAD "${cmake_files}")
    else()
        register_solis_target(CMAKE "${cmake_files}")
    endif()
endfunction()

# =============================================================================
# Add a CMake module to the install path and load it automatically
#
# Author: Meltwin
# Since : 1.0.0
# =============================================================================
function(add_solis_cmake_module)
    cmake_parse_arguments("" "" "" "DIRECTORIES" ${ARGN})
    foreach(_dir ${_DIRECTORIES})
        log_step("Registering CMake module \"${_dir}\"")
        
        # Check for entrypoint in module
        # TODO: improve by only taking last directory part for file name
        set(entrypoint "${_dir}/${_dir}.cmake")
        if (NOT EXISTS "${PROJECT_SOURCE_DIR}/${entrypoint}")
            log_error("Entrypoing of CMake module ${entrypoint} cannot be found !")
        endif()

        # Get module files and register them as no_load (entrypoint will do it)
        get_files(cmake_files EXT ".cmake" DIRECTORY "${_dir}")
        register_solis_target(CMAKE_NOLOAD "${cmake_files}")
        # Auto-load entrypoint
        register_solis_target(CMAKE "${entrypoint}")
        # Register module
        register_solis_target(CMAKE_MODULE "${_dir}")
    endforeach()
endfunction()