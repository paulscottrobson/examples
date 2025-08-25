; **************************************************************************************
;
;                               Open simple text window
;
; **************************************************************************************

        .autsiz                                     ; generate code based on last REP/SEP
;
;       Start code at $200 (e.g. above zero page and stack)
;
ProgramStart = $200

        * = ProgramStart-6
        .word   $FFFF                               ; first word of XEX file
        .word   ProgramStart                        ; first byte to copy
        .word   ProgramEnd-1                        ; last byte to copy

dspl_text_buffer = $4000
dspl_fg_buffer = dspl_text_buffer + $1000
dspl_bg_buffer = dspl_fg_buffer   + $1800
dspl_chargen   = dspl_text_buffer + $2000

dspl_buffer_width  = 48
dspl_buffer_height = 30
dspl_buffer_size   = dspl_buffer_width * dspl_buffer_height

CGIA_DL_IN_EMPTY_LINE = $00
CGIA_DL_IN_DUPL_LINE  = $01
CGIA_DL_IN_JUMP       = $02
CGIA_DL_IN_LOAD_SCAN  = $03
CGIA_DL_IN_LMS  = %00010000
CGIA_DL_IN_LFS  = %00100000
CGIA_DL_IN_LBS  = %01000000
CGIA_DL_IN_LCG  = %10000000
CGIA_DL_IN_VBL  = %10000000

CGIA_DL_IN_MODE2      = $0A
CGIA_DL_IN_MODE3      = $0B
CGIA_DL_IN_MODE4      = $0C
CGIA_DL_IN_MODE5      = $0D
CGIA_DL_IN_MODE6      = $0E
CGIA_DL_IN_MODE7      = $0F

RIA = $FFC0
RIA_Stack = RIA + $30
RIA_Op = RIA + $31

CGIA = $FF00
CGIA_Mode = CGIA
CGIA_Planes = CGIA+$30
CGIA_Offset0 = CGIA+$38
CGIA_Plane0 = CGIA+$40
CGIAP_RowHeight = 2

RIA_API_GET_CHARGEN = $10

;
;       This is the main code block.
;
        clc                                         ; switch to 65816 mode
        xce

        sep     #$30                                ; 8 bit AXY

        ; initialize CGIA
        stz CGIA_Mode
        stz CGIA_Planes

        ; clear all CGIA registers
        ldx #$7F
_ClearCGIA:
        stz     CGIA,x
        dex
        bpl     _ClearCGIA


        ; fetch character generator from RIA firmware
        phb
        pla
        sta RIA_Stack          ; bank address
        lda #>dspl_chargen      ; high byte
        sta RIA_Stack
        lda #<dspl_chargen      ; low byte
        sta RIA_Stack
        lda #RIA_API_GET_CHARGEN
        sta RIA_Op

        sep     #$20
        rep     #$10
        ldx     #dspl_buffer_size-1
_FillMe:
        txa     
        sta     dspl_text_buffer,x
        sta     dspl_fg_buffer,x
        eor     #$44
        sta     dspl_bg_buffer,x
        dex
        bne     _FillMe        

        ; set display list offset
        rep     #$30
        lda     #dspl_display_list
        sta     CGIA_Offset0

        sep     #$30
        ; set row height to 8 pixels
        lda #7
        sta CGIA_Plane0+CGIAP_RowHeight
        ; and finally enable the plane
        lda #%00000001
        sta CGIA_Planes

h1:     jmp     h1

dspl_display_list:
        .byte CGIA_DL_IN_LOAD_SCAN | CGIA_DL_IN_LMS|CGIA_DL_IN_LFS|CGIA_DL_IN_LBS|CGIA_DL_IN_LCG
        .word dspl_text_buffer
        .word dspl_fg_buffer
        .word dspl_bg_buffer
        .word dspl_chargen
        .rept 30
        .byte CGIA_DL_IN_MODE2
        .endrept
        .byte CGIA_DL_IN_JUMP | CGIA_DL_IN_VBL
        .word dspl_display_list

ProgramEnd:
    
;
;       The vector block follows, loaded into $FFE0 ... $FFFF
;
        .word   $FFE0
        .word   $FFFF
        .word 0, 0, 0, 0, 0, 0, 0, 0
        .word 0, 0, 0, 0, 0, 0, ProgramStart, 0