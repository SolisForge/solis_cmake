# =============================================================================
# Project: SOLIS_CMAKE
# 
# This file contains all methods related to manipulating cache for solis
# targets.
# 
# Author    Meltwin (github@meltwin.fr)
# Date      17/10/2025 (created 14/10/2025)
# Version   1.0.0
# Copyright Solis Forge | 2025 
#           Distributed under MIT License (https://opensource.org/licenses/MIT)
# =============================================================================

set(_SOLIS_TARGET_CACHES_TYPE "CMAKE;CXX;PY")

# =============================================================================
# Register a target for autonomous packaging by the solis stack.
#
# Author: Meltwin
# Since : 1.0.0
# =============================================================================
function(solis_register_target _type)
    add_to_solis_cache(TARGET "${_type}" VALUES "${ARGN}")
endfunction()

# =============================================================================
# Get a register variable for a target
#
# Author: Meltwin
# Since : 1.0.0
# =============================================================================
function(__get_solis_target_cache_var _out _type)
    list(FIND _SOLIS_TARGET_CACHES_TYPE "${_type}" _lst_index)
    if( ${_lst_index} GREATER -1)
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
    elseif ("${_type}" STREQUAL "CXX")
        set(${_out} "CMake files to install")
    else()
        log_error("Unknown target type ${_type}. Valid values are: ${_SOLIS_TARGET_REGISTERS}")
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
