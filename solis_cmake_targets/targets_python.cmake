# =============================================================================
# Project: SOLIS_CMAKE
# 
# Definition of Python module targets
# 
# Author    Meltwin (github@meltwin.fr)
# Date      08/11/2025 (created 19/10/2025)
# Version   1.0.0
# Copyright Solis Forge | 2025 
#           Distributed under MIT License (https://opensource.org/licenses/MIT)
# =============================================================================

# =============================================================================
# Register a target to install a Python module
#
# Author: Meltwin
# Since : 1.0.0
# =============================================================================
function(add_solis_python _target _directory)    
    log_step("Registering Python module \"${_target}\"")

    # Check target_name
    string(FIND "${_target}" "&" delim_exist)
    if (${delim_exist} GREATER -1)
        log_error("Python module name cannot contain the character \"&\"")
    endif()
    # Change "." to "/" delimitation in target name to make it a relative path
    string(REPLACE "." "/" formatted_target "${_target}")

    # Register module to be exported
    register_solis_target(PY_MODULE "${formatted_target}&${_directory}")
endfunction()