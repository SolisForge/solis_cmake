# =============================================================================
# Project: SOLIS_CMAKE
# 
# 
# 
# Author    Meltwin (github@meltwin.fr)
# Date      12/10/2025 (created 12/10/2025)
# Version   1.0.0
# Copyright Solis Forge | 2025 
#           Distributed under MIT License (https://opensource.org/licenses/MIT)
# =============================================================================

# =============================================================================
# Add the files or targets to the given register
#
# Author: Meltwin
# Since : 1.0.0
# =============================================================================
function(_get_register _type _out)
    set(${_out} ${PROJECT_NAME}_TARGETS_${_type} PARENT_SCOPE) 
endfunction()

# =============================================================================
# Register a target for autonomous packaging by the solis stack.
#
# Author: Meltwin
# Since : 1.0.0
# =============================================================================
function(solis_register)
    # Process inputs
    cmake_parse_arguments("" "CMAKE;CXX;PY" "" "" ${ARGN})
    check_one_flag(_CMAKE _CXX _PY)

    # Get the right register
    if (${_CMAKE})
        _get_register(CMAKE _REGISTER)
    endif()


    # Affect the value to the right register
    list(APPEND ${_REGISTER} ${_UNPARSED_ARGUMENTS})
    return(PROPAGATE 
        ${_REGISTER}
    )
endfunction()