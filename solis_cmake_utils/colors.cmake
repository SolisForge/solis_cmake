# =============================================================================
# Project: SOLIS_CMAKE
# 
# Color code for CMake message outputs
# 
# Author    Meltwin (github@meltwin.fr)
# Date      11/10/2025 (created 11/10/2025)
# Version   1.0.0
# Copyright Solis Forge | 2025 
#           Distributed under MIT License (https://opensource.org/licenses/MIT)
# =============================================================================

# =============================================================================
# Test if terminal support color
#
# Using tput to determine whether the given terminal can display colored text.
# =============================================================================
set(COLOR_SUPPORTED OFF)
if (NOT WIN32)
    execute_process(COMMAND "tput" "colors" OUTPUT_VARIABLE _color_value ERROR_QUIET)
    string(COMPARE NOTEQUAL "${_color_value}" "" COLOR_SUPPORTED)
endif()

# =============================================================================
# Terminal color codes
# =============================================================================
if (COLOR_SUPPORTED)
    string(ASCII 27 _TERM_ESC)
    set(TERM_CLR "${_TERM_ESC}[0m")
    # Modifier
    set(_TERM_BOLD_CODE    1)
    set(_TERM_DIM_CODE     2)
    set(_TERM_UNDER_CODE   4)
    set(_TERM_BLINK_CODE   5)
    set(_TERM_REVERSE_CODE 7)
    set(_TERM_HIDE_CODE    8)

    # Colors
    set(_TERM_BLACK_CODE   0)
    set(_TERM_RED_CODE     1)
    set(_TERM_GREEN_CODE   2)
    set(_TERM_YELLOW_CODE  3)
    set(_TERM_BLUE_CODE    4)
    set(_TERM_PURPLE_CODE  5)
    set(_TERM_CYAN_CODE    6)
    set(_TERM_WHITE_CODE   7)
    set(_TERM_DEFAULT_CODE 9)

    # Ranges
    set(_TERM_FORE_RANGE          30)
    set(_TERM_BACK_RANGE          40)
    set(_TERM_BRIGHT_RANGE        90)
    set(_TERM_BRIGHT_BACK_RANGE  100)
endif()

# =============================================================================
# Colors builders
#
# Author: Meltwin
# Since : 1.0.0
# =============================================================================
if(COLOR_SUPPORTED)
    # Parse and export the colors flags
    function(_get_color_flags _out)
        cmake_parse_arguments("" "BOLD;BLINK;BRIGHT;DIM;HIDE;REVERSE;UNDER" "" "" ${ARGN})
        set(_code "")

        if(_BOLD)
            list(APPEND _code "${_TERM_BOLD_CODE}")
        endif()
        if(_DIM)
            list(APPEND _code "${_TERM_DIM_CODE}")
        endif()
        if(_UNDER)
            list(APPEND _code "${_TERM_UNDER_CODE}")
        endif()
        if(_BLINK)
            list(APPEND _code "${_TERM_BLINK_CODE}")
        endif()
        if(_REVERSE)
            list(APPEND _code "${_TERM_REVERSE_CODE}")
        endif()
        if(_HIDE)
            list(APPEND _code "${_TERM_HIDE_CODE}")
        endif()

        # Return value to parent
        set(${_out} ${_code} PARENT_SCOPE)
    endfunction()

    # Parse and export a foretext color
    function(make_fore_color _out color)
        _get_color_flags(_flags ${ARGN})

        # Add color
        set(_outcode "")
        if (_BRIGHT)
            math(EXPR color_code "${${color}}+${_TERM_BRIGHT_RANGE}")
        else()
            math(EXPR color_code "${${color}}+${_TERM_FORE_RANGE}")
        endif()
        list(APPEND _outcode ${color_code})
        list(APPEND _outcode ${_flags})

        # Return the code
        set(${_out} "${_TERM_ESC}[${_outcode}m" PARENT_SCOPE)
    endfunction()

    # Parse and export a background color
    function(make_back_color _out color)
        _get_color_flags(_flags ${ARGN})

        # Add color
        set(_outcode "")
        if (_BRIGHT)
            math(EXPR color_code "${${color}}+${_TERM_BRIGHT_BACK_RANGE}")
        else()
            math(EXPR color_code "${${color}}+${_TERM_BACK_RANGE}")
        endif()
        list(APPEND _outcode ${color_code})
        list(APPEND _outcode ${_flags})

        # Return the code
        set(${_out} "${_TERM_ESC}[${_outcode}m" PARENT_SCOPE)
    endfunction()
else()
    # If colors are not supported, don't do anything
    function(make_fore_color)
    endfunction()
    function(make_back_color)
    endfunction()
endif()

# =============================================================================
# Make usual color codes
# =============================================================================
macro(_build_colors_from_code _name)
    make_fore_color(TERM_${_name} _TERM_${_name}_CODE)
    make_fore_color(TERM_LIGHT_${_name} _TERM_${_name}_CODE BRIGHT)
    make_fore_color(TERM_DIM_${_name} _TERM_${_name}_CODE DIM)
    make_fore_color(TERM_BOLD_${_name} _TERM_${_name}_CODE BOLD)
    make_back_color(TERM_BACK_${_name} _TERM_${_name}_CODE)
    make_back_color(TERM_BACK_LIGHT_${_name} _TERM_${_name}_CODE BRIGHT)
    make_back_color(TERM_BACK_DIM_${_name} _TERM_${_name}_CODE DIM)
    make_back_color(TERM_BACK_BOLD_${_name} _TERM_${_name}_CODE BOLD)
endmacro()

_build_colors_from_code(BLACK)
_build_colors_from_code(RED)
_build_colors_from_code(GREEN)
_build_colors_from_code(YELLOW)
_build_colors_from_code(BLUE)
_build_colors_from_code(PURPLE)
_build_colors_from_code(CYAN)
_build_colors_from_code(WHITE)