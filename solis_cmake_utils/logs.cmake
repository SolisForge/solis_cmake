# =============================================================================
# Project: SOLIS_CMAKE
# 
# This file contains the function definition to display message
# 
# Author    Meltwin (github@meltwin.fr)
# Date      11/10/2025 (created 11/10/2025)
# Version   1.0.0
# Copyright Solis Forge | 2025 
#           Distributed under MIT License (https://opensource.org/licenses/MIT)
# =============================================================================

# =============================================================================
# Display a new section
#
# Author: Meltwin
# Since: 0.0.1
# =============================================================================
function(log_section section_name)
    cmake_parse_arguments("" "" "ORIGIN" "" ${ARGN})
    set(_prefix "")
    if (_ORIGIN)
        set(_prefix "[${_ORIGIN}] ")
    endif()

    # Print string
    string(TOUPPER ${section_name} upper_name)
    message("${TERM_DIM_BLUE}------ ${TERM_BOLD_RED}${_prefix}${upper_name}${TERM_DIM_BLUE} ------${TERM_CLR}")
endfunction()

# =============================================================================
# Display a new step
#
# Author: Meltwin
# Since : 0.0.1
# =============================================================================
function(log_step step_name)
    message("+ ${step_name}")
endfunction()

# =============================================================================
# Display output lines (for subprocess stdout)
#
# Author: Meltwin
# Since : 0.0.1
# =============================================================================
function(begin_output)
    message("${TERM_BACK_DIM_BLACK}${TERM_BLUE}")
endfunction()

function(end_output)
    message("${TERM_CLR}")
endfunction()

function(log_output msg)
    string(REGEX MATCHALL "[^\n\r]+" LINES ${msg})
    message("${TERM_DIM_WHITE}${msg}")
endfunction()