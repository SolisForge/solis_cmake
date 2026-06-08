# =============================================================================
# Project: SOLIS_CMAKE
# 
# Definition of C/C++ targets
# 
# Author    Meltwin (github@meltwin.fr)
# Date      08/06/2026 (created 26/12/2025)
# Version   1.0.0
# Copyright Solis Forge | 2025 
#           Distributed under MIT License (https://opensource.org/licenses/MIT)
# =============================================================================

set(CPP_SOURCE_EXT ".cpp" ".cxx" ".c")
set(CPP_HEADER_EXT ".hpp" ".hxx" ".h")

set(_SOLIS_CPP_TARGETS_FLAGS "NO_EXPORT")
set(_SOLIS_CPP_TARGETS_ARGS "FILES;DIRECTORIES;DEPENDS")
set(_SOLIS_INCLUDE_ARGS "PUBLIC_HEADER;PRIVATE_HEADER;HEADER_BASE_DIR")

# =============================================================================
# Register a target to compile a C/C++ executable
#
# Author: Meltwin
# Since : 1.0.0
# =============================================================================
function(add_solis_executable _target)
    cmake_parse_arguments(PARSE_ARGV 0 "" "${_SOLIS_CPP_TARGETS_FLAGS}" "${_SOLIS_INCLUDE_ARGS}" "${_SOLIS_CPP_TARGETS_ARGS}")
    get_args_partition(_include_args ${_SOLIS_INCLUDE_ARGS})
    
    log_step("Registering CXX executable \"${_target}\"")
    get_files(src_files EXT ${CPP_SOURCE_EXT} ${CPP_HEADER_EXT} FILE ${_FILES} DIRECTORY ${_DIRECTORIES})
    if ("${src_files}" STREQUAL "")
        log_error("No source files found in the given FILES and DIRECTORIES tags for target \"${_target}\"")
    endif()

    # Configure executable
    add_executable(${_target} ${src_files})
    add_target_dependencies(${_target} DEPENDS ${_DEPENDS})
    set_target_includes(${_target} ${_include_args})

    # Register executable to be exported
    if (${_NO_EXPORT})
        log_debug("Executable ${_target} is INTERNAL")
    else()
        log_debug("Executable ${_target} is EXPORTED")
        register_solis_target(CXX_EXE "${_target}")  
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
    cmake_parse_arguments(PARSE_ARGV 0 "" 
        "${_SOLIS_CPP_TARGETS_FLAGS};SHARED" 
        "NAMESPACE;${_SOLIS_INCLUDE_ARGS}" 
        "${_SOLIS_CPP_TARGETS_ARGS}"
    )
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
    add_target_dependencies(${_target} DEPENDS ${_DEPENDS})

    # Register library to be exported
    if (${_NO_EXPORT})
        log_debug("Library ${_target} is INTERNAL")
    else()
        solis_namespace(_ns TARGET ${_target} SET "${_NAMESPACE}")
        set(lib_alias "${_ns}::${_target}")
        log_debug("Library ${_target} is EXPORTED as ${lib_alias}")
        add_library(${lib_alias} ALIAS ${_target})
        register_solis_target(CXX_LIB "${_target}")
        set_target_properties(${_target} PROPERTIES OUTPUT_NAME "${_ns}_${_target}")
        set_target_properties(${_target} PROPERTIES EXPORT_NAME ${lib_alias})
    endif()
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
    cmake_parse_arguments("" "INTERFACE" "" "${_SOLIS_INCLUDE_ARGS}" ${ARGN})

    # Process interface special case
    if (_INTERFACE) 
        get_files(headers_files EXT ${CPP_HEADER_EXT} DIRECTORY ${_PUBLIC_HEADER} ${_PRIVATE_HEADER})
        foreach(include_obj ${headers_files})
            get_filename_component(base_dir "${CMAKE_CURRENT_SOURCE_DIR}/${include_obj}" DIRECTORY)
            target_sources(
                ${_target}
                INTERFACE
                FILE_SET ${_SOLIS_PUB_HDRS_SET}
                    TYPE HEADERS
                    FILES "${include_obj}"
                    BASE_DIRS "${_HEADER_BASE_DIR}"
            )
        endforeach()
        return()
    endif()

    # Add public headers for target
    foreach(include_obj ${_PUBLIC_HEADER})
        if (IS_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/${include_obj}")
            log_debug("Linking include dir ${include_obj} for target \"${_target}\"")
            target_include_directories(${_target} PUBLIC 
                $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/${include_obj}> 
                $<INSTALL_INTERFACE:${include_obj}>
            )            
        else()
            get_filename_component(base_dir "${CMAKE_CURRENT_SOURCE_DIR}/${include_obj}" DIRECTORY)
            target_sources(
                ${_target}
                PUBLIC
                FILE_SET ${_SOLIS_PUB_HDRS_SET}
                    TYPE HEADERS
                    FILES "${include_obj}"
                    BASE_DIRS "${_HEADER_BASE_DIR}"
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