.include "../cgia.asm"

.segment "INFO"
    .byte "LukHash - Raster Bar picture"

.segment "CODE"
.smart

.org $4000

start:
    sep #%00110000
restart:
    ldx #150
    ldy #0

l:  cpx CGIA::raster
    bne l

    lda colors_tab, y
    sta CGIA::back_color

    inx
    iny

    cpx #214
    bne l

    ldx #150
    ldy #0

    lda #181
    sta CGIA::back_color

    bra restart
    ; 4C 00 40         jmp start

colors_tab:
    .byte 179, 178, 178, 178, 181, 178, 181, 181, 181, 178, 181, 181, 181, 181
    .byte 141, 157, 165, 85, 85, 85, 78, 85, 78, 78, 78, 78, 71, 7, 79, 71, 7, 7, 7, 7
    .byte 78, 79, 7, 78, 78, 78, 78, 85, 85, 78, 85, 85, 84
    .byte 173, 141, 181, 181, 181, 181, 178, 181, 181, 181, 178, 181, 179, 178, 178, 178
