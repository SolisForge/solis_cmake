# =============================================================================
# Project: SOLIS_CMAKE
# 
# This file contains all the function related to manipulating the cache
# 
# Author    Meltwin (github@meltwin.fr)
# Date      18/10/2025 (created 14/10/2025)
# Version   1.0.0
# Copyright Solis Forge | 2025 
#           Distributed under MIT License (https://opensource.org/licenses/MIT)
# =============================================================================

# =============================================================================
# Loading all cached registers from subfiles
# =============================================================================
set(${PROJECT_NAME}_ALL_CACHED_REGISTER "" CACHE STRING "All cached variables for this project" FORCE)
macro(_register_solis_cache _reg)
    list(APPEND ${PROJECT_NAME}_ALL_CACHED_REGISTER ${_reg})
endmacro()
include(${CMAKE_CURRENT_LIST_DIR}/cache/targets.cmake)

# =============================================================================
# Clear all cached registers defined by the solis environment.
#
# Author: Meltwin
# Since : 1.0.0
# =============================================================================
function(clear_solis_caches)
    foreach(_reg ${${PROJECT_NAME}_ALL_CACHED_REGISTER})
        set(${_reg} "" CACHE STRING "" FORCE)
    endforeach()
endfunction()

# =============================================================================
# Get a register CMake variable and docstring from its type
#
# Author: Meltwin
# Since : 1.0.0
# =============================================================================
function(get_solis_cache _type _register_var _docstring)
    cmake_parse_arguments("" "" "" "" ${ARGN})
    string(TOLOWER "${_type}" _low_type)
    set(_register_command "__get_solis_${_low_type}_cache")
    # Dynamically call the right register function
    if (COMMAND "${_register_command}")
        cmake_language(CALL "${_register_command}" ${_register_var} ${_docstring} ${_UNPARSED_ARGUMENTS})
    else()
        log_error("Register type ${_type} is invalid")
    endif()
    return(PROPAGATE ${_register_var} ${_docstring})
endfunction()

# =============================================================================
# Append the given value to the correspoding cache
#
# Author: Meltwin
# Since : 1.0.0
# =============================================================================
function(add_to_solis_cache _type)
    cmake_parse_arguments("" "" "" "VALUES" ${ARGN}) 
    get_solis_cache(${_type} _REG _DOC ${_UNPARSED_ARGUMENTS})
    list(APPEND "${_REG}" "${_VALUES}")
    set(${_REG} "${${_REG}}" CACHE STRING "${_DOC}" FORCE)
endfunction()

# =============================================================================
# Get the values from the requested cache
#
# Author: Meltwin
# Since : 1.0.0
# =============================================================================
function(get_from_solis_cache _type _out)
    get_solis_cache(${_type} _REG _DOC ${ARGN})
    set(${_out} ${${_REG}} PARENT_SCOPE)
endfunction()