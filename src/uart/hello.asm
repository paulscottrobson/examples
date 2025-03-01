.segment "INFO"
    .byte "Hello UART"

.segment "VECTORS"
    .word 0, 0, 0, 0, 0, 0, 0, 0
    .word 0, 0, 0, 0, 0, 0, reset, 0

.segment "CODE"

reset:
LDX #$00   ; X = 0
loop:
BIT $FFE0  ; N = ready to send
BPL loop   ; If N = 0 goto loop
LDA text,X ; A = text[X]
STA $FFE1  ; UART Tx A
INX        ; X = X + 1
CMP #$00   ; if A - 0 ...
BNE loop   ; ... != 0 goto loop
LDA #$FF   ; A = 255, OS exit()
STA $FFF1  ; Halt CPU
text:
.BYTE "Hello, World!"
.BYTE $0D, $0A, $00
