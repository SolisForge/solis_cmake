# =============================================================================
# Project: SOLIS_CMAKE
# 
# This file contains all methods related to manipulating cache for solis
# targets.
# 
# Author    Meltwin (github@meltwin.fr)
# Date      18/10/2025 (created 14/10/2025)
# Version   1.0.0
# Copyright Solis Forge | 2025 
#           Distributed under MIT License (https://opensource.org/licenses/MIT)
# =============================================================================

# =============================================================================
# Register a target for autonomous packaging by the solis stack.
#
# Author: Meltwin
# Since : 1.0.0
# =============================================================================
function(register_solis_target _type)
    add_to_solis_cache(TARGET "${_type}" VALUES "${ARGN}")
endfunction()

# =============================================================================
# Get the targets of the given types
#
# Author: Meltwin
# Since : 1.0.0
# =============================================================================
function(get_solis_targets _out)
    set(${_out} "")
    foreach(_type ${ARGN})
        get_from_solis_cache(TARGET _values "${_type}")
        list(APPEND ${_out} ${_values})
    endforeach()
    return(PROPAGATE ${_out})
endfunction()

set(_SOLIS_TARGET_CACHES_TYPE "CMAKE" "CXX_EXE" "CXX_LIB" "PY")

# =============================================================================
# Get a register variable for a target
#
# Author: Meltwin
# Since : 1.0.0
# =============================================================================
function(__get_solis_target_cache_var _out _type)
    if("${_type}" IN_LIST _SOLIS_TARGET_CACHES_TYPE)
        set(${_out} ${PROJECT_NAME}_TARGETS_${_type})
    else()
        log_error("Unknown target type ${_type}. Valid values are: ${_SOLIS_TARGET_CACHES_TYPE}")
    endif()
    return(PROPAGATE ${_out})
endfunction()

# =============================================================================
# Get a register docstring for a target
#
# Author: Meltwin
# Since : 1.0.0
# =============================================================================
function(__get_solis_target_cache_doc _out _type)
    if("${_type}" STREQUAL "CMAKE")
        set(${_out} "CMake files to install")
    elseif ("${_type}" STREQUAL "CXX_EXE")
        set(${_out} "C/C++ executable targets to compile")
    elseif ("${_type}" STREQUAL "CXX_LIB")
        set(${_out} "C/C++ library targets to compile")
    elseif("${_type}" IN_LIST _SOLIS_TARGET_CACHES_TYPE)
        set(${_out} "Unformated doc")
        log_warning("Document for target cache ${_type} is not written!")
    else()
        log_error("Unknown target type ${_type}. Valid values are: ${_SOLIS_TARGET_CACHES_TYPE}")
    endif()
    return(PROPAGATE ${_out})
endfunction()

# =============================================================================
# Get a register for a target type
#
# Author: Meltwin
# Since : 1.0.0
# =============================================================================
function(__get_solis_target_cache _register_var _docstring _type)
    __get_solis_target_cache_var(_VAR ${_type})
    set(${_register_var} ${_VAR})
    __get_solis_target_cache_doc(_DOC ${_type})
    set(${_docstring} ${_DOC})
    return(PROPAGATE ${_register_var} ${_docstring})
endfunction()

# =============================================================================
# Register all target registers
# =============================================================================
foreach(_reg ${_SOLIS_TARGET_CACHES_TYPE})
    __get_solis_target_cache_var(_register ${_reg})
    _register_solis_cache(${_register})
endforeach()
unset(_register)
