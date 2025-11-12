# =============================================================================
# Project: SOLIS_CMAKE
# 
# This file will be loaded at each find_package of solis_package.
# 
# Author    Meltwin (github@meltwin.fr)
# Date      12/11/2025 (created 12/11/2025)
# Version   1.0.0
# Copyright Solis Forge | 2025 
#           Distributed under MIT License (https://opensource.org/licenses/MIT)
# =============================================================================

log_section("Configuring project \"${PROJECT_NAME}\"" ORIGIN "solis-project")
clear_solis_caches()
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)