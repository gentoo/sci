cmake_minimum_required (VERSION 2.8)
project (Redcat)

find_package(Eigen3 REQUIRED)

include_directories (${Redcat_SOURCE_DIR}/src)
include_directories (${EIGEN3_INCLUDE_DIR})

add_executable (Redcat src/main.cpp src/Redcat.cpp src/tensor.cpp src/matrix.cpp src/SVDiface.cpp)
add_executable (Dynamic src/Dynamic.cpp)

install (TARGETS Redcat Dynamic DESTINATION bin)

