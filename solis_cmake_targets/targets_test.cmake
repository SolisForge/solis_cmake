# =============================================================================
# Project: SOLIS_CMAKE
# 
# CMake functions related to test definition.
# 
# Author    Meltwin (github@meltwin.fr)
# Date      12/12/2025 (created 12/12/2025)
# Version   1.0.0
# Copyright Solis Forge | 2025 
#           Distributed under MIT License (https://opensource.org/licenses/MIT)
# =============================================================================

set(_SOLIS_TESTS_TYPE "PYTHON;CPP")

# =============================================================================
# Compile and add a test step to be run by CTest
#
# Author: Meltwin
# Since : 1.0.0
# =============================================================================
function(add_solis_test _target)
    # If tests are disabled
    if (NOT ${COMPILE_TESTS})
        return()
    endif()

    # Make the right type of test
    cmake_parse_arguments(PARSE_ARGV 1 "" "${_SOLIS_TESTS_TYPE}" "" "")
    if (${_CPP})
        _add_solis_cpp_test(${_target} ${_UNPARSED_ARGUMENTS})
    elseif(${_PYTHON})
        _add_solis_python_test(${_target} ${_UNPARSED_ARGUMENTS})
    else()
        log_error("No test type provided for test ${_target} (available=${_SOLIS_TESTS_TYPE})")
    endif()
endfunction()

# =============================================================================
# Compile and registere a C++ test to be run by CTest
#
# Author: Meltwin
# Since : 1.0.0
# =============================================================================
function(_add_solis_cpp_test _target)
    log_step("Registering test \"${_target}\" (C++)")
    cmake_parse_arguments(PARSE_ARGV 0 "" "" "" "")
    add_solis_executable("test_${_target}" ${_UNPARSED_ARGUMENTS} NO_EXPORT)
    add_test(NAME ${_target} COMMAND "test_${_target}")
endfunction()

# =============================================================================
# Compile and registere a Python test to be run by CTest
#
# Author: Meltwin
# Since : 1.0.0
# =============================================================================
function(_add_solis_python_test _target)
    log_step("Registering test \"${_target}\" (PYTHON)")
    cmake_parse_arguments(PARSE_ARGV 1 "" "" "" "DIRECTORY")
    log_output("ARGN ${ARGN} (${_UNPARSED_ARGUMENTS}) => ${_DIRECTORY}"  )

    if ("${_DIRECTORY}" STREQUAL "")
        log_warning("Python test ${_target} does not have any directory given!")
        return()
    endif()

    # Register the tests directories with a unique name
    set(index 0)
    foreach(dir ${_DIRECTORY})
        add_test(
            NAME "${_target}_${index}" 
            COMMAND python3 -m unittest discover "${CMAKE_CURRENT_SOURCE_DIR}/${_DIRECTORY}"
            WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/${_DIRECTORY}"
        )    
        math(EXPR index "${index} + 1")
    endforeach()
endfunction()