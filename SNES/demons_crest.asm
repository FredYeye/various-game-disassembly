hirom

{ ;toggle register widths
    !A8   = "sep #$20"
    !A16  = "rep #$20"

    !X8   = "sep #$10"
    !X16  = "rep #$10"

    !AX8  = "sep #$30"
    !AX16 = "rep #$30"
}

{ ;asar functions
    ;general use: calculate distance from label A to B
    function offset(a, b) = b-a
}

{ ;engine defines
    !area = $8D

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

{ : org $80BEBA ;BEBA -
_80BEBA:
    ;todo
.BF69:
    lda $14
    and #$3FFF
    lsr #5
    clc
    adc $0A
    ldx $1C
    sta $09A0,X
    ldx $0000,Y
    bmi .BFA5

    lda _98D000+0,X : sta $10
    lda _98D000+2,X : and #$00FF : sta $12
    lda _98D000+3,X : and #$00FF : sta $18
    phy
    jsr _80C2AF ;gfx decompression
    ply
    iny #2
    inc $1C : inc $1C
    bra .BF69

.8FA5:
    ;todo
}

{ ;???? -
.C09A:
    lda $24
    clc
    adc $06
    bit #$0010
    beq .C0A8

    clc
    adc #$0010
    sta $24
    ldx $1C
    sta $09A0,X
    lda ($20),Y
    beq .C0EF

    tax
    lda _98D000+0,X : sta $10
    lda _98D000+2,X : and #$00FF : sta $12
    lda _98D000+3,X : and #$00FF : sta $18
    and #$FFF8 : asl #2 : sta $06
    lda $18
    and #$0007
    asl
    tsb $06
    lda $18 : clc : adc $08 : sta $08
    phy
    jsr _80C2AF_C2F6 ;gfx decompression
    ply
    iny
    iny
    inc $1C
    inc $1C
    bra $80C09A
}

{ org $80C2AF ;C2AF -
_80C2AF: ;graphics decompression
    ;todo
.C2F6:
    ;todo
}

{ : org $80D897 ;D897 -
_80D897:
    ;sprite related, setup sprite ID stuff
}

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
    db $4E, $02 ;vellum
    db $03, $04
    db $61, $06
    db $33, $08
    db $0E, $08
    db $16, $08
    db $00
.AF22: ;stage 1, area 3
    db $4E, $02
    db $48, $04
    db $32, $06
    db $29, $08
    db $33, $0A
    db $77, $0A
    db $00
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

;---------- 18

{ : org $98D000 ;8D00 - 8EFB
_98D000:
    ;offset to compressed graphics, tile count
                  dl $9F8000 : db $06 ;000: zam, health, health upgrade
                  dl $9F8266 : db $18
                  dl $9F8C53 : db $12
                  dl $9F9447 : db $1E
                  dl $9F9FD5 : db $09
                  dl $9FA395 : db $1B
                  dl $9FAF6E : db $1A
                  dl $9FB9D6 : db $10
                  dl $9FC048 : db $0C
                  dl $9FC449 : db $0E
                  dl $9FC97A : db $0B
                  dl $9FCD01 : db $15
                  dl $9FD69B : db $18
                  dl $9FE050 : db $0D
                  dl $9FE5B4 : db $18
                  dl $9FF0C9 : db $04
                  dl $9FF268 : db $1C
                  dl $9FFE77 : db $18
                  dl $A08787 : db $18
                  dl $A091B5 : db $20
                  dl $A09EB0 : db $20
                  dl $A0A4E0 : db $0E
                  dl $A0AA64 : db $20
                  dl $A0B670 : db $05
                  dl $A0B8E4 : db $14
                  dl $A0BEBA : db $18
                  dl $A0C7F3 : db $17
                  dl $A0D0D6 : db $1F
                  dl $A0DE73 : db $0A
                  dl $A0E254 : db $18
                  dl $A0EBD3 : db $09
                  dl $A0EF2C : db $0B
                  dl $A0F35E : db $08 ;080
                  dl $A0F636 : db $05
                  dl $A0F81E : db $10
                  dl $A0FE5E : db $10
                  dl $A18441 : db $04
                  dl $A18632 : db $01
                  dl $A1866A : db $10
                  dl $A18D4E : db $16
                  dl $A196DA : db $03 ;0A0
                  dl $A1985B : db $17
                  dl $A1A240 : db $15
                  dl $A1AB18 : db $05
                  dl $A1ACF8 : db $42
                  dl $A1C6C8 : db $05
                  dl $A1C8C7 : db $0A
                  dl $A1CC2C : db $12
                  dl $A1D104 : db $0B
                  dl $A1D599 : db $20
                  dl $A1E39C : db $04
                  dl $A1E521 : db $02
                  dl $A1E5FC : db $18 ;0D0
                  dl $A1F0DB : db $0A
                  dl $A1F506 : db $1A
                  dl $A1FF89 : db $17
                  dl $A287AE : db $14
                  dl $A28F8F : db $08
                  dl $A290BA : db $09
                  dl $A2941C : db $08
                  dl $A29796 : db $2E
.crest:           dl $A2A9B2 : db $08 ;0F4
.potion:          dl $A2ACF7 : db $01 ;0F8
                  dl $A2AD5C : db $05
.talisman_armor:  dl $A2AFEF : db $01 ;100
                  dl $A2B066 : db $08
                  dl $A2B237 : db $04
                  dl $A2B450 : db $02
                  dl $A2B4E3 : db $02
                  dl $A2B576 : db $18
                  dl $A2BD48 : db $04
                  dl $A2BEA5 : db $2E
                  dl $A2D26E : db $18
.arma_projectile: dl $A2DBE0 : db $05 ;124:
                  dl $A2DD6F : db $0E
                  dl $A2E2E9 : db $08
                  dl $A2E5CD : db $2A ;130
                  dl $A2F444 : db $0F
.vellum:          dl $A2F99B : db $01 ;138
                  dl $A2F9ED : db $01
                  dl $A2FA6B : db $01 ;140
                  dl $A2FAED : db $01
                  dl $A2FB6B : db $01
                  dl $A2FBE9 : db $0A
                  dl $A2FFA5 : db $18
                  dl $A38995 : db $09
                  dl $A38D2C : db $0C
                  dl $A39257 : db $13
                  dl $A39A7F : db $08
                  dl $A39E0F : db $08
                  dl $A3A178 : db $08
                  dl $A3A515 : db $08
                  dl $A3A855 : db $18
                  dl $A3B2C5 : db $06
                  dl $A3B576 : db $17
                  dl $A3BE82 : db $05
                  dl $A3C078 : db $08 ;180
                  dl $A3C3ED : db $09 ;184
                  dl $A3C7E0 : db $02
                  dl $A3C87F : db $03
                  dl $A3C95F : db $1C
                  dl $A3D546 : db $14
                  dl $A3DD66 : db $03
                  dl $A3DE64 : db $1C
                  dl $A3E927 : db $02
                  dl $A3E9E2 : db $0D
                  dl $A3EFE8 : db $0E
                  dl $A3F55A : db $15
                  dl $A3FE06 : db $03
                  dl $A3FE77 : db $03
                  dl $A3FF77 : db $02
                  dl $A3FFEB : db $08
                  dl $A4837F : db $08
                  dl $A486EE : db $03
                  dl $A48857 : db $05
                  dl $A48A8F : db $05
                  dl $A48C9D : db $04
                  dl $A48E54 : db $05
                  dl $A4908F : db $06
                  dl $A49325 : db $04
                  dl $A49469 : db $02
                  dl $A49510 : db $03
                  dl $A49575 : db $05
                  dl $A49784 : db $15
                  dl $A49E98 : db $08
                  dl $A4A1FD : db $05
                  dl $A4A39A : db $0D ;1F8
}

;---------- 3D

{ : org $BD9953 ;9953 - 9C7C
_BD9953: ;indexed by !area
    dw .9A3B, .9A4D, $9A57, $9A61, $9A69, $9A6F, $9A7D, $9A87
    dw $9A8F, $9A9F, $9AA7, $9AB3, $9ABF, $9ACB, $9AD5, $9AD9
    dw $9AD9, .9A43, $9ADF, $9AE9, $9AF1, $9AF5, $9AFB, $9AFF
    dw $9B07, $9B0F, $9B19, $9B21, $9B25, $9B27, $9B31, $9B3D
    dw $9B43, $9B45, $9B4D, $9B4F, $9B5B, $9B65, $9B6F, $9B77
    dw $9B7F, $9B87, $9B8F, $9B93, $9B99, $9B9D, $9BA7, $9BAD
    dw $9BAD, $9BAD, $9AD5, $9AD5, $9BB5, $9BB5, $9BB5, $9BAD
    dw $9BBD, $9BBD, $9BBD, $9B21, $9BBD, $9BBD, $9BBD, $9BBD
    dw $9BBD, $9BC5, $9BD3, $9BD7, $9BDF, $9BE5, $9BE9, $9BF3
    dw $9BF7, $9BF7, $9BFB, $9C01, $9C05, $9C05, $9C05, $9C05
    dw $9C07, $9C17, $9C19, $9C07, .9C1D, .9C1D, .9C1D, .9C1D
    dw .9C1D, .9C1D, $9C1F, $9C23, $9C29, $9C2D, $9C31, $9C35
    dw $9C39, $9C3F, $9C47, $9C39, $9C4F, $9C53, $9C57, $9C5B
    dw $9C5F, $9C63, $9C67, $9C6B, $9C6B, $9C6B, $9C71, $9C73
    dw .9C77, .9C7B, .9C7B, .9C7B

;-----

.9A3B: dw $001C, $0028, $00CC, $FFFF
.9A43: dw $001C, $0028, $00D4, $0118, $FFFF
.9A4D: dw offset(_98D000, _98D000_vellum), $0004, $0134, $00A8, $FFFF ;stage 1, area 2
       dw offset(_98D000, _98D000_potion), $00EC, $00A4, $0088, $FFFF
       dw $0084, $0088, $0184, $FFFF
       dw $017C, $018C, $FFFF
       dw offset(_98D000, _98D000_potion), $0148, $0080, $0044, $0120, $009C, $FFFF
       dw offset(_98D000, _98D000_vellum), $0018, $0008, $004C, $FFFF
       dw $0054, $004C, $0058, $FFFF
       dw $0108, $0108, $0108, $00DC, $00E0, $0104, $00FC, $FFFF
       dw $0014, $0040, $00A4, $FFFF
       dw offset(_98D000, _98D000_potion), $002C, $0008, $0098, $010C, $FFFF
       dw offset(_98D000, _98D000_vellum), $0080, $0074, $0038, $0070, $FFFF
       dw $0080, $0120, $0068, $0008, $010C, $FFFF
       dw $0080, $0074, $0008, $0070, $FFFF
       dw $0064, $FFFF
       dw $0140, $0080, $FFFF
       dw offset(_98D000, _98D000_potion), $0090, $007C, $0030, $FFFF
       dw $0090, $006C, $00A4, $FFFF
       dw $003C, $FFFF
       dw $00A8, $0044, $005C, $0144, $FFFF
       dw offset(_98D000, _98D000_vellum), $0150, $0134, $FFFF
       dw $0080, $0120, $006C, $FFFF
       dw $0080, $0120, $0074, $0038, $FFFF
       dw $0120, $0198, $0080, $FFFF
       dw $0080, $00A8, $FFFF
       dw offset(_98D000, _98D000_potion), $002C, $006C, $0014, $FFFF
       dw offset(_98D000, _98D000_vellum), $002C, $00A4, $00FC, $0014, $FFFF
       dw $0088, $0018, $FFFF
       dw $FFFF
       dw $0008, $0068, $00A8, $FFFF
       dw $FFFF
       dw offset(_98D000, _98D000_talisman_armor), $000C, $0054, $0040, $0058, $FFFF
       dw $00F4, $0124, $0128, $012C, $FFFF
       dw $018C, $015C, $01E8, $0030, $FFFF
       dw $019C, $00A8, $0044, $FFFF
       dw $013C, $006C, $0134, $FFFF
       dw $019C, $00A8, $0150, $FFFF
       dw $018C, $0048, $004C, $FFFF
       dw $0130, $FFFF
       dw $0190, $0194, $FFFF
       dw $0080, $FFFF
       dw $011C, $01F8, $01F0, $01F4, $FFFF
       dw $0168, $0158, $FFFF
       dw $0158, $0160, $0164, $FFFF
       dw $0180, $0188, $0058, $FFFF
       dw $008C, $00A0, $00E8, $FFFF
       dw $0108, $0108, $0108, $00DC, $00E0, $0104, $FFFF
       dw $00F0, $FFFF
       dw $0124, $0128, $012C, $FFFF
       dw $0064, $00D8, $FFFF
       dw $0114, $FFFF
       dw $0174, $016C, $0170, $0178, $FFFF
       dw $014C, $FFFF
       dw $003C, $FFFF
       dw $00D0, $00C4, $FFFF
       dw $0130, $FFFF
       dw $FFFF
       dw $00AC, $00B0, $00B4, $00B8, $00BC, $00C0, $00E4, $FFFF
       dw $FFFF
       dw $01DC, $FFFF
.9C1D: dw $FFFF
       dw $00F4, $FFFF
       dw $00BC, $01AC, $FFFF
       dw $01B4, $FFFF
       dw $01E4, $FFFF
       dw $0154, $FFFF
       dw $01D8, $FFFF
       dw $01BC, $01EC, $FFFF
       dw $01AC, $01C0, $01B0, $FFFF
       dw $01D4, $01CC, $01D8, $FFFF
       dw $01B4, $FFFF
       dw $01B8, $FFFF
       dw $01C4, $FFFF
       dw $01D0, $FFFF
       dw $01C8, $FFFF
       dw $01CC, $FFFF
       dw $01D4, $FFFF
       dw $0130, $01E0, $FFFF
       dw $FFFF
       dw $01AC, $FFFF
.9C77: dw $01AC, $FFFF
.9C7B: dw $FFFF
}

{ ;9C7D -
_BD9C7D:
    dw $9D65, $9D7B, $9D9D, .9D8A, $9D9D, $9D9D, $9D9D, $9D9D
    dw $9D9E, $9DA5, $9DB6, $9DB6, $9DB6, $9DB7, $9DC8, $9DD1
    dw $9DD1, $9D72, $9DD1, $9DD2, $9DE1, $9DE8, $9DE8, $9DE9
    dw $9DFE, $9DFE, $9DFF, $9E11, $9E2F, $9E30, $9E31, $9E41
    dw $9E41, $9E41, $9E42, $9E4F, $9E50, $9E59, $9E68, $9E68
    dw $9E68, $9E69, $9E79, $9E82, $9E8B, $9E8B, $9E8B, $9E8B
    dw $9E8B, $9E8B, $9DC8, $9DC8, $9E8B, $9E8B, $9E8B, $9E8B
    dw $9E8B, $9E8B, $9E8B, $9E11, $9E8B, $9E8B, $9E8B, $9E8B
    dw $9E8B, $9E95, $9E9D, $9EA8, $9EB1, $9EB9, $9EC7, $9ED0
    dw $9ED9, $9EDA, $9EE3, $9EEB, $9EF5, $9EF5, $9EF5, $9EF5
    dw $9EF6, $9EF6, $9EF6, $9EF6, $9EF6, $9EF6, $9EF6, $9EF6
    dw $9EF6, $9EF6, $9EF6, $9EF6, $9EF7, $9F01, $9F01, $9F09
    dw $9EF7, $9F09, $9F09, $9F01, $9F09, $9F09, $9F09, $9F09
    dw $9F09, $9F09, $9F09, $9F0A, $9F0A, $9F0A, $9F01, $9F09
    dw $9F14, $9F14, $9F14, $9F14

;-----

.9D8A:
    db $0F : dw $0366 : db $1C ;?
    db $5A ;seems to go unused?
    dw offset(_98D000, _98D000_arma_projectile), offset(_98D000, _98D000_crest)
}
