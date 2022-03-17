hirom


;snes registers
{
    !CGADD  = $2121 ;Palette CGRAM Address
    !CGDATA = $2122 ;Palette CGRAM Data Write (write-twice)
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


;DKC3 defines
{
    !animal_transform = $007E ;0000=kongs, 023C=squawks/quawks

    !level_id = $00C0

    !sky_x_list_offset = $0793 ;for sky effects, anything else?

    !dixie  = $0878
    !kiddie = $08E6

    !sky_effect_timer = $15E2
    !sky_effect_type  = $15E8
}


;object defines
{
    !pos_x = $11
    !pos_y = $15
}


;level IDs
{
    !belcha_s_barn  = $1D
    !lakeside_limbo = $25
    !tidal_trouble  = $27
    !doorstop_dash  = $28
    !murky_mill     = $2A
    !skidda_s_row   = $2B
}


;---------- B3


{ : org $B399C5 ;99C5 - ?
sky_fade:

.blue_gray:
	dw $79EA, $7A6F, $7AF4, $7B58, $7BDE
	dw $71EA, $724F, $72D3, $7337, $739C
	dw $6DCA, $6E2E, $6EB3, $6F17, $6F7B
	dw $65CA, $662E, $6A92, $6AF6, $6B5A
	dw $61AA, $620E, $6691, $66D5, $6739
	dw $59A9, $5E0D, $5E71, $62B4, $6318
	dw $5589, $55ED, $5A50, $5E94, $5EF7
	dw $4D89, $51CC, $5630, $5A93, $5AD6
	dw $4969, $4DCC, $522F, $5272, $56B5
	dw $4169, $45AC, $4A0E, $4E51, $5294
	dw $3D48, $418B, $45EE, $4A31, $4E73
	dw $3548, $398B, $41CD, $4610, $4A52
	dw $3128, $356B, $3DCD, $41EF, $4631
	dw $2928, $316A, $35AC, $3DCE, $4210
	dw $2508, $294A, $318C, $39CE, $3DEF
	dw $2108, $2529, $2D6B, $35AD, $3DEF
}


{ : org $B39BF6 ;9BF6 - ?
_B39BF6: ;changes sky effects
    lda $15E4
    beq .9C15

    cmp #$0001
    bne .9C64

    lda $15E6
    bne .9C64

    inc $15E2
    lda $15E2
    cmp #$0100
    beq .9C61

    eor #$00FF
    bra .9C20

.9C15:
    inc $15E2
    lda $15E2
    cmp #$0100
    beq .9C61

.9C20:
    lsr #4
    asl
    sta $1A
    asl #2
    clc
    adc $1A
    tax
    lda $05B9
    cmp #$002C
    bne .9C3B

    txa
    clc
    adc #$00A0
    tax
.9C3B:
    lda $05B9
    cmp #$002D
    bne .9C49

    txa
    clc
    adc #$0140
    tax
.9C49:
    ldy #$000A
    !A8
    lda #$1B : sta !CGADD
.9C53:
    lda sky_fade,X : sta !CGDATA
    inx
    dey
    bpl .9C53

    !A16
    rts

.9C61:
    ;todo

.9C64:
    ;todo
}



{ : org $B3A7C0 ;? - ?
breakable_plank_data:
.lakeside_limbo:
    dw $7C10
    dw $0690 ;x offset
    db $03
    db $01

org $B3A7CC : .tidal_trouble:
    dw $7D14
    dw $1EB4
    db $03
    db $01
}


;---------- B8


{ : org $B88CBD ;8CBD - 8D12
animal_transform:
    pha
    lda !animal_transform
    beq .8CC6

    lda $7C
    beq .8CDF

.8CC6:
    ldx $04FD
    lda #$0001
    jsl $BB85A0
    ldx $04FD
    jsl $BB85EB
    ldx $7C
    beq .8CDF

    jsl $BB85E8
.8CDF:
    ldx $04FD
    jsr $9F20
    lda $01,S
    asl #2
    adc #$0230
    sta !animal_transform
    stz $7C
    ldx $04F9
    pla
    clc
    adc #$0015
    cmp #$0018
    bne .8D0A

    tay
    lda $0777
    and #$0010
    beq .8D09

    ldy #$001E ;alternate palette
.8D09:
    tya
.8D0A:
    jsl $BB85A0
    jsl $B8ED11
    rts
}


;---------- BB


{ : org $BB97AE ;97AE - ?
_BB97AE:
    ;level data loading?
}


;---------- FD


{ : org $FD08D8 ;? - ?
    ;flags used in springin' spiders
    dw $1480 ; byte 4 not set = squawks

org $FD0D0F
    ;flags used in buzzer barrage
    dw $0210 ;byte 4 set = quawks

    ;level graphics data/settings?
org $FD1998
    ;used in murky mill
    db $05
    db $05
    db $00
    db $01
    db $0E
    db $0E
    db $11
    db $11
    db $05
    dw $A000 ;4 most significant bits appear to set kong palettes

org $FD19DA
    ;used in skidda's row
    db $06
    db $06
    db $00
    db $01
    db $09
    db $09
    db $0A
    db $0A
    db $08
    dw $0422
}


;---------- FF


{ : org $FF9E08 ;9E08 - ?
sky_x:
    dw .9E1A, $9E71, $9E74, $9E32, $9E77, $9E7A, $9E53, $9E7D, $9E80

.9E1A:
    db $00 : dw $0340 ;sky effect + x offset where it starts
    db $01 : dw $0740
    db $04 : dw $1180
    db $05 : dw $1A00
    db $04 : dw $1C00
    db $03 : dw $1E00
    db $01 : dw $2000
    db $00 : dw $FFFF
}
