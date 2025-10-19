# =============================================================================
# Project: SOLIS_CMAKE
# 
# Definition of C/C++ targets
# 
# Author    Meltwin (github@meltwin.fr)
# Date      18/10/2025 (created 18/10/2025)
# Version   1.0.0
# Copyright Solis Forge | 2025 
#           Distributed under MIT License (https://opensource.org/licenses/MIT)
# =============================================================================

# =============================================================================
# Register a target to compile a C/C++ executable
#
# Author: Meltwin
# Since : 1.0.0
# =============================================================================
function(add_solis_executable _target)
    cmake_parse_arguments("" "" "" "FILES;DIRECTORIES;DEPENDS;INCLUDES;INCLUDES_RAW" ${ARGN})
    
    log_step("Registering CXX executable \"${_target}\"")
    get_files(src_files EXT ".cpp" ".cxx" ".c" FILE ${_FILES} DIRECTORY ${_DIRECTORIES})
    if (NOT "${src_files}" STREQUAL "")
        # Configure executable
        add_executable(${_target} ${src_files})
        add_target_dependencies(${_target} DEPENDS ${_DEPENDS})
        set_target_includes(${_target} INCLUDES "${_INCLUDES}" INCLUDES_RAW "${_INCLUDES_RAW}")

        # Register executable to be exported
        register_solis_target(CXX_EXE "${_target}")
    else()
        log_error("No source files found in the given FILES and DIRECTORIES tags")
    endif()   
endfunction()

# =============================================================================
# Register a target to compile a C/C++ executable
#
# Author: Meltwin
# Since : 1.0.0
# =============================================================================
function(add_solis_library _target)
    cmake_parse_arguments("" "" "" "FILES;DIRECTORIES;DEPENDS;INCLUDES;INCLUDES_RAW" ${ARGN})
    
    log_step("Registering CXX library \"${_target}\"")
    get_files(src_files EXT ".cpp" ".cxx" ".c" FILE ${_FILES} DIRECTORY ${_DIRECTORIES})
    if ("${src_files}" STREQUAL "")
        set(BUILD_ARGS "INTERFACE")
    endif()   

    # Configure library
    add_library(${_target} ${src_files} ${BUILD_ARGS})
    add_target_dependencies(${_target} DEPENDS ${_DEPENDS})
    set_target_includes(${_target} INCLUDES "${_INCLUDES}" INCLUDES_RAW "${_INCLUDES_RAW}" ${BUILD_ARGS})

    # Register library to be exported
    register_solis_target(CXX_LIB "${_target}")
endfunction()

# =============================================================================
# Setup the library dependencies for the target.
#
# Author: Meltwin
# Since : 1.0.0
# =============================================================================
function(add_target_dependencies _target) 
  cmake_parse_arguments("" "" "" "DEPENDS" ${ARGN})
  if (_FUNC_ARG_DEPENDS)
    target_link_libraries(${_target} PUBLIC ${_DEPENDS})
  endif()
endfunction()

# =============================================================================
# Setup the include directories for the target.
#
# Author: Meltwin
# Since : 1.0.0
# =============================================================================
function(set_target_includes _target) 
  cmake_parse_arguments("" "INTERFACE" "" "INCLUDES;INCLUDES_RAW" ${ARGN})
  if (${_INTERFACE})
    set(BUILD_ARGS "INTERFACE")
  else()
    set(BUILD_ARGS "PUBLIC")
  endif()

  # Make parameters for target_include_directories function
  set(include_dirs "")
  foreach(id ${_FUNC_ARG_INCLUDES})
    cmake_path(APPEND include_dirs "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/${id}>$<INSTALL_INTERFACE:${id}>")
  endforeach()
  foreach(id ${_FUNC_ARG_INCLUDES_RAW})
    cmake_path(APPEND include_dirs "${CMAKE_CURRENT_SOURCE_DIR}/${id}")
  endforeach()

  # Include directory
  target_include_directories(${_target} ${BUILD_ARGS} ${include_dirs}) 
endfunction()