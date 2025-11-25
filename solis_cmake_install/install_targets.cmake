# =============================================================================
# Project: SOLIS_CMAKE
# 
# This file contains the several functions used to install the diverse targets
# define in the project.
# 
# Author    Meltwin (github@meltwin.fr)
# Date      25/11/2025 (created 25/11/2025)
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
  # Get all CMake files to install
  get_solis_targets(_targets CMAKE CMAKE_NOLOAD)
  list(LENGTH _targets _length)
  if (_length GREATER 0)
    log_step("Exporting CMake files (${_length} files)")
    # Install each file independently to keep folder hierarchy
    foreach (_cmake_file ${_targets} )
      get_filename_component( _cmake_dir ${_cmake_file} DIRECTORY )
      install(FILES ${_cmake_file} DESTINATION "${PROJECT_INSTALL_CMAKEDIR}/${_cmake_dir}")
    endforeach()
  endif()
endfunction()

# =============================================================================
# Export the project's CXX targets
#
# Author: Meltwin
# Since : 1.0.0
# =============================================================================
function(_solis_install_cxx)
  get_solis_targets(_targets CXX_EXE CXX_LIB)
  list(LENGTH _targets _length)
  
  if (_length GREATER 0)
    log_step("Exporting CXX targets (${_length} target)")

    # Install targets
    foreach( _target ${_targets})
        log_debug("Setup installation of target ${_target}")

        # Get target custom property
        get_target_property(header_export_dir ${_target} HEADER_EXPORT_DIR)

        install(TARGETS ${_target}
            EXPORT "${PROJECT_NAME}Targets"
            # Target export
            LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
            ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
            RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
            BUNDLE DESTINATION ${CMAKE_INSTALL_BINDIR} # MacOS
            # Header files
            INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/${header_export_dir}
            PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/${header_export_dir}
            FILE_SET ${_SOLIS_PUB_HDRS_SET}  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/${header_export_dir}
        )
    endforeach()
    
    # Export package's targets files
    export(EXPORT "${PROJECT_NAME}Targets"
      FILE "${PROJECT_BINARY_DIR}/share/${PROJECT_NAME}/cmake/${PROJECT_NAME}Targets.cmake"
    )
    install(EXPORT "${PROJECT_NAME}Targets"
        DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/${PROJECT_NAME}
    )
  endif()
endfunction()

# =============================================================================
# Export the project's Python modules
#
# Author: Meltwin
# Since : 1.0.0
# =============================================================================
function(_solis_install_python_modules)
  # Get all Python modules to install
  get_solis_targets(_modules PY_MODULE)
  list(LENGTH _modules _length)
  if (_length GREATER 0)
    foreach (_py_module ${_modules})
      # Find target-path delimiter and get their values
      string(FIND "${_py_module}" "&" dlim_position)
      string(SUBSTRING "${_py_module}" 0 ${dlim_position} _target)
      string(LENGTH "${_py_module}" whole_length)
      math(EXPR path_start  "${dlim_position} + 1")
      math(EXPR path_length "${whole_length} - ${dlim_position} - 1")
      string(SUBSTRING "${_py_module}" ${path_start} ${path_length} _py_path)

      log_step("Exporting Python module \"${_target}\" from directory \"${_py_path}\"")

      # Exporting all files under the given directory into the Python package module
      install(
        DIRECTORY "${_py_path}/"
        DESTINATION "${PROJECT_INSTALL_PYTHONDIR}/${_target}"
      )
    endforeach()
  endif()
endfunction()

# =============================================================================
# Export the project's scripts
#
# Author: Meltwin
# Since : 1.0.0
# =============================================================================
function(_solis_install_scripts)
  # Get all platform-independant scripts to install
  get_solis_targets(_scripts SCRIPT)
  list(LENGTH _scripts _length)
  if (_length GREATER 0)
    install(
      PROGRAMS ${_scripts}
      DESTINATION ${CMAKE_INSTALL_BINDIR}
    )
  endif()

  # Platform-depend scripts
  if (WIN32)
    get_solis_targets(_scripts SCRIPT_WIN)
    list(LENGTH _scripts _length)
    if (_length GREATER 0)
      install(
        PROGRAMS ${_scripts}
        DESTINATION ${CMAKE_INSTALL_BINDIR}
      )
    endif()
  else()
    get_solis_targets(_scripts SCRIPT_LINUX)
    list(LENGTH _scripts _length)
    if (_length GREATER 0)
      install(
        PROGRAMS ${_scripts}
        DESTINATION ${CMAKE_INSTALL_BINDIR}
      )
    endif()
  endif()
endfunction()