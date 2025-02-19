;
; This program contains only code for the demo.
; In order to have a working X65 ROM file, you need to merge it with
; sampled data blocks. See src/cgia/data/bins.c to generate it.
; Then do something like this:
; ../tools/xex-filter.pl -o build/pwm_samples.xex build/src/pwm_samples.xex src/cgia/data/pwm_samples.xex
;

; This demo showcases:
; - using PWM channel to play sampled music
; - RIA monotonic clock used to track real wall-clock time
;   in high (us) resolution


.p816       ; 65816 processor
.smart +    ; 8/16 smart mode

.include "../cgia.asm"
.include "../ria.asm"
.include "../macros.asm"

.segment "INFO"
    .byte "PWM Samples Playback demo"

.segment "VECTORS"
    .word 0, 0, 0, 0, 0, 0, 0, 0
    .word 0, 0, 0, 0, 0, 0, reset, 0

sample_period = 1000000/8000 ; 8 KHz
sample_count  = 33133
samples_offset = $1000

.code
reset:
    sei         ; disable IRQ

    clc
    xce         ; switch to native mode

    ; disable all planes
    store #0, CGIA::planes

    _a16
    _i16

    ldy #0      ; sample offset

    lda #$FF00  ; base freq is 65280 Hz - outside hearing range
    sta CGIA::pwm0+CGIA_PWM::freq

    lda ria_time_tm
    sta $00         ; init time tracker

loop:
    lda ria_time_tm
    sec
    sbc $00         ; compute delta (modulo)
    cmp #sample_period
    bmi loop        ; loop if not hit period

    _a8 ; samples are 8bit
    lda samples_offset,y    ; load sample value
    ; set sample value as PWM channel duty cycle
    ; with very high frequency and output low-pass filter integrating the signal
    ; this basically sets the level of signal output
    sta CGIA::pwm0+CGIA_PWM::duty
    ; put sample value as background color for some blinkenlights
    sta CGIA::back_color
    _a16

    lda $00
    clc
    adc #sample_period  ; compute next point in time
    sta $00

    iny     ; next sample
    tya
    cmp #sample_count
    bne loop
    ldy #0  ; restart sample bank

    bra loop
