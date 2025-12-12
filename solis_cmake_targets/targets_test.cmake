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
    cmake_parse_arguments(ARGV 0 "" "${_SOLIS_TESTS_TYPE}" "" "")

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
    cmake_parse_arguments(ARGV 0 "" "${_SOLIS_TESTS_TYPE}" "" "")
    add_solis_executable("test_${_target}" ${_UNPARSED_ARGUMENTS})
    add_test(NAME ${_target} COMMAND "test_${_target}")
endfunction()

# =============================================================================
# Compile and registere a Python test to be run by CTest
#
# Author: Meltwin
# Since : 1.0.0
# =============================================================================
function(_add_solis_python_test _target)
    # TODO: implements unittest CTest running
endfunction()