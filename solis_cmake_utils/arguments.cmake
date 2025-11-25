# =============================================================================
# Project: SOLIS_CMAKE
# 
# This file contains util CMake methods.
# 
# Author    Meltwin (github@meltwin.fr)
# Date      25/11/2025 (created 18/10/2025)
# Version   1.0.0
# Copyright Solis Forge | 2025 
#           Distributed under MIT License (https://opensource.org/licenses/MIT)
# =============================================================================

# =============================================================================
# Test if only one of the flag is ON.
#
# Author: Meltwin
# Since : 1.0.0
# =============================================================================
macro(check_one_flag)
    set(_N_FLAGS 0)
    set(_FLAGS "")

    # Test every flag
    foreach(flag ${ARGN})
      # If the parsed flag is true
      if (${${flag}})
        # If we already had one 
        math(EXPR _N_FLAGS "${_N_FLAGS}+1")
        list(APPEND _FLAGS "${flag}")
      endif()
    endforeach()

    # If there are too much flag
    if (${_N_FLAGS} EQUAL 0)
      log_error("Function does not have flag set")
    elseif(NOT ${_N_FLAGS} EQUAL 1)
      log_error("Function have more than one flag set: ${_FLAGS}")
    endif()

    # Clear scope from local variables
    unset(_N_FLAGS)
    unset(_FLAGS)
endmacro()

# =============================================================================
# Fetch the sources files from both directories and a file list.
#
# Author: Meltwin
# Since : 1.0.0
# =============================================================================
function(get_files src_out)
  cmake_parse_arguments("" "" "" "DIRECTORY;FILE;EXT" ${ARGN})
  set(src_files "")

  # Parse directories
  foreach(dir ${_DIRECTORY})
    foreach(ext ${_EXT})
      log_debug("Looking in ${PROJECT_SOURCE_DIR}/${dir}/**${ext}")
      file(GLOB_RECURSE src LIST_DIRECTORIES false RELATIVE ${PROJECT_SOURCE_DIR} CONFIGURE_DEPENDS "${PROJECT_SOURCE_DIR}/${dir}/**${ext}")
      list(APPEND src_files "${src}")
    endforeach()
  endforeach()

  # Parse files
  foreach(f ${_FILE})
    log_debug("Adding file ${f}")
  endforeach()
  list(APPEND src_files "${_FILE}")

  # Return the found files
  set(${src_out} "${src_files}" PARENT_SCOPE)
endfunction()