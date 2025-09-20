# ==============================================================================
# Project: SOLIS_CMAKE
# 
# Configuration file for this project
# 
# Author    Meltwin (github@meltwin.fr)
# Date      16/09/2025 (created 16/09/2025)
# Version   1.0.0
# Copyright Solis Forge | 2025 
#           Distributed under MIT License (https://opensource.org/licenses/MIT)
# ==============================================================================

cmake_minimum_required(VERSION 3.25)
project(solis_cmake)

include(solis_cmake_utils/solis_cmake_utils.cmake)
include(solis_cmake_targets/solis_cmake_targets.cmake)

set(TEST1 "")
set(TEST2 "")
set(TEST3 "")
set(TEST4 "")

only_one_flag(out ${TEST1} ${TEST2} ${TEST3} ${TEST4})

message("Original function: ${out}")