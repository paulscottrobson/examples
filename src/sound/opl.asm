; Written by https://github.com/karmic64/64vgmplay
; ca64 port for X65 by smoku

.include "../cgia.asm"

HAS_LOOP = 2

.segment "INFO"
    .byte "VGM player demo"

.import __MAIN_START__
.segment "VECTORS"
    .word 0, 0, 0, 0, 0, 0, 0, 0
    .word 0, 0, 0, 0, 0, 0, __MAIN_START__, 0

.struct
.org $f0
waitcnt     .res 1
dataptr     .res 2
waitptr     .res 2

irqa    .res 1
irqy    .res 1
irq1    .res 1
.endstruct

RIA_EXTIO = $FFF6

OPL2_ADDR = $FC00
OPL2_DATA = $FC01
OPL3_ADDR = $FC02
OPL3_DATA = $FC03

CIA_TA_LO = $FF98
CIA_TA_HI = $FF99
CIA_TB_LO = $FF9A
CIA_TB_HI = $FF9B
CIA_ICR   = $FF9D
CIA_CRA   = $FF9E
CIA_CRB   = $FF9F

SCREEN    = $0100

.setcpu "65C02"

;CLOCK = 985248  ;PAL
;CLOCK = 1022727 ;NTSC
CLOCK = 1000000 ;X65

.code
            lda #$7f
            sta CIA_ICR
            lda #<nmi
            sta $fffa
            lda #>nmi
            sta $fffb
            lda #<irq
            sta $fffe
            lda #>irq
            sta $ffff
            
            ; enable EXTIO bank0 (OPL3)
            ldx #1
            stx RIA_EXTIO
            
            ldx #0
            txa
:           stx OPL2_ADDR
            nop
            nop
            sta OPL2_DATA
            php
            plp
            php
            plp
            php
            plp
            php
            plp
            inx
            bne :-
            
;             ldx #0
;             lda #$20
; :           sta screen,x
;             sta screen+$100,x
;             sta screen+$200,x
;             sta screen+$300,x
;             inx
;             bne :-
            
            lda #<regdata
            sta dataptr
            lda #>regdata
            sta dataptr+1
            lda #<waitdata+4
            sta waitptr
            lda #>waitdata+4
            sta waitptr+1
            lda #1
            sta waitcnt
            
            lda #<(CLOCK/44100) * 2
            sta CIA_TA_LO
            lda #>(CLOCK/44100) * 2
            sta CIA_TA_HI
            lda waitdata
            sta CIA_TB_LO
            lda waitdata+1
            sta CIA_TB_HI
            lda #$11 ;tma runs every cycle
            sta CIA_CRA
            lda #$51 ;tmb runs every xx samples
            sta CIA_CRB
            lda waitdata+2 ;set wait period for next cycle
            sta CIA_TB_LO
            lda waitdata+3
            sta CIA_TB_HI
            
            lda CIA_ICR
            lda #$82
            sta CIA_ICR
            cli
            
            
mainloop:   lda #0
            sta CGIA::back_color
            
            lda dataptr
            tax
            and #$0f
            tay
            lda conv,y
            sta SCREEN+$03
            txa
            lsr
            lsr
            lsr
            lsr
            tay
            lda conv,y
            sta SCREEN+$02
            lda dataptr+1
            tax
            and #$0f
            tay
            lda conv,y
            sta SCREEN+$01
            txa
            lsr
            lsr
            lsr
            lsr
            tay
            lda conv,y
            sta SCREEN+$00
            
            
            lda waitptr
            tax
            and #$0f
            tay
            lda conv,y
            sta SCREEN+$09
            txa
            lsr
            lsr
            lsr
            lsr
            tay
            lda conv,y
            sta SCREEN+$08
            lda waitptr+1
            tax
            and #$0f
            tay
            lda conv,y
            sta SCREEN+$07
            txa
            lsr
            lsr
            lsr
            lsr
            tay
            lda conv,y
            sta SCREEN+$06
            
            
            
:           lda CIA_TB_LO
            pha
            lda CIA_TB_HI
            tax
            and #$0f
            tay
            lda conv,y
            sta SCREEN+$25
            txa
            lsr
            lsr
            lsr
            lsr
            tay
            lda conv,y
            sta SCREEN+$24
            pla
            tax
            and #$0f
            tay
            lda conv,y
            sta SCREEN+$27
            txa
            lsr
            lsr
            lsr
            lsr
            tay
            lda conv,y
            sta SCREEN+$26
            
            
            lda waitcnt
            beq :-
            dec waitcnt
            lda #$0f
            sta CGIA::back_color
            
getloop:    ldy #$00
            lda (dataptr),y
            cmp #$fe
            bcs next
            sta OPL2_ADDR
            iny
            lda (dataptr),y
            sta OPL2_DATA
            tya
            sec
            adc dataptr
            sta dataptr
            bcc getloop
            inc dataptr+1
            bcs getloop
            
next:       .if HAS_LOOP
                bne loopdata
            .else
                bne *
            .endif
            inc dataptr
            bne :+
            inc dataptr+1
:           beq :+
            jmp mainloop
:
loopdata:   .if HAS_LOOP
                lda #<regdata_loop
                sta dataptr
                lda #>regdata_loop
                sta dataptr+1
                beq :+
                jmp mainloop
:
            .endif
            
            
irq:        sta irqa
            sty irqy
            ldy #0
            lda (waitptr),y
            iny
            ora (waitptr),y
            beq _loop
            lda (waitptr),y
            sta CIA_TB_HI
            dey
            lda (waitptr),y
            sta CIA_TB_LO
            lda #2
            clc
            adc waitptr
            sta waitptr
            bcc _end
            inc waitptr+1
            bcs _end
_loop:      .if HAS_LOOP
                lda waitdata_loop
                sta CIA_TB_LO
                lda waitdata_loop+1
                sta CIA_TB_HI
                lda #<waitdata_loop+2
                sta waitptr
                lda #>waitdata_loop+2
                sta waitptr+1
                ;bne _end
            .else
                lda #$7f
                sta CIA_ICR
                ;bpl _end
            .endif
_end:       inc waitcnt
            lda CIA_ICR
            lda irqa
            ldy irqy
nmi:        rti
            
            
conv:   .byte "0123456789ABCDEF"
            
            ;insert your music data here
            .include "data/tune.asm"
