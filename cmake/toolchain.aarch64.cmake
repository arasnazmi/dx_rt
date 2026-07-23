set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR aarch64)

# Load dxrt configuration to get USE_VNPU option
include(${CMAKE_CURRENT_LIST_DIR}/dxrt.cfg.cmake)

if (USE_VNPU)

    SET(TOOLCHAIN_PREFIX /opt/toolchain/gcc-arm-10.3-2021.07-x86_64-aarch64-none-linux-gnu)
    SET(CMAKE_C_COMPILER      ${TOOLCHAIN_PREFIX}/bin/aarch64-none-linux-gnu-gcc)
    SET(CMAKE_CXX_COMPILER    ${TOOLCHAIN_PREFIX}/bin/aarch64-none-linux-gnu-g++)
    SET(CMAKE_LINKER          ${TOOLCHAIN_PREFIX}/bin/aarch64-none-linux-gnu-ld)
    SET(CMAKE_NM              ${TOOLCHAIN_PREFIX}/bin/aarch64-none-linux-gnu-nm)
    SET(CMAKE_OBJCOPY         ${TOOLCHAIN_PREFIX}/bin/aarch64-none-linux-gnu-objcopy)
    SET(CMAKE_OBJDUMP         ${TOOLCHAIN_PREFIX}/bin/aarch64-none-linux-gnu-objdump)
    SET(CMAKE_RANLIB          ${TOOLCHAIN_PREFIX}/bin/aarch64-none-linux-gnu-ranlib)
    #message("ARM64 Cross-Compile for VNPU")

elseif(EXISTS ${CMAKE_SOURCE_DIR}/toolchains/toolchain/bin/aarch64-none-linux-gnu-gcc)

    # T3 Gemstone toolchain bundled in ./toolchains
    SET(TOOLCHAIN_PREFIX ${CMAKE_SOURCE_DIR}/toolchains/toolchain)
    SET(CMAKE_SYSROOT         ${CMAKE_SOURCE_DIR}/toolchains/sysroot)
    SET(CMAKE_C_COMPILER      ${TOOLCHAIN_PREFIX}/bin/aarch64-none-linux-gnu-gcc)
    SET(CMAKE_CXX_COMPILER    ${TOOLCHAIN_PREFIX}/bin/aarch64-none-linux-gnu-g++)
    SET(CMAKE_LINKER          ${TOOLCHAIN_PREFIX}/bin/aarch64-none-linux-gnu-ld)
    SET(CMAKE_NM              ${TOOLCHAIN_PREFIX}/bin/aarch64-none-linux-gnu-nm)
    SET(CMAKE_OBJCOPY         ${TOOLCHAIN_PREFIX}/bin/aarch64-none-linux-gnu-objcopy)
    SET(CMAKE_OBJDUMP         ${TOOLCHAIN_PREFIX}/bin/aarch64-none-linux-gnu-objdump)
    SET(CMAKE_RANLIB          ${TOOLCHAIN_PREFIX}/bin/aarch64-none-linux-gnu-ranlib)

    # The bundled ARM toolchain does not know Debian/Ubuntu multiarch layout,
    # so point it explicitly at the aarch64-linux-gnu sub-directories in the sysroot.
    set(_DXRT_LINK_DIRS "-L${CMAKE_SYSROOT}/lib/aarch64-linux-gnu -L${CMAKE_SYSROOT}/usr/lib/aarch64-linux-gnu")
    # Put -L into the compiler flags too so CMake's compiler test (which links) also finds libc.
    set(CMAKE_C_FLAGS_INIT   "-isystem ${CMAKE_SYSROOT}/usr/include/aarch64-linux-gnu ${_DXRT_LINK_DIRS}")
    set(CMAKE_CXX_FLAGS_INIT "-isystem ${CMAKE_SYSROOT}/usr/include/aarch64-linux-gnu ${_DXRT_LINK_DIRS}")
    set(CMAKE_EXE_LINKER_FLAGS_INIT    "${_DXRT_LINK_DIRS}")
    set(CMAKE_SHARED_LINKER_FLAGS_INIT "${_DXRT_LINK_DIRS}")
    set(CMAKE_MODULE_LINKER_FLAGS_INIT "${_DXRT_LINK_DIRS}")

    # Resolve libraries/headers from the sysroot, tools from the host
    set(CMAKE_FIND_ROOT_PATH ${CMAKE_SYSROOT})
    set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
    set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
    set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
    set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
    #message("ARM64 Cross-Compile with bundled T3 Gemstone toolchain")

else()

    SET(CMAKE_C_COMPILER      /usr/bin/aarch64-linux-gnu-gcc )
    SET(CMAKE_CXX_COMPILER    /usr/bin/aarch64-linux-gnu-g++ )
    SET(CMAKE_LINKER          /usr/bin/aarch64-linux-gnu-ld  )
    SET(CMAKE_NM              /usr/bin/aarch64-linux-gnu-nm )
    SET(CMAKE_OBJCOPY         /usr/bin/aarch64-linux-gnu-objcopy )
    SET(CMAKE_OBJDUMP         /usr/bin/aarch64-linux-gnu-objdump )
    SET(CMAKE_RANLIB          /usr/bin/aarch64-linux-gnu-ranlib )
    #message("ARM64 Cross-Compile")

endif()

set(onnxruntime_LIB_DIRS ${CMAKE_SOURCE_DIR}/util/onnxruntime_aarch64/lib)
set(onnxruntime_INCLUDE_DIRS ${CMAKE_SOURCE_DIR}/util/onnxruntime_aarch64/include)