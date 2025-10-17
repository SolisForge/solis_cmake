# =============================================================================
# Project: SOLIS_CMAKE
# 
# This file contains the several functions used to install the diverse targets
# define in the project.
# 
# Author    Meltwin (github@meltwin.fr)
# Date      17/10/2025 (created 17/10/2025)
# Version   1.0.0
# Copyright Solis Forge | 2025 
#           Distributed under MIT License (https://opensource.org/licenses/MIT)
# =============================================================================

# =============================================================================
# Export the project CMake files
#
# Author: Meltwin
# Since 0.0.1
# =============================================================================
function(_solis_install_cmake)
  get_solis_cache(TARGET _reg _doc CMAKE)
  if (NOT "${${_reg}}" STREQUAL "")
    log_step("Exporting CMake files for package \"${PROJECT_NAME}\"")
    install(
        FILES ${${_reg}}
        DESTINATION "${CMAKE_INSTALL_DATAROOTDIR}/${PROJECT_NAME}/share/${PROJECT_NAME}"
    )
  endif()
endfunction()