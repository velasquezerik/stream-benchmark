cmake_minimum_required(VERSION 3.0.0)

project(StreamBechmark VERSION 1.0.0 LANGUAGES C CXX)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/bin)


if(STREAM_ARRAY_SIZE)
    add_definitions(-DSTREAM_ARRAY_SIZE=${STREAM_ARRAY_SIZE})
endif()

if(NTIMES)
    add_definitions(-DNTIMES=${NTIMES})
endif()

# we default to Release build type
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "Release")
endif()

# Intel compiler
if(CMAKE_C_COMPILER_ID MATCHES Intel)
    set(CMAKE_C_FLAGS         "${CMAKE_C_FLAGS} -Wall ")
    set(CMAKE_C_FLAGS_DEBUG   "-g -traceback")
    set(CMAKE_C_FLAGS_RELEASE "-O3 -xHost")
endif()

# GNU Compiler
if(CMAKE_C_COMPILER_ID MATCHES GNU)
    set(CMAKE_C_FLAGS         "${CMAKE_C_FLAGS} ")
    set(CMAKE_C_FLAGS_DEBUG   "")
    set(CMAKE_C_FLAGS_RELEASE "-O3")
endif()

# create single thread
add_executable(stream_single src/stream.c)

# OpenMP Package
find_package(OpenMP)
if (OPENMP_FOUND)
    # create openmp
    add_executable(stream_multi src/stream.c)
    target_link_libraries(stream_multi PRIVATE "${OpenMP_C_FLAGS}")
    target_compile_options(stream_multi PRIVATE "${OpenMP_C_FLAGS}")
endif()