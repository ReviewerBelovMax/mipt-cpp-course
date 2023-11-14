cmake_minimum_required(VERSION 3.20)

project(CPP-tasks)

set(REQUIRED_CXX_COMPILER "Clang")
set(CXX_COMPILER_MIN_VERSION 14.0)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

add_compile_options(-stdlib=libc++)
add_link_options(-stdlib=libc++)

set(CMAKE_CXX_CLANG_TIDY clang-tidy)

file(GLOB sum_product_sources ${PROJECT_SOURCE_DIR}/01-sum-product/*.cpp)
add_executable(sum_product ${sum_product_sources})

file(GLOB stack_sources ${PROJECT_SOURCE_DIR}/02-stack/*.cpp)
add_executable(stack ${stack_sources})

file(GLOB string_sources ${PROJECT_SOURCE_DIR}/03-string/*.cpp)
add_executable(string ${string_sources})