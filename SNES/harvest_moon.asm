lorom


;snes registers
{
    !WRDIVL   = $4204 ;Set unsigned 16bit Dividend (lower 8bit)
    !WRDIVB   = $4206 ;Set unsigned 8bit Divisor and Start Division

    !RDDIVL   = $4214 ;Unsigned Division Result (Quotient) (lower 8bit)
    !RDMPYL   = $4216 ;Unsigned Division Remainder / Multiply Product (lower 8bit)
}


;toggle register widths
{
    !A8   = "sep #$20"
    !A16  = "rep #$20"

    !X8   = "sep #$10"
    !X16  = "rep #$10"

    !AX8  = "sep #$30"
    !AX16 = "rep #$30"
}


;harvest moon defines
{
    ; D4: some kind of state variable
    ;     0F = idling with the fishing rod
    ;     10 = throwing out the lure
    ;     11 = fishing?
    ;     12 = fish on hook
    !rng_state = $0100
}


;---------- 00


{ : org $8089F9 ;89F9 - 8A32
_8089F9: ;rng related
    !AX8
    sta $92 ;92-93: 8-bit divisor, zero extended to 16
    pha
    stz $93
    !A16
    lda #$00FF : sta $7E ;dividend
    lda $92    : sta $80 ;divisor
    jsl _838082 ;division
    !A8
    sta $93 ;store result (always 1 in case of fishing (255/255))
    jsl rng
    !AX8
    sta $94 ;store rng result
    pla
    dec
    sta $92 ;FF - 1 = FE in the case of fishing
    ldx #$00
    lda $93
.8A23:
    cmp $94
    bcs .8A31 ;fishing: branch if rng is 0-1 (and return 0)

    inx
    cpx $92
    beq .8A31

    clc
    adc $93
    bra .8A23

.8A31:
    txa
    rtl
}


;---------- 01


{ : org $81C263 ;C263 - ?
_81C263: ;fishing check
    !AX16
    !A8
    lda #$FF : jsl _8089F9 ;rng, set divisor to 0xFF
    bne .C280

    !A8
    lda #$04 : jsl _8089F9
    bne .C280

    !AX16
    lda #$0012 : sta $D4 ;switch state to "fish on hook"
.C280:
    !AX16
    lda #$008E
    sta $0901
    jsr $CFE6
    jmp $C002
}


; 81C28E: called when fish on the hook?


;---------- 03


{ org $838082 ;8082 - 80CF
_838082: ;division
    !AX16
    ldy #$0000
    lda $80
    cmp #$00FF
    bcs .80AE

    lda $7E : sta !WRDIVL
    !A8
    lda $80 : sta !WRDIVB
    !A16
    nop : nop : nop
    tya
    lsr
    lda !RDMPYL
    sta $7E
    lda !RDDIVL
.80AD:
    rtl

.80AE: ;go here if divisor >= 0xFF
    ;probably manual division code
    phy
    ldy #$0010
    lda #$0000
    sta $82
.80B7:
    asl $82
    asl $7E
    rol
    cmp $80
    bcc .80C4

    sbc $80
    inc $82
.80C4:
    dey
    bne .80B7
    sta $7E
    pla
    lsr
    lda $82
    jmp .80AD
}


{ : org $838138 ;8138 - 8165
rng:
    !A8
    lda !rng_state+1
    eor !rng_state+0
    and #$02
    clc
    beq .8146

    sec
.8146:
    ror !rng_state+1
    ror !rng_state+0
    ror !rng_state+2
    clc
    lda !rng_state+1
    adc #$47
    ror #2
    eor !rng_state+0
    adc !rng_state+2
    sta !rng_state+0
    !A16
    and #$00FF
    rtl
}
