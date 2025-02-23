.include "../ria.asm"

.segment "INFO"
    .byte "GPIO extender demo"

.import __MAIN_START__
.segment "VECTORS"
    .word 0, 0, 0, 0, 0, 0, 0, 0
    .word 0, 0, 0, 0, 0, 0, __MAIN_START__, irq

.setcpu "65C02"

.code
        cli     ; enable IRQ

loop:
        lda GPIO::in0
        sta $10
        lda GPIO::in1
        sta $11
        bra loop

irq:
        inc $12
        lda GPIO::in0
        lda GPIO::in1
        rti
