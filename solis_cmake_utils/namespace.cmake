# =============================================================================
# Project: SOLIS_CMAKE
# 
# Target namespace mechanism to allow simpler usage in other packages.
# 
# Author    Meltwin (github@meltwin.fr)
# Date      22/11/2025 (created 19/11/2025)
# Version   1.0.0
# Copyright Solis Forge | 2025 
#           Distributed under MIT License (https://opensource.org/licenses/MIT)
# =============================================================================

set(PROJECT_NAMESPACE_DOCSTRING "Project's namespace")
set(TARGET_NAMESPACE_DOCSTRING "Target's namespace")

# =============================================================================
# Get the target namespace.
# Arguments:
#   - TARGET: the target to get the namespace of.
#        If none are provided, return the project namespace.
#   - NAMESPACE: if provided, apply this namespace on the given target 
#        (or project if none)
#
# Author: Meltwin
# Since : 1.0.0
# =============================================================================
function(solis_namespace _out)
    cmake_parse_arguments("" "" "TARGET;SET" "" ${ARGN})
    set(PRJ_NS "${PROJECT_NAME}_NAMESPACE")
    set(TARGET_NS "${PROJECT_NAME}_${_TARGET}_NAMESPACE")

    # Get namespace
    # -----------------------------------------------------
    if ( "${_SET}" STREQUAL "" )  
        # A) Get project namespace    
        if ("${_TARGET}" STREQUAL "")   
            # If no namespace was set before, default it to the project name
            if ( "${${PRJ_NS}}" STREQUAL "")
                set(${PRJ_NS} ${PROJECT_NAME} CACHE STRING "${PROJECT_NAMESPACE_DOCSTRING}" FORCE)
            endif()
            register_solis_namespace(${PRJ_NS})
            set(${_out} ${${PRJ_NS}})

        # B) Get target namespace
        else()                          
            if ( "${${TARGET_NS}}" STREQUAL "")
                solis_namespace(_pkg_ns)
                set(${TARGET_NS} ${_pkg_ns} CACHE STRING "${TARGET_NAMESPACE_DOCSTRING}" FORCE)
            endif()
            register_solis_namespace(${TARGET_NS})
            set(${_out} ${${TARGET_NS}})

        endif()
    # Set namespace
    # -----------------------------------------------------
    else()
        # A) Set project namespace    
        if ( "${_TARGET}" STREQUAL "" )
            set(${PRJ_NS} ${_SET} CACHE STRING "${PROJECT_NAMESPACE_DOCSTRING}" FORCE)
            register_solis_namespace(${PRJ_NS})
            set(${_out} ${${PRJ_NS}})
        # B) Set target namespace
        else()
            set(${TARGET_NS} ${_SET} CACHE STRING "${TARGET_NAMESPACE_DOCSTRING}" FORCE)
            register_solis_namespace(${TARGET_NS})
            set(${_out} ${${TARGET_NS}})
        endif()
    endif()

    return(PROPAGATE ${_out} ${PRJ_NS} ${TARGET_NS})
endfunction()