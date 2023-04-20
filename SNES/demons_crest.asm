hirom

{ ;toggle register widths
    !A8   = "sep #$20"
    !A16  = "rep #$20"

    !X8   = "sep #$10"
    !X16  = "rep #$10"

    !AX8  = "sep #$30"
    !AX16 = "rep #$30"
}

{ ;engine defines
    ;0D30 list of sprite IDs for this stage?
    !firebrand_slot = $1000
    !obj_slot = $1080
    ; $1E44 completion tracker of sorts?
    ; $1E45 completion list
}

{ ;object defines
    ;02 type? 0x47: drop 0x48: upgrade, 0x49: hp up
    ;08 sprite?
    ;0C sprite flags?
    !obj_speed_x = $20
    !obj_speed_y = $22

    !obj_pos_x = $30
    !obj_pos_y = $33
}

{ ;completion masks
    ;1E51
    !mask_buster     = $0001
    !mask_tornado    = $0002
    !mask_claw       = $0004
    !mask_demon_fire = $0008
    !mask_earth      = $0010
    !mask_aerial     = $0020
    !mask_tidal      = $0040
    !mask_legendary  = $0080
    !mask_ultimate   = $0100

    ;1E54
}

;---------- 00

{ : org $80D977 ;D977 -
_80D977: ;sets up sprite ID list
    ldy $00
    lda ($14),Y
    cmp #$FFFF
    beq .D9A6

    and #$00FF
    tax
    lda $0D30,X : and #$FF00 : ora $00 : sta $0D30,X
    lda ($14),Y
    and #$FF00
    clc
    adc $09A0,Y
    sta $0A
    jsr .D9A7
    jsr .DA72
    inc $00 : inc $00
    bra _80D977

.D9A6:
    rts

;-----

.D9A7:
    ;todo

;-----

.DA72:
    ;todo
}

;---------- 01

{ : org $818D61 ;8D61 -
completion_mask:
.8D61: dw !mask_buster, !mask_tornado, !mask_claw|!mask_aerial, !mask_tidal, !mask_demon_fire|!mask_legendary
.8D6B: dw $0004, $0008, $0000, $0020, $0000
}

{ : org $81AD35 ;AD35 -
_81AD35: ;sprite related

.AD35:
    dw $0E00, $0C01, $FFFF ;normal form
    dw $0E66, $0C92, $FFFF
    dw $0E67, $0C91, $FFFF
    dw $0E68, $0C90, $FFFF ;earth crest
    dw $0E74, $0C93, $FFFF
    dw $0E74, $0C94, $FFFF

.AD59:
    dw $0C6B, $FFFF
.AD5D:
    dw $0002, $FFFF ;hp up?
.AD61:
    dw $003C, $FFFF
.AD65:
    dw $0010, $FFFF
    ;todo

.AE11:
    dw .AEF9, .AF15, .AF22, .AF2F, $AF3C, $AF41, $AF4E, $AF57
    dw $AF5E, $AF6F, $AF80, $AF8B, $AF96, $AFA1, $AFB0, $AFBD
    dw $AFBD, .AF08, $AFC2, $AFCB, $AFDA, $AFDF, $AFE6, $AFE9
    dw $AFF8, $AFFF, $B008, $B015, $B025, $B026, $B02F, $B03E
    dw $B043, $B044, $B04B, $B052, $B05D, $B068, $B075, $B07C
    dw $B083, $B08A, $B095, $B0A4, $B0AD, $B0B0, $B0B9, $B0BE
    dw $B0BE, $B0BE, $AFB0, $AFB0, .B0C5


    ;offset into D30, ?
.AEF9: ;stage 1, somulo arena
    ;todo
.AF08: ;stage 1, area 1
    db $0D, $06
    db $11, $08
    db $3F, $0A
    db $57, $06
    db $09, $02
    db $0A, $02
    db $00
.AF15: ;stage 1, area 2
    db $4E, $02
    db $03, $04
    db $61, $06
    db $33, $08
    db $0E, $08
    db $16, $08
    db $00
.AF22: ;stage 1, area 3
    ;todo
.AF2F: ;stage 1, area 4
    db $28, $02
    db $29, $04
    db $77, $06
    db $5A, $02
    db $5C, $04
    db $4D, $06 ;earth crest
    db $00
.B0C5: ;trio de pago 1
    db $76, $02
    db $78, $04
    db $1D, $06
    db $00
}

{ : org $81F6F3 ;F6F3 -
_81F6F3:
    dw .F720, .F73D ;todo

    ;count, vram offset, src addr
.F720: ;stage 1, area 1
    dw $7E00, $0100 : dl $7F0200
    dw $3400, $6600 : dl $7F8000
    dw $0800, $5000 : dl $9EC480 ;eng font, menu items
    dw $0800, $5400 : dl $BFBF00 ;jp font
    db $FF
.F73D:
    ;todo
}

;---------- 02

{ : org $8287E9 ;87E9 - 8803
_8287E9:
    php
    !A16
    sta $02
    stz $18
    stz $1A
    stz $05
    stz $2C
    !A8
    stz $37
    lda $00 : and #$80 : ora #$01 : sta $00
    plp
    rtl
}

{ : org $82EA34 ;EA34 -
_82EA34: ;hp up
    lda $0D30+$02 : and #$00FF : sta $08
    lda $03
    and #$001F
    cmp #$001F
    beq .EA50

    asl
    tax
    lda $F4CA,X : sta $3E
    and $1E54
.EA50:
    sta $38
    lda $38
    bne .EA5B

    lda #$0008
    bra .EA5E

.EA5B:
    ;todo
.EA5E:
    ;todo
}

;---------- 05

{ : org $85A1EE ;A1EE -
_85A1EE: ;check stage requirements
    !A16
    lda $1E58
    bit #$0001
    bne .A22D

    ldy #$03 ;3: unlock everything, incl. secret boss
    lda $1E51
    bit #!mask_ultimate
    bne .A21A

    ldy #$00 ;0: all stages, phalanx 2
    ldx #$08
.A206:
    lda $1E51
    bit.w completion_mask_8D61,X
    bne .A216

    lda $1E54
    bit.w completion_mask_8D6B,X
    beq .A21D

.A216:
    dex #2
    bpl .A206

.A21A:
    !A8
    rtl

.A21D:
    lda $1E51
    and #!mask_buster|!mask_tornado|!mask_claw|!mask_earth|!mask_aerial
    cmp #!mask_buster|!mask_tornado|!mask_claw|!mask_earth|!mask_aerial
    bne .A22D

    ldy #$01 ;1: all stages, no phalanx
    !A8
    rtl

.A22D:
    ldy #$FF ;-1: nothing unlocked
    ldx #$04
.A231:
    lda $1E51
    bit.w completion_mask_8D61,X
    bne .A241

    lda $1E54
    bit.w completion_mask_8D6B,X
    beq .A247

.A241:
    dex #2
    bpl .A231

    ldy #$02 ;2: phalanx 1
.A247:
    !A8
    rtl
}
