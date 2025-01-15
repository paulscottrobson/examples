cmake_minimum_required(VERSION 3.16.3)

#Note this line must be before project!
set(CMAKE_TOOLCHAIN_FILE ./cc65-toolchain.cmake)

project(x65-examples ASM C)

function(ADD_XEX executable_name)
    add_executable(${executable_name})
    target_link_options(${executable_name} PUBLIC
        -C ${CMAKE_SOURCE_DIR}/x65.cfg
        -Ln ${CMAKE_CURRENT_BINARY_DIR}/${executable_name}.lab
        --mapfile ${CMAKE_CURRENT_BINARY_DIR}/${executable_name}.map
    )
    set_target_properties(${executable_name} PROPERTIES
        OUTPUT_NAME ${executable_name} SUFFIX ".xex"
    )
endfunction()

add_subdirectory(src)
