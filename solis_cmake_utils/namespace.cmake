# =============================================================================
# Project: SOLIS_CMAKE
# 
# Target namespace mechanism to allow simpler usage in other packages.
# 
# Author    Meltwin (github@meltwin.fr)
# Date      08/06/2026 (created 18/12/2025)
# Version   1.0.0
# Copyright Solis Forge | 2025 
#           Distributed under MIT License (https://opensource.org/licenses/MIT)
# =============================================================================

define_property(GLOBAL PROPERTY NAMESPACE 
    BRIEF_DOCS "The project namespace's" 
)
define_property(TARGET PROPERTY NAMESPACE 
    BRIEF_DOCS "The target namespace's"
) 

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

    # Get namespace
    # -----------------------------------------------------
    if ( "${_SET}" STREQUAL "" )  
        # A) Get project namespace    
        if ("${_TARGET}" STREQUAL "")   
            get_property(PRJ_NS GLOBAL PROPERTY NAMESPACE)
            if ( NOT PRJ_NS OR "${PRJ_NS}" STREQUAL "")
                solis_namespace(_global_ns SET "${PROJECT_NAME}")
                set(${_out} ${_global_ns})
            else()
                set(${_out} ${PRJ_NS})
            endif()
        # B) Get target namespace
        else()        
            get_target_property(TARGET_NS ${_TARGET} NAMESPACE)   
            if ( NOT TARGET_NS OR "${TARGET_NS}" STREQUAL "")
                solis_namespace(PRJ_NS)
                solis_namespace(_target_ns TARGET ${_TARGET} SET ${PRJ_NS})
                set(${_out} ${_target_ns})
            else()
                set(${_out} ${TARGET_NS})
            endif()
        endif()
    # Set namespace
    # -----------------------------------------------------
    else()
        # A) Set project namespace    
        if ( "${_TARGET}" STREQUAL "" )
            set_property(GLOBAL PROPERTY NAMESPACE ${_SET})
            set(${_out} ${_SET})
        # B) Set target namespace
        else()
            set_target_properties(${_TARGET} PROPERTIES NAMESPACE ${_SET})
            get_target_property(_target_ns "${_TARGET}" NAMESPACE)
            set(${_out} ${_target_ns})
        endif()
    endif()

    return(PROPAGATE ${_out})
endfunction()