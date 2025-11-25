# =============================================================================
# Project: SOLIS_CMAKE
# 
# Definition of C/C++ targets
# 
# Author    Meltwin (github@meltwin.fr)
# Date      25/11/2025 (created 25/11/2025)
# Version   1.0.0
# Copyright Solis Forge | 2025 
#           Distributed under MIT License (https://opensource.org/licenses/MIT)
# =============================================================================

set(CPP_SOURCE_EXT ".cpp" ".cxx" ".c")
set(CPP_HEADER_EXT ".hpp" ".hxx" ".h")

set(_SOLIS_INCLUDE_ARGS "PUBLIC_HEADER;PRIVATE_HEADER;HEADER_BASE_DIR")

# =============================================================================
# Register a target to compile a C/C++ executable
#
# Author: Meltwin
# Since : 1.0.0
# =============================================================================
function(add_solis_executable _target)
    cmake_parse_arguments(PARSE_ARGV 0 "" "" "" "FILES;DIRECTORIES;DEPENDS;${_SOLIS_INCLUDE_ARGS}")
    get_args_partition(_include_args ${_SOLIS_INCLUDE_ARGS})
    
    log_step("Registering CXX executable \"${_target}\"")
    get_files(src_files EXT ${CPP_SOURCE_EXT} ${CPP_HEADER_EXT} FILE ${_FILES} DIRECTORY ${_DIRECTORIES})
    if (NOT "${src_files}" STREQUAL "")
        # Configure executable
        add_executable(${_target} ${src_files})
        add_target_dependencies(${_target} DEPENDS ${_DEPENDS})
        set_target_includes(${_target} ${_include_args})

        # Register executable to be exported
        register_solis_target(CXX_EXE "${_target}")
    else()
        log_error("No source files found in the given FILES and DIRECTORIES tags for target \"${_target}\"")
    endif()   
endfunction()

set(DEFAULT_HEADER_EXPORT_DIR "${PROJECT_NAME}")
define_property(TARGET PROPERTY HEADER_EXPORT_DIR INITIALIZE_FROM_VARIABLE DEFAULT_HEADER_EXPORT_DIR)

# =============================================================================
# Register a target to compile a C/C++ executable
#
# Author: Meltwin
# Since : 1.0.0
# =============================================================================
function(add_solis_library _target)
    cmake_parse_arguments(PARSE_ARGV 0 "" "SHARED" "NAMESPACE;HEADER_DIR;${_SOLIS_INCLUDE_ARGS}" "FILES;DIRECTORIES;DEPENDS")
    get_args_partition(_include_args ${_SOLIS_INCLUDE_ARGS})
        
    # Get source files for library
    get_files(src_files EXT ${CPP_SOURCE_EXT} FILE ${_FILES} DIRECTORY ${_DIRECTORIES})
    if ("${src_files}" STREQUAL "")
        log_step("Registering CXX library \"${_target}\" (INTERFACE)")
        _solis_mk_interface(${_target} ${_include_args})
    elseif(${_SHARED})
        log_step("Registering CXX library \"${_target}\" (SHARED)")   
        _solis_mk_shared_lib(${_target} ${_include_args} SOURCES ${src_files} )
    else()
        log_step("Registering CXX library \"${_target}\" (STATIC)")
        _solis_mk_static_lib(${_target} ${_include_args} SOURCES ${src_files} )
    endif()   

    # Configure library
    register_solis_target(CXX_LIB "${_target}")
    add_target_dependencies(${_target} DEPENDS ${_DEPENDS})
    set(target_export_dir "${PROJECT_NAME}")
    if (_HEADER_DIR)
        set(target_export_dir "${_HEADER_DIR}")
    endif()
    log_debug("Configuring header export directory to ${target_export_dir}")
    set_target_properties(${_target} PROPERTIES HEADER_EXPORT_DIR ${target_export_dir})


    # Register library to be exported
    solis_namespace(_ns TARGET ${_target} SET ${_NAMESPACE})
    set(lib_alias "${_ns}::${_target}")
    log_debug("Exporting library as ${lib_alias}")
    add_library(${lib_alias} ALIAS ${_target})
    set_target_properties(${_target} PROPERTIES OUTPUT_NAME "${_ns}_${_target}")
    set_target_properties(${_target} PROPERTIES EXPORT_NAME ${lib_alias})
endfunction()


# =============================================================================
# Create an interface library
#
# Author: Meltwin
# Since : 1.0.0
# =============================================================================
function(_solis_mk_interface _target)
    cmake_parse_arguments("" "" "" "" ${ARGN})

    # Make library
    add_library(${_target} INTERFACE)
    set_target_includes(${_target} INTERFACE ${_UNPARSED_ARGUMENTS})
endfunction()

# =============================================================================
# Create an shared library
#
# Author: Meltwin
# Since : 1.0.0
# =============================================================================
function(_solis_mk_shared_lib)
    cmake_parse_arguments("" "" "" "SOURCES" ${ARGN})
    log_debug("Argn ${ARGN}")

    # Make library
    add_library(${_target} SHARED ${_SOURCES})
    set_target_includes(${_target} ${_UNPARSED_ARGUMENTS})
endfunction()

# =============================================================================
# Create an static library
#
# Author: Meltwin
# Since : 1.0.0
# =============================================================================
function(_solis_mk_static_lib)
    cmake_parse_arguments("" "" "" "SOURCES" ${ARGN})

    # Make library
    add_library(${_target} STATIC ${_SOURCES})
    set_target_includes(${_target} ${_UNPARSED_ARGUMENTS})
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


set(_SOLIS_PUB_HDRS_SET "pub_headers")

# =============================================================================
# Setup the include directories for the target.
#
# Author: Meltwin
# Since : 1.0.0
# =============================================================================
function(set_target_includes _target) 
    log_debug("Argn ${ARGN}")
    cmake_parse_arguments("" "INTERFACE" "" "${_SOLIS_INCLUDE_ARGS}" ${ARGN})

    # Process interface special case
    if (_INTERFACE) 
        get_files(headers_files EXT ${CPP_HEADER_EXT} DIRECTORY ${_PUBLIC_HEADER} ${_PRIVATE_HEADER})
        target_sources(
            ${_target}
            INTERFACE
            FILE_SET "${_SOLIS_PUB_HDRS_SET}"
                TYPE HEADERS
                FILES ${headers_files}
                BASE_DIRS "${_HEADER_BASE_DIR}"
        )
        return()
    endif()

    log_debug("Include ${_PUBLIC_HEADER}")

    # Add public headers for target
    foreach(include_obj ${_PUBLIC_HEADER})
        if (IS_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/${include_obj}")
            log_debug("Linking include dir ${include_obj} for target \"${_target}\"")
            target_include_directories(${_target} PUBLIC 
                $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/${include_obj}> 
                $<INSTALL_INTERFACE:${include_obj}>
            )            
        else()
            target_sources(
                ${_target}
                PUBLIC
                FILE_SET ${_SOLIS_PUB_HDRS_SET}
                    TYPE HEADERS
                    FILES "${include_obj}"
                    BASE_DIRS ${_HEADER_BASE_DIR}
            )
        endif()
    endforeach()

    # Add private headers for target
    foreach(include_obj ${_PRIVATE_HEADER})
        if (IS_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/${include_obj}")
            target_include_directories(${_target} PRIVATE 
                $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/${include_obj}> 
                $<INSTALL_INTERFACE:${include_obj}>
            )            
        else()
            target_sources(
                ${_target}
                PRIVATE
                FILES "${include_obj}"
            )
        endif()
    endforeach()
endfunction()