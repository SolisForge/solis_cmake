# =============================================================================
# Project: SOLIS_CMAKE
# 
# This file contains the function definition to display message
# 
# Author    Meltwin (github@meltwin.fr)
# Date      26/05/2026 (created 04/12/2025)
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
    center_text("${TERM_BOLD_RED}${_prefix}${upper_name}${TERM_DIM_BLUE}" 80 section_header CHAR "-")
    message("${TERM_DIM_BLUE}${section_header}${TERM_CLR}")
endfunction()

# =============================================================================
# Display a new step
#
# Author: Meltwin
# Since : 1.0.0
# =============================================================================
function(log_step step_name)
    message("${TERM_BOLD_RED}+ ${TERM_BLUE}${step_name}")
endfunction()

# =============================================================================
# Specialization of log_step to print a new target
#
# Author: Meltwin
# Since : 1.0.0
# =============================================================================
function(log_target _target _type)
    log_step("Configuring ${_type} target ${TERM_UNDER_YELLOW}\"${_target}\"")
endfunction()

# =============================================================================
# Display debug messages
#
# Author: Meltwin
# Since : 1.0.0
# =============================================================================
function(log_debug msg)
    message(VERBOSE "${TERM_DIM_WHITE}${msg}")
endfunction()

# =============================================================================
# Display error messages
#
# Author: Meltwin
# Since : 1.0.0
# =============================================================================
macro(log_warning msg)
    message(AUTHOR_WARNING " ${TERM_BOLD_YELLOW}${msg}")
endmacro()
macro(log_error msg)
    message(SEND_ERROR " ${TERM_BOLD_RED}${msg}")
endmacro()

# =============================================================================
# Display output lines (for subprocess stdout)
#
# Author: Meltwin
# Since : 1.0.0
# =============================================================================
function(log_output msg)
    message("${TERM_DIM_WHITE}${msg}")
endfunction()