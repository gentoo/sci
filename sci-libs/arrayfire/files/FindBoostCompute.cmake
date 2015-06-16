# Downloads and builds the Boost Compute library from github.com
# Defines the following variables
# * BoostCompute_FOUND           Flag for Boost Compute
# * BoostCompute_INCLUDE_DIR     Location of the Boost Compute headers


set(BoostCompute_INCLUDE_DIR "/usr/include/compute")
SET( BoostCompute_FOUND ON CACHE BOOL "BoostCompute Found" )


IF(NOT BoostCompute_FOUND)
    MESSAGE(FATAL_ERROR, "Boost.Compute not found! Clone Boost.Compute from https://github.com/kylelutz/compute.git")
ENDIF(NOT BoostCompute_FOUND)

MARK_AS_ADVANCED(
    BoostCompute_FOUND
    BoostCompute_INCLUDE_DIR
    )
