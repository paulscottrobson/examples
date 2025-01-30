.union CGIA_PLANE_REGS
    .struct CGIA_BCKGND_REGS
        flags           .byte
        border_columns  .byte
        row_height      .byte
        stride          .byte
        scroll_x        .byte
        offset_x        .byte
        scroll_y        .byte
        offset_y        .byte
        shared_color    .byte 2
    .endstruct
    .struct CGIA_HAM_REGS
        flags           .byte
        border_columns  .byte
        row_height      .byte
        reserved        .byte 5
        base_color      .byte 8
    .endstruct
    .struct CGIA_AFFINE_REGS
        flags           .byte
        border_columns  .byte
        row_height      .byte
        texture_bits    .byte   ; 2-0 texture_width_bits, 6-4 texture_height_bits
        u               .word
        v               .word
        du              .word
        dv              .word
        dx              .word
        dy              .word
    .endstruct
    .struct CGIA_SPRITE_REGS
        active          .byte   ;bitmask for active sprites
        border_columns  .byte
        start_y         .byte
        stop_y          .byte
    .endstruct
.endunion

.struct CGIA_PWM
    freq    .word
    duty    .byte
            .byte
.endstruct

.struct CGIA
                .org    $FF00

    mode        .byte
    bckgnd_bank .byte
    sprite_bank .byte
                .byte (16-3)    ; reserved

                .word           ; reserved
    raster      .byte
                .byte (16-3)    ; reserved

    pwm0        .tag CGIA_PWM
    pwm1        .tag CGIA_PWM
                .tag CGIA_PWM ; reserved
                .tag CGIA_PWM ; reserved

    planes      .byte        ; [TTTTEEEE] EEEE - enable bits, TTTT - type (0 bckgnd, 1 sprite)
    back_color  .byte
                .byte (8-2)   ; reserved
    offset0     .word   ; // DisplayList or SpriteDescriptor table start
    offset1     .word
    offset2     .word
    offset3     .word
    plane0      .tag CGIA_PLANE_REGS
    plane1      .tag CGIA_PLANE_REGS
    plane2      .tag CGIA_PLANE_REGS
    plane3      .tag CGIA_PLANE_REGS
.endstruct
