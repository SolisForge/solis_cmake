# =============================================================================
# Project: SOLIS_CMAKE
# 
# This file contains the definition of the function to generate the config files 
# for packaging the project.
#
# Author    Meltwin (github@meltwin.fr)
# Date      11/10/2025 (created 11/10/2025)
# Version   1.0.0
# Copyright Solis Forge | 2025 
#           Distributed under MIT License (https://opensource.org/licenses/MIT)
# =============================================================================

# Raw config file to be configured at installation
set(PROJECT_ROOT_CONFIG_FILE "${PROJECT_BUILD_CMAKEDIR}/${PROJECT_NAME}Config.cmake")
set(PROJECT_ROOT_CONFIG_FILE_RAW "${PROJECT_ROOT_CONFIG_FILE}.in")

# =============================================================================
# Entrypoint to generate the CMake config file (that allow other projects to
# find and load this package through find_package).
#
# Author: Meltwin
# Since : 1.0.0
# =============================================================================
function(mk_solis_config)
    log_step("Making ${PROJECT_NAME}Config.cmake file")

    # Write the config file
    _solis_config_header()
    _solis_config_dependencies()
    _solis_config_cxx_targets()
    _solis_config_cmake_targets()

    # Export it
    configure_package_config_file(
        ${PROJECT_ROOT_CONFIG_FILE_RAW}
        ${PROJECT_ROOT_CONFIG_FILE}
        INSTALL_DESTINATION ${PROJECT_INSTALL_CMAKEDIR}
    )
    install(
        FILES ${PROJECT_ROOT_CONFIG_FILE}
        DESTINATION ${PROJECT_INSTALL_CMAKEDIR}
    )
endfunction()

# =============================================================================
# Write the header of the config file, it does not do anything except writing
# the header of the automated generated part.
#
# Author: Meltwin
# Since : 1.0.0
# =============================================================================
function(_solis_config_header)
    file(WRITE ${PROJECT_ROOT_CONFIG_FILE_RAW} "@PACKAGE_INIT@\n")
    center_text("SOLIS_AUTOGEN" 77 _header CHAR "=")
    __solis_add_config_line("\n# ${_header}")
endfunction()

# =============================================================================
# Export the dependencies in the config file
#
# Author: Meltwin
# Since : 1.0.0
# =============================================================================
function(_solis_config_dependencies)
    get_from_solis_cache(PROJECT _deps DEPENDENCIES)
    list(LENGTH _deps _n_deps)
    if (_n_deps GREATER 0)
        # Write header
        __solis_add_header("${PROJECT_NAME} dependencies")
        __solis_add_config_line("include(CMakeFindDependencyMacro)")

        # Write the dependencies
        foreach(dep ${_deps})
            __solis_add_config_line("find_dependency(${dep})")
        endforeach()   
    endif()
endfunction()

# =============================================================================
# Export the targets in the config file
#
# Author: Meltwin
# Since : 1.0.0
# =============================================================================
function(_solis_config_cxx_targets)
    get_solis_targets(_targets CXX_EXE CXX_LIB)
    list(LENGTH _targets _n_targets)
    if (_n_targets GREATER 0)
        # Write header
        __solis_add_header("${PROJECT_NAME} C/CXX targets")
        # Include exported target file
        __solis_add_config_line("if (EXISTS \${CMAKE_CURRENT_LIST_DIR}/${PROJECT_NAME}Targets.cmake)")
        __solis_add_config_line("   include(\${CMAKE_CURRENT_LIST_DIR}/${PROJECT_NAME}Targets.cmake)")
        __solis_add_config_line("endif()")
    endif()
endfunction()

# =============================================================================
# Export the CMake files to be auto loaded when the package is found
#
# Author: Meltwin
# Since : 1.0.0
# =============================================================================
function(_solis_config_cmake_targets)
    # Load regular CMake files
    get_solis_targets(_targets CMAKE)
    list(LENGTH _targets _n_targets)
    if (_n_targets GREATER 0)
        # Write header
        __solis_add_header("${PROJECT_NAME} CMAKE targets")
        # Include exported target file
        foreach(_cmake_file ${_targets})
            __solis_add_config_line("include(\"\${CMAKE_CURRENT_LIST_DIR}/${_cmake_file}\")")
        endforeach()
    endif()
endfunction()

# =============================================================================
# UTIL: Append a line to the config file
#
# Author: Meltwin
# Since : 1.0.0
# =============================================================================
function(__solis_add_config_line _line)
    # Write header
    file(APPEND ${PROJECT_ROOT_CONFIG_FILE_RAW} "${_line}\n")
endfunction()

# =============================================================================
# UTIL: Append an header to the config file
#
# Author: Meltwin
# Since : 1.0.0
# =============================================================================
function(__solis_add_header _text)
    # Write header
    center_text("${_text}" 77 _header CHAR "-")
    __solis_add_config_line("\n# ${_header}")
endfunction()
