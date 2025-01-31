include_directories(.)

add_xex(swboy)
target_sources(swboy PRIVATE
    cgia/swboy.c
)

add_xex(raster_bars)
target_sources(raster_bars PRIVATE
    cgia/raster_bars.asm
)

add_xex(vbl)
target_sources(vbl PRIVATE
    cgia/vbl.asm
)
