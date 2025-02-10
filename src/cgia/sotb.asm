;
; This program contains only code for SOTB demo.
; In order to have a working X65 ROM file, you need to merge it with
; image data blocks. See src/cgia/data/bins.c to generate it.
; Then do something like this:
; ../tools/xex-filter.pl -o build/SOTB.xex build/src/sotb.xex src/cgia/data/sotb_layers.xex
;

.p816   ; 65816 processor

.include "../cgia.asm"

.macro store value, address
    lda value
    sta address
.endmacro

.segment "INFO"
    .byte "Shadow Of The Beast demo"

.segment "VECTORS"
    .word 0, 0, 0, 0, 0, 0, 0, 0
    .word 0, 0, 0, 0, 0, nmi, reset, 0

.zeropage
.define SCROLL_MAX      $2580 ; 9600
.define SCROLL_DELTA    3

scroll:             .res 2
scroll_moon:        .res 1
offset_moon:        .res 1
scroll_clouds_01:   .res 1
offset_clouds_01:   .res 1
scroll_clouds_02:   .res 1
offset_clouds_02:   .res 1
scroll_clouds_03:   .res 1
offset_clouds_03:   .res 1
scroll_clouds_04:   .res 1
offset_clouds_04:   .res 1
scroll_clouds_05:   .res 1
offset_clouds_05:   .res 1
scroll_hills_06:    .res 1
offset_hills_06:    .res 1
scroll_grass_07:    .res 1
offset_grass_07:    .res 1
scroll_trees_08:    .res 1
offset_trees_08:    .res 1
scroll_grass_09:    .res 1
offset_grass_09:    .res 1
scroll_grass_10:    .res 1
offset_grass_10:    .res 1
scroll_grass_11:    .res 1
offset_grass_11:    .res 1
scroll_fence_12:    .res 1
offset_fence_12:    .res 1

.define Y_OFFS  20

video_offset_1 = $1000
color_offset_1 = $5000
bkgnd_offset_1 = $5800
dl_offset_1 = $4F00
video_offset_2 = $6000
color_offset_2 = $A000
bkgnd_offset_2 = $A800
dl_offset_2 = $9F00
video_offset_3 = $B000
color_offset_3 = $F000
bkgnd_offset_3 = $F800
dl_offset_3 = $EF00

.code
reset:
    sei                     ; disable IRQ

    ; disable all planes, so CGIA does not go haywire during reconfiguration
    store #0, CGIA::planes

    ; set border/background color
    store #145, CGIA::back_color

    ; configure plane display lists
    lda #<dl_offset_1
    sta CGIA::offset0
    lda #>dl_offset_1
    sta CGIA::offset0 + 1
    lda #<dl_offset_2
    sta CGIA::offset1
    lda #>dl_offset_2
    sta CGIA::offset1 + 1
    lda #<dl_offset_3
    sta CGIA::offset2
    lda #>dl_offset_3
    sta CGIA::offset2 + 1
    ; now fill plane registers
    ldx #(4*16)-1
pl_loop:
    lda cgia_planes, x
    sta CGIA::plane0, x
    dex
    bpl pl_loop

    ; --- setup CGIA interrupts
    lda #Y_OFFS
    sta CGIA::int_raster    ; set interrupt raster line

    lda #(CGIA_REG_INT_FLAG_VBI|CGIA_REG_INT_FLAG_RSI)
    sta CGIA::int_enable    ; trigger NMI on VBL and raster line

    ; --- activate planes
    store #%00000111, CGIA::planes

forever:
    jmp forever ; do nothing more

PF1 = PLANE_MASK_DOUBLE_WIDTH | PLANE_MASK_TRANSPARENT | PLANE_MASK_BORDER_TRANSPARENT
PF2 = PLANE_MASK_DOUBLE_WIDTH | PLANE_MASK_TRANSPARENT
cgia_planes:
    .byte PF1,4,7,80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; bg1
    .byte PF1,4,7,80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; bg2
    .byte PF2,4,7,80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; bg3
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; sprites

; -----------------------------------------------------------------------------
nmi:
    pha         ; save accumulator

    lda #CGIA_REG_INT_FLAG_VBI
    bit CGIA::int_status    ; check for Vertical Blank Interrupt
    beq :+                  ; skip to RSI if not active
    jsr vbi_handler
:
    lda #CGIA_REG_INT_FLAG_RSI
    bit CGIA::int_status    ; check for RaSter Interrupt
    beq :+                  ; skip to end if not active
    jsr rsi_handler
:
    pla         ; restore accumulator
    sta CGIA::int_status    ; ack interrupts
    rti         ; return from interrupt

vbi_handler:
    ; restart background color
    lda #$8b
    sta CGIA::back_color

    ; wait for first line of RSI
    store #Y_OFFS+0, CGIA::int_raster

    ; run the frame counter
    lda scroll
    clc
    adc #SCROLL_DELTA
    sta scroll
    lda scroll+1
    adc #0
    sta scroll+1
    cmp #>SCROLL_MAX
    bcc :+
    lda scroll
    cmp #<SCROLL_MAX
    bcc :+
    lda #0
    sta scroll
    sta scroll+1
:
    rts

rsi_handler:
    lda CGIA::raster
    cmp #Y_OFFS+0
    bne :+
        store #Y_OFFS+21, CGIA::int_raster
        rts
:   cmp #Y_OFFS+21
    bne :+
        store #Y_OFFS+61, CGIA::int_raster
        rts
:   cmp #Y_OFFS+61
    bne :+
        store #Y_OFFS+72, CGIA::int_raster
        rts
:   cmp #Y_OFFS+72
    bne :+
        store #Y_OFFS+76, CGIA::int_raster
        rts
:   cmp #Y_OFFS+76
    bne :+
        store #$9b, CGIA::back_color
        store #Y_OFFS+80, CGIA::int_raster
        rts
:   cmp #Y_OFFS+80
    bne :+
        store #Y_OFFS+89, CGIA::int_raster
        rts
:   cmp #Y_OFFS+89
    bne :+
        store #Y_OFFS+96, CGIA::int_raster
        rts
:   cmp #Y_OFFS+96
    bne :+
        store #Y_OFFS+103, CGIA::int_raster
        rts
:   cmp #Y_OFFS+103
    bne :+
        store #$a4, CGIA::back_color
        store #Y_OFFS+117, CGIA::int_raster
        rts
:   cmp #Y_OFFS+117
    bne :+
        store #$b4, CGIA::back_color
        store #Y_OFFS+127, CGIA::int_raster
        rts
:   cmp #Y_OFFS+127
    bne :+
        store #$c4, CGIA::back_color
        store #Y_OFFS+135, CGIA::int_raster
        rts
:   cmp #Y_OFFS+135
    bne :+
        store #$cd, CGIA::back_color
        store #Y_OFFS+142, CGIA::int_raster
        rts
:   cmp #Y_OFFS+142
    bne :+
        store #$dd, CGIA::back_color
        store #Y_OFFS+148, CGIA::int_raster
        rts
:   cmp #Y_OFFS+148
    bne :+
        store #$ed, CGIA::back_color
        store #Y_OFFS+154, CGIA::int_raster
        rts
:   cmp #Y_OFFS+154
    bne :+
        store #$f6, CGIA::back_color
        store #Y_OFFS+158, CGIA::int_raster
        rts
:   cmp #Y_OFFS+158
    bne :+
        store #$0e, CGIA::back_color
        store #Y_OFFS+175, CGIA::int_raster
        rts
:   cmp #Y_OFFS+175
    bne :+
        store #Y_OFFS+178, CGIA::int_raster
        rts
:   cmp #Y_OFFS+178
    bne :+
        store #Y_OFFS+182, CGIA::int_raster
        rts
:   cmp #Y_OFFS+182
    bne :+
        store #Y_OFFS+189, CGIA::int_raster
        rts
:   cmp #Y_OFFS+189
    bne :+
:
    rts
