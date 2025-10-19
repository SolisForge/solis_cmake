# =============================================================================
# Project: SOLIS_CMAKE
# 
# 
# 
# Author    Meltwin (github@meltwin.fr)
# Date      19/10/2025 (created 19/10/2025)
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

    # Register module to be exported
    register_solis_target(PY_MODULE "${_target}&${_directory}")
endfunction()