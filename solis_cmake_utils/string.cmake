# =============================================================================
# Project: SOLIS_CMAKE
# 
# String manipulation helper
# 
# Author    Meltwin (github@meltwin.fr)
# Date      18/10/2025 (created 18/10/2025)
# Version   1.0.0
# Copyright Solis Forge | 2025 
#           Distributed under MIT License (https://opensource.org/licenses/MIT)
# =============================================================================

# =============================================================================
# Text centering method
#
# Author: Meltwin
# Since : 1.0.0
# =============================================================================
function(center_text _text _width _out)
    cmake_parse_arguments("" "" "CHAR" "" ${ARGN})

    # Get right and left padding size
    string(LENGTH " ${_text} " _text_length)
    math(EXPR _padding_width "${_width} - ${_text_length}")
    math(EXPR left_padding "${_padding_width} >> 1")
    math(EXPR right_padding "${_padding_width} - ${left_padding}")

    if (NOT _CHAR)
        set(_CHAR " ")
    endif()

    string(REPEAT ${_CHAR} ${left_padding} _left)
    string(REPEAT ${_CHAR} ${right_padding} _right)
    set(${_out} "${_left} ${_text} ${_right}" PARENT_SCOPE)
endfunction()