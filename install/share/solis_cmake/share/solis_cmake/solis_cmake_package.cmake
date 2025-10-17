# =============================================================================
# Project: SOLIS_CMAKE
# 
# This file contains the include calls for all packaging CMake functions.
# 
# Author    Meltwin (github@meltwin.fr)
# Date      17/10/2025 (created 11/10/2025)
# Version   1.0.0
# Copyright Solis Forge | 2025 
#           Distributed under MIT License (https://opensource.org/licenses/MIT)
# =============================================================================

include(GNUInstallDirs)
include(CMakePackageConfigHelpers)
include(${CMAKE_CURRENT_LIST_DIR}/install_targets.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/make_config.cmake)

# =============================================================================
# Launch the packaging sequence of the project
#
# Author: Meltwin
# Since: 0.0.1
# =============================================================================
function(solis_package)
    log_section("Packaging the project" ORIGIN "solis")
    _solis_install_cmake()
    mk_solis_config()
endfunction()