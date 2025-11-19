# =============================================================================
# Project: SOLIS_CMAKE
# 
# Special cache management for namespaces as they are target-dependent and are
# not in fixed number.
# 
# Author    Meltwin (github@meltwin.fr)
# Date      19/11/2025 (created 19/11/2025)
# Version   1.0.0
# Copyright Solis Forge | 2025 
#           Distributed under MIT License (https://opensource.org/licenses/MIT)
# =============================================================================

# =============================================================================
# Register a namespace for autonomous cleaning at each reconfiguration.
#
# Author: Meltwin
# Since : 1.0.0
# =============================================================================
function(register_solis_namespace _reg)
    _register_solis_cache(${_reg})
endfunction()