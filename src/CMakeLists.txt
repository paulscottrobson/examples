include_directories(.)

add_xex(swboy)
target_sources(swboy PRIVATE
    cgia/swboy.c
    reset_vector.asm
)
add_xex(raster_bars)
target_sources(raster_bars PRIVATE
    cgia/raster_bars.asm
)
add_xex(vbl)
target_sources(vbl PRIVATE
    cgia/vbl.asm
)
add_xex(rsi)
target_sources(rsi PRIVATE
    cgia/rsi.asm
)
add_xex(sprites)
target_sources(sprites PRIVATE
    cgia/sprites.asm
)

add_xex(hello_uart)
target_sources(hello_uart PRIVATE
    uart/hello.asm
)
