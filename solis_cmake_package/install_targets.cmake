# =============================================================================
# Project: SOLIS_CMAKE
# 
# This file contains the several functions used to install the diverse targets
# define in the project.
# 
# Author    Meltwin (github@meltwin.fr)
# Date      18/10/2025 (created 17/10/2025)
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
      install(FILES ${_cmake_file} DESTINATION "${CMAKE_INSTALL_DATAROOTDIR}/${PROJECT_NAME}/share/${PROJECT_NAME}/${_cmake_dir}")
    endforeach()
  endif()
endfunction()

# =============================================================================
# Export the project's CXX targets
#
# Author: Meltwin
# Since 0.0.1
# =============================================================================
function(_solis_install_cxx)
  get_solis_targets(_targets CXX_EXE CXX_LIB)
  list(LENGTH _targets _length)
  if (_length GREATER 0)
    log_step("Exporting CXX targets (${_length} target)")
    install(TARGETS ${_targets}
      EXPORT "${PROJECT_NAME}Targets"
      LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
      ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
      RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
      INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/${PROJECT_NAME}
      PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/include
      BUNDLE DESTINATION ${CMAKE_INSTALL_BINDIR}
    )
    # Export package's targets files
    export(EXPORT "${PROJECT_NAME}Targets"
      FILE "${PROJECT_BINARY_DIR}/share/${PROJECT_NAME}/cmake/${PROJECT_NAME}Targets.cmake"
    )
    install(EXPORT "${PROJECT_NAME}Targets"
        DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/${PROJECT_NAME}/share/${PROJECT_NAME}
    )
  endif()
endfunction()