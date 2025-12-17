# =============================================================================
# Project: SOLIS_CMAKE
# 
# Project-related properties definition & manipulation
# 
# Author    Meltwin (github@meltwin.fr)
# Date      08/12/2025 (created 08/12/2025)
# Version   1.0.0
# Copyright Solis Forge | 2025 
#           Distributed under MIT License (https://opensource.org/licenses/MIT)
# =============================================================================

# Property to register project dependencies
define_property(GLOBAL 
    PROPERTY PROJET_DEPS
    BRIEF_DOCS "Project dependencies list"
)

# =============================================================================
# Register a dependency for this project
#
# Author: Meltwin
# Since : 1.0.0
# =============================================================================
function (register_dependency pkg)
    find_package(${pkg} ${ARGN})

    # Test if dependency is already registered
    get_property(_deps GLOBAL PROPERTY PROJECT_DEPS)
    list(FIND _deps "${pkg}" found)    
    if ( NOT "${found}" EQUAL -1)
        continue()
    endif()

    # Register dependency
    log_debug("Registering dependency ${pkg}")
    set_property(GLOBAL APPEND PROPERTY PROJECT_DEPS "${pkg}")
endfunction()
