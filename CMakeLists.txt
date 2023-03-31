# This is generic CMakeLists for testing, please do not use

cmake_minimum_required(VERSION 3.10)

project (Target)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

file(GLOB SRC ${PROJECT_SOURCE_DIR}/*.cpp)

add_executable(target ${SRC})

target_include_directories(target PUBLIC ${PROJECT_SOURCE_DIR})
