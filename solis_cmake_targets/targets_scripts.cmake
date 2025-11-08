# =============================================================================
# Project: SOLIS_CMAKE
# 
# Definition of script targets
# 
# Author    Meltwin (github@meltwin.fr)
# Date      08/11/2025 (created 08/11/2025)
# Version   1.0.0
# Copyright Solis Forge | 2025 
#           Distributed under MIT License (https://opensource.org/licenses/MIT)
# =============================================================================

# =============================================================================
# Register a target to install a script in the bin directory
#
# Author: Meltwin
# Since : 1.0.0
# =============================================================================
function(add_solis_script)
    cmake_parse_arguments("" "WIN32;LINUX" "" "FILES;DIRECTORIES" ${ARGN})
    get_files(script_files FILE ${_FILES} DIRECTORY ${_DIRECTORIES})

    if (NOT "${script_files}" STREQUAL "")
        # Register scripts
        if (${_WIN32})
            # Windows-only scripts
            foreach(_script ${script_files})
                log_step("Registering scripts \"${_script}\" (Windows only)")
                register_solis_target(SCRIPT_WIN ${script_files})
            endforeach()
        elseif(${_LINUX})
            # Linux-only scripts
            foreach(_script ${script_files})
                log_step("Registering scripts \"${_script}\" (Linux only)")
                register_solis_target(SCRIPT_LINUX ${script_files})
            endforeach()
        else()
            # All systems scripts (e.g. Python)
            foreach(_script ${script_files})
                log_step("Registering scripts \"${_script}\"")
                register_solis_target(SCRIPT ${script_files})
            endforeach()
        endif()
    else()
        log_error("No scripts found in the given FILES and DIRECTORIES tags")
    endif()   

endfunction()