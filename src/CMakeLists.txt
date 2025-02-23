include_directories(.)

add_xex(test816)
target_sources(test816 PRIVATE
    test816.asm
)

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
add_xex(sotb)
target_sources(sotb PRIVATE
    cgia/sotb.asm
)
add_xex(mixed_modes)
target_sources(mixed_modes PRIVATE
    cgia/mixed_modes.asm
)

add_xex(pwm_samples)
target_sources(pwm_samples PRIVATE
    cgia/pwm_samples.asm
)
add_xex(opl)
target_sources(opl PRIVATE
    sound/opl.asm
)

add_xex(hello_uart)
target_sources(hello_uart PRIVATE
    uart/hello.asm
)

add_xex(gpio)
target_sources(gpio PRIVATE
    io/gpio.asm
)
