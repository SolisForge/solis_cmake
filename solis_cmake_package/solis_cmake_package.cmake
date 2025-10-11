# =============================================================================
# Project: SOLIS_CMAKE
# 
# This file contains the include calls for all packaging CMake functions.
# 
# Author    Meltwin (github@meltwin.fr)
# Date      11/10/2025 (created 11/10/2025)
# Version   1.0.0
# Copyright Solis Forge | 2025 
#           Distributed under MIT License (https://opensource.org/licenses/MIT)
# =============================================================================

include(${CMAKE_CURRENT_LIST_DIR}/make_config.cmake)

# =============================================================================
# Launch the packaging sequence of the project
#
# Author: Meltwin
# Since: 0.0.1
# =============================================================================
function(solis_package)
    log_section("Packaging the project" ORIGIN "solis")
    mk_solis_config()
endfunction()