.include "../cgia.asm"

.segment "INFO"
    .byte "VBL demo"

.segment "VECTORS"
    .word 0, 0, 0, 0, 0, 0, 0, 0
    .word 0, 0, 0, 0, 0, nmi, reset, 0

.segment "CODE"

reset:
    sei                     ; disable IRQ
    lda #%10000000
    sta CGIA::int_enable    ; trigger NMI on VBL
forever:
    jmp forever ; do nothing more

nmi:
    inc $00     ; run the frame counter
    bne :+
    inc $01     ; high byte of counter
:
    sta CGIA::int_status    ; ack interrupts
    rti         ; return from interrupt
