# =============================================================================
# Project: SOLIS_CMAKE
# 
# This file contains all methods related to manipulating cache for solis
# projects.
# 
# Author    Meltwin (github@meltwin.fr)
# Date      18/10/2025 (created 18/10/2025)
# Version   1.0.0
# Copyright Solis Forge | 2025 
#           Distributed under MIT License (https://opensource.org/licenses/MIT)
# =============================================================================

set(_SOLIS_PROJECT_CACHES_TYPE "DEPENDENCIES")

# =============================================================================
# Get a register variable for a project cache
#
# Author: Meltwin
# Since : 1.0.0
# =============================================================================
function(__get_solis_project_cache_var _out _type)
    if("${_type}" IN_LIST _SOLIS_PROJECT_CACHES_TYPE)
        set(${_out} ${PROJECT_NAME}_${_type})
    else()
        log_error("Unknown project cache type ${_type}. Valid values are: ${_SOLIS_PROJECT_CACHES_TYPE}")
    endif()
    return(PROPAGATE ${_out})
endfunction()

# =============================================================================
# Get a register docstring for a project cache
#
# Author: Meltwin
# Since : 1.0.0
# =============================================================================
function(__get_solis_project_cache_doc _out _type)
    if("${_type}" STREQUAL "DEPENDENCIES")
        set(${_out} "Dependencies to register in the <project_name>Config.cmake file")
    elseif("${_type}" IN_LIST _SOLIS_PROJECT_CACHES_TYPE)
        set(${_out} "Unformated doc")
        log_warning("Documentation for project cache type ${_type} is not written!")
    else()
        log_error("Unknown project cache type ${_type}. Valid values are: ${_SOLIS_PROJECT_CACHES_TYPE}")
    endif()
    return(PROPAGATE ${_out})
endfunction()

# =============================================================================
# Get a register for a project cache type
#
# Author: Meltwin
# Since : 1.0.0
# =============================================================================
function(__get_solis_project_cache _register_var _docstring _type)
    __get_solis_project_cache_var(_VAR ${_type})
    set(${_register_var} ${_VAR})
    __get_solis_project_cache_doc(_DOC ${_type})
    set(${_docstring} ${_DOC})
    return(PROPAGATE ${_register_var} ${_docstring})
endfunction()

# =============================================================================
# Register all project registers
# =============================================================================
foreach(_reg ${_SOLIS_PROJECT_CACHES_TYPE})
    __get_solis_project_cache_var(_register ${_reg})
    _register_solis_cache(${_register})
endforeach()
unset(_register)
