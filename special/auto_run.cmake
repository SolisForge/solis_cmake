# =============================================================================
# Project: SOLIS_CMAKE
# 
# This file will be loaded at each find_package of solis_package.
# 
# Author    Meltwin (github@meltwin.fr)

# Date      12/12/2025 (created 04/12/2025)
# Version   1.0.0
# Copyright Solis Forge | 2025 
#           Distributed under MIT License (https://opensource.org/licenses/MIT)
# =============================================================================

log_section("Configuring project \"${PROJECT_NAME}\"" ORIGIN "solis-project")
clear_solis_caches()
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Enable test ?
option(COMPILE_TESTS "Compile the tests defined in this project to be discoverable by CTest ?" OFF)
if (${COMPILE_TESTS})
    enable_testing()
endif()
log_debug("Test compilation is ${COMPILE_TESTS}")