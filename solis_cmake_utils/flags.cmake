# =============================================================================
# Project: SOLIS_CMAKE
# 
# This file contains util CMake methods.
# 
# Author    Meltwin (github@meltwin.fr)
# Date      16/09/2025 (created 16/09/2025)
# Version   1.0.0
# Copyright Solis Forge | 2025 
#           Distributed under MIT License (https://opensource.org/licenses/MIT)
# =============================================================================

# =============================================================================
# Test if only one of the flag is ON.
#
# Author: Meltwin
# Since: 0.0.1
# =============================================================================
function(only_one_flag out)
    list(LENGTH ARGN length)
    if (${length} EQUAL 1)
        set(${out} TRUE PARENT_SCOPE)
    else()
        set(${out} FALSE PARENT_SCOPE)
    endif()
endfunction()