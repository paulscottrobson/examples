.include "../cgia.asm"

.segment "INFO"
    .byte "Raster Interrupt demo"

.segment "VECTORS"
    .word 0, 0, 0, 0, 0, 0, 0, 0
    .word 0, 0, 0, 0, 0, nmi, reset, 0

.segment "CODE"

reset:
    sei                     ; disable IRQ

    lda #80
    sta CGIA::int_raster    ; set interrupt raster line to 80

    lda #%00100000
    sta CGIA::int_enable    ; trigger NMI on raster line

forever:
    jmp forever ; do nothing more

nmi:
    pha         ; save accumulator

    lda #$6b    ; green color
    sta CGIA::back_color

    lda #96
wait:
    cmp CGIA::raster    ; wait for raster line 96
    bne wait

    lda #$00    ; black color
    sta CGIA::back_color

    pla         ; restore accumulator
    sta CGIA::int_status    ; ack interrupts
    rti         ; return from interrupt
