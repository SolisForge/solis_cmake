# =============================================================================
# Project: SOLIS_CMAKE
# 
# Definition of C/C++ targets
# 
# Author    Meltwin (github@meltwin.fr)
# Date      18/10/2025 (created 18/10/2025)
# Version   1.0.0
# Copyright Solis Forge | 2025 
#           Distributed under MIT License (https://opensource.org/licenses/MIT)
# =============================================================================

# =============================================================================
# Register a target to compile a C/C++ executable
#
# Author: Meltwin
# Since : 1.0.0
# =============================================================================
function(add_solis_executable _target)
    cmake_parse_arguments("" "" "" "FILES;DIRECTORIES;DEPENDS;INCLUDES;INCLUDES_RAW" ${ARGN})
    
    log_step("Registering CXX executable \"${_target}\"")
    get_files(src_files EXT ".cpp" ".cxx" ".c" FILE ${_FILES} DIRECTORY ${_DIRECTORIES})
    if (NOT "${src_files}" STREQUAL "")
        # Configure executable
        add_executable(${_target} ${src_files})
        register_solis_target(CXX_EXE "${_target}")
    else()
        log_error("No source files found in the given FILES and DIRECTORIES tags")
    endif()   
endfunction()