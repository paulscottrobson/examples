.include "../cgia.asm"

.segment "INFO"
    .byte "Raster Bars demo"

.segment "VECTORS"
    .word 0, 0, 0, 0, 0, 0, 0, 0
    .word 0, 0, 0, 0, 0, 0, reset, 0

.segment "CODE"

.define FRAME_DELAY 16

reset:
    sei     ; we do not use interrupts in this demo

    lda #0              ; start with black color
    ldx #FRAME_DELAY    ; init delay loop

forever:
    sta CGIA::back_color ; set background color
    ldy #1              ; wait for next line

wait:
    cpy CGIA::raster    ; check if we are on Y raster line
    bne wait            ; loop if not

    inc CGIA::back_color ; increase background color

    iny                 ; move to next raster line
    cpy #240            ; check if we reached line 240
    bcc wait            ; wait for next line if not

    ldy #0              ; will wait for line 0 again

    dex                 ; delay moving the bars
    bne forever
    ldx #FRAME_DELAY    ; reload delay

    ; inc                 ; start with next color
    clc
    adc #1

    jmp forever
