# =============================================================================
# Project: SOLIS_CMAKE
# 
# This file contains the definition of the functions installing the 
# environement scripts of the solis project.
# 
# Author    Meltwin (github@meltwin.fr)
# Date      25/10/2025 (created 25/10/2025)
# Version   1.0.0
# Copyright Solis Forge | 2025 
#           Distributed under MIT License (https://opensource.org/licenses/MIT)
# =============================================================================

# =============================================================================
# Install the setup script in the install folder
#
# Author: Meltwin
# Since 0.0.1
# =============================================================================
function(add_solis_environment)
    log_step("Setting-up environment scripts")
    install(
        FILES ${SOLIS_CMAKE_INSTALL_MODULE_PATH}/setup.sh
        DESTINATION ${PROJECT_INSTALL_DIR}
        PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_WRITE GROUP_EXECUTE WORLD_EXECUTE
    )
endfunction()