# =============================================================================
# Project: SOLIS_CMAKE
# 
# Definition of C/C++ targets
# 
# Author    Meltwin (github@meltwin.fr)
# Date      22/11/2025 (created 22/11/2025)
# Version   1.0.0
# Copyright Solis Forge | 2025 
#           Distributed under MIT License (https://opensource.org/licenses/MIT)
# =============================================================================

set(CPP_SOURCE_EXT ".cpp" ".cxx" ".c")
set(CPP_HEADER_EXT ".hpp" ".hxx" ".h")

# =============================================================================
# Register a target to compile a C/C++ executable
#
# Author: Meltwin
# Since : 1.0.0
# =============================================================================
function(add_solis_executable _target)
    cmake_parse_arguments("" "" "" "FILES;DIRECTORIES;DEPENDS;INCLUDES;INCLUDES_RAW" ${ARGN})
    
    log_step("Registering CXX executable \"${_target}\"")
    get_files(src_files EXT ${CPP_SOURCE_EXT} ${CPP_HEADER_EXT} FILE ${_FILES} DIRECTORY ${_DIRECTORIES})
    if (NOT "${src_files}" STREQUAL "")
        # Configure executable
        add_executable(${_target} ${src_files})
        add_target_dependencies(${_target} DEPENDS ${_DEPENDS})
        set_target_includes(${_target} INCLUDES "${_INCLUDES}" INCLUDES_RAW "${_INCLUDES_RAW}")

        # Register executable to be exported
        register_solis_target(CXX_EXE "${_target}")
    else()
        log_error("No source files found in the given FILES and DIRECTORIES tags for target \"${_target}\"")
    endif()   
endfunction()

# =============================================================================
# Register a target to compile a C/C++ executable
#
# Author: Meltwin
# Since : 1.0.0
# =============================================================================
function(add_solis_library _target)
    cmake_parse_arguments("" "SHARED" "NAMESPACE" "FILES;DIRECTORIES;DEPENDS;INCLUDES;INCLUDES_RAW" ${ARGN})
    
    # Get source files for library
    solis_namespace(_ns TARGET ${_target} SET ${_NAMESPACE})
    set(lib_alias "${_ns}::${_target}")
    get_files(src_files EXT ${CPP_SOURCE_EXT} FILE ${_FILES} DIRECTORY ${_DIRECTORIES})
    if ("${src_files}" STREQUAL "")
        set(BUILD_ARGS "INTERFACE")
        log_step("Registering CXX library \"${lib_alias}\" (INTERFACE)")
    else()
        # Is it a static or shared library ?
        if (${_SHARED})
            set(BUILD_ARGS "SHARED")
            log_step("Registering CXX library \"${lib_alias}\" (SHARED)")
        else()
            set(BUILD_ARGS "")
            log_step("Registering CXX library \"${lib_alias}\" (STATIC)")
        endif()
    endif()   
    get_files(headers_files EXT ${CPP_HEADER_EXT} DIRECTORY ${_DIRECTORIES})

    # Configure library
    add_library(${_target} ${BUILD_ARGS} ${src_files} ${headers_files})
    add_target_dependencies(${_target} DEPENDS ${_DEPENDS})
    set_target_includes(${_target} INCLUDES "${_INCLUDES}" INCLUDES_RAW "${_INCLUDES_RAW}" ${BUILD_ARGS})

    # Register library to be exported
    add_library(${lib_alias} ALIAS ${_target})
    set_target_properties(${_target} PROPERTIES OUTPUT_NAME "${_ns}_${_target}")
    set_target_properties(${_target} PROPERTIES EXPORT_NAME ${lib_alias})
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
  if (_DEPENDS)
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
  cmake_parse_arguments("" "INTERFACE;SHARED" "" "INCLUDES;INCLUDES_RAW" ${ARGN})
  if (${_INTERFACE})
    set(BUILD_ARGS "INTERFACE")
  else()
    set(BUILD_ARGS "PUBLIC")
  endif()

  # Make parameters for target_include_directories function
  set(include_dirs "")
  foreach(id ${_INCLUDES})
    cmake_path(APPEND include_dirs "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/${id}>$<INSTALL_INTERFACE:${id}>")
  endforeach()
  foreach(id ${_INCLUDES_RAW})
    cmake_path(APPEND include_dirs "${CMAKE_CURRENT_SOURCE_DIR}/${id}")
  endforeach()

  # Include directory
  target_include_directories(${_target} ${BUILD_ARGS} ${include_dirs}) 
endfunction()