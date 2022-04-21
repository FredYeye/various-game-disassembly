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

    !starting_point = $05B7 ;level starting point index

    !connected_levels = $0785

    !sky_x_list_offset = $0793 ;for sky effects, anything else?

    !dixie  = $0878
    !kiddie = $08E6

    !sky_effect_timer = $15E2
    !sky_effect_type  = $15E8

    !music_test_cursor = $1CCA

    !tilemap = $7F0000
}


;object defines
{
    !pos_x = $11
    !pos_y = $15
	
	!obj_size = $6E
}


;level IDs
{
    !belcha_s_barn         = $1D
    !arich_s_ambush        = $1E
    !lakeside_limbo        = $25
    !kreeping_klasps       = $26
    !tidal_trouble         = $27
    !doorstop_dash         = $28
    !squeals_on_wheels     = $29
    !murky_mill            = $2A
    !skidda_s_row          = $2B
    !springin__spiders     = $2F
    !barrel_shield_bust_up = $30
    !riverside_race        = $32
    !bobbing_barrel_brawl  = $34
    !bazza_s_blockade      = $35
    !rocket_barrel_ride    = $38
    !buzzer_barrage        = $44
    !lakeside_limbo_bonus_1 = $50
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


{ : org $B3A6F7 ;A6F7 - ?
_B3A6F7: ;breakable plank
    lda $15E6 ;plank ID + 1
    beq .A75E

    dec
    asl
    sta $1A
    asl
    clc
    adc $1A
    tax ;x = plank ID * 6
    lda.l breakable_plank_data+4,X : and #$FF00 ;check if tile ID(?) is 0
    beq .A75F

    lsr #3
    clc
    adc $1967
    sta $1A
    lda $8E    : sta $1C
    lda #$0008 : sta $1D
    lda.l breakable_plank_data+4,X : and #$00FF : tay ;count
    lda.l breakable_plank_data+0,X ;?
.A72C:
    sta $20
    jsl _B78012
    bcs .A75E

    lda $1A : clc : adc #$0008 : sta $1A
    lda $20
    clc
    adc #$0020
    dey
    bne .A72C

    stz $15E6
    lda.l breakable_plank_data+2,X ;offset
    clc
    adc $8C
    sta $1A
    lda $8E : sta $1C
    lda.l breakable_plank_data+5,X : and #$00FF ;tile ID?
    sta [$1A]
.A75E:
    rts

.A75F:
    ;if tile is 0
}


{ : org $B3A7C0 ;? - ?
breakable_plank_data:

.lakeside_limbo:
    dw $7C10 ;VRAM address (modifies VRAM $7C10 * 2 = $F820)
    dw $0690 ;offset to tile in tilemap to break
    db $03   ;count of VRAM tiles to modify
    db $01   ;tile ID?

org $B3A7CC : .tidal_trouble:
    dw $7D14
    dw $1EB4
    db $03
    db $01
}


;---------- B6


{ : org $B6D940 ;? - ?
    ;part of one of squirt's mouth functions
    lda $0010,Y
    phy
    sta $1A
    lda $12,X
    ldy $04F9
    cmp $0012,Y
    lda $1A
    bcs .D956

    eor #$FFFF
    inc
.D956:
    ply
    sta $2A,X              ;angle change to water direction
    lda #$8000 : sta $60,X ;initial water direction
}


{ : org $B6DFA1 ;DFA1 - DFF8
squirt_data:
	dw .phase4, .phase3, .phase2, .phase1

.phase1:
	db $04 ;show/hide wait timer
	db $04 ;show/hide eyes transition speed/timer
	db $00, $01
	db $04 ;close mouth wait timer
	db $04 ;close mouth transition speed/timer
	db $00, $01
	dw $01F0 ;water shoot timer
	dw $00C8 ;eyes out timer
	dw $0019 ;eyes hidden timer
	dw $001E ;hide mouth wait timer
	dw $0080 ;angle change
	db $03, $03

.phase2:
	db $04
	db $04
	db $00, $01
	db $04
	db $04
	db $00, $01
	dw $02F0
	dw $00B4
	dw $0019
	dw $001E
	dw $00B0
	db $03, $03

.phase3:
	db $04
	db $04
	db $00, $01
	db $04
	db $04
	db $00, $01
	dw $0250
	dw $00A0
	dw $0019
	dw $001E
	dw $00E0
	db $03, $03

.phase4:
    db $04
	db $04
	db $00, $01
	db $04
	db $04
	db $00, $01
	dw $0250
	dw $00A0
	db $0019
	dw $001E
	dw $00E0
	db $03, $03


}


;---------- B7


{ : org $B78012 ;? - ?
_B78012:
    jmp _B78036
}


{ : org $B78036 ;? - 808C
_B78036: ;DMA preparations?
    phx
    ldx $155E
    sta $1564,X
    lda $1D
    bra .8054

.8041:
    phx
    ldx $155E
    asl #4
    sta $1564,X
    lda $1C
    and #$FF00
    lsr #3
.8054:
    sta $1562,X
    adc #$0032
    adc $1560
    cmp $80
    bcs .808B

    sta $1560
    lda $1A : sta $1566,X
    lda $1C : and #$00FF : ora #$8000 : sta $1568,X
    txa
    clc
    adc #$0008
    sta $155E
    tax
    stz $1568,X
    cpx #$0070
    bcc .808B

    lda $80 : sta $1560
    clc
.808B:
    plx
    rtl
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


{ : org $FD06AF ;? - ?
level_data:

.lakeside_limbo:
    dw $0001 ;level type?
    db $0F   ;song to play
    dw .19F0 ;offset to shared level data
    db $00
    db $01
    db $02
    dw $0004
    db $00
    dw $0000
    dw $000A

    ;first value = flags? bit 2: initial facing
    ;2nd & 3rd: xy starting pos
    db $00 : dw $0140, $0229 ;start
    db $00 : dw $0D00, $01F8 ;checkpoint
    db $40 : dw $0870, $0178 ;bonus 1
    db $40 : dw $1250, $0188 ;bonus 2
    db $00 : dw $1880, $0200 ;warp barrel
    db $00 : dw $0800, $0209 ;demo
    db $FF                   ;start pos list terminator

    db $02, $50, $03, $51 ;connected levels
    dw $FFFF ;connection terminator?

    dw $FFFF ;terminator?

.kreeping_klasps:
    dw $0001
    db $0F
    dw .19F0
    db $01
    db $62
    db $02
    dw $0003
    db $00
    dw $0000
    dw $000A

    db $00 : dw $0150, $0269
    db $00 : dw $1270, $0228
    db $40 : dw $0BB0, $01D0
    db $40 : dw $1850, $01A8
    db $00 : dw $2690, $0228
    db $00 : dw $0680, $0200
    db $FF

    db $02, $68, $03, $69
    dw $FFFF

    dw $FFFF

org $FD08D8
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

org $FD19F0
.19F0:
    db $01
    db $01
    db $00
    db $01
    db $0A
    db $0A
    db $01
    db $01
    db $09
    dw $0100
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
