hirom

;snes registers
{
    !M7A      = $211B ;Rotation/Scaling Parameter A & Maths 16bit operand (w2)
    !M7B      = $211C ;Rotation/Scaling Parameter B & Maths 8bit operand (w2)

    !MPYL     = $2134 ;PPU1 Signed Multiply Result   (lower 8bit)
    !MPYH     = $2136 ;PPU1 Signed Multiply Result   (upper 8bit)

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


;mark davis defines
{
    !fish_catch_timer_list      = $02F8
    !fish_pos_x_list            = $0358
    !tackle_pos_x               = $037A
    !fish_pos_y_list            = $0418
    !tackle_pos_y               = $043A

    !caught_biggest_fish_today  = $0D06
    !weather                    = $0D0C
    !current_lure               = $0D12
    !current_bait               = $0D13
    !fishes_caught_per_day      = $0D22
    !current_stage              = $0D3C
    !current_area               = $0D48
    !current_sub_area           = $0D4A
    !current_spot               = $0D4C

    !wind_breaker               = $0D52
    !cap                        = $0D54
    !glove                      = $0D56
    !rain_gear                  = $0D58

    !competitor_name_list       = $0D66
    !competitor_weight_stage    = $0D7C

    !fishing_rating             = $0DA8
    !lure_rating                = $1208
    !fishes_caught_current_zone = $122C
    !area_rating                = $133A
    !areas_visited              = $133C
    !competitor_weight_day      = $1496
}


;competitor_name_list ($0D66)
;00: hatori.y
;01: b.nugent
;02: t.morris
;03: j.wan
;04: syuya.t
;05: r.pierce
;06: s.deedon
;07: p.smith
;08: n.ford
;09: j.leleu
;0A: j.smith
;0B: iku.m
;0C: hiro.m
;0D: b.ford
;0E: masaki.s
;0F: toshi.i
;10: m.davis


;---------- C0


{ : org $C008BD ;08BD - 08D5
rng:
    php
    !AX16
    lda $1010
    asl
    adc $3E
    asl
    adc $1010
    adc #$3211
    sta $1010
    eor $3E
    sta $3E
    plp
    rts
}


{ : org $C0092A ;092A - 0945
multiply: ;signed multiply of A(16 bit) and X(8 bit), 3 byte result is stored in $08
    !X16
    !A8
    sta !M7A
    xba
    sta !M7A
    txa
    sta !M7B
    ldy !MPYL : sty $08
    lda !MPYH : sta $0A
    !A16
    rts
}


{ : org $C03262 ;3262 - 3278
_C03262:
    ldx #$0000
.3265:
    sed
    lda !competitor_weight_day,X
    clc : adc !competitor_weight_stage,X
    sta !competitor_weight_stage,X
    cld
    inx #2
    cpx #$0016
    bne .3265

    rts
}

{ ;3279 - 32D8
_C03279: ;related to competitor catch
    lda !current_stage : asl : tax
    lda competitor_weights,X : sta $00
    lda #$00C1 : sta $02 ;$00 = address with offset based on stage
    jsr rng : and #$0007 : asl : tax ;x = 0..7 * 2 | initial offset to store weights at, to randomize who gets which base weight
    ldy #$0000
.3294:
    lda [$00],Y : sta !competitor_weight_day,X
    inx #2
    cpx #$0014
    bne .32A3

    ldx #$0000
.32A3:
    iny #2
    cpy #$0014
    bne .3294

    ldx #$0000
.32AD:
    lda !competitor_weight_day,X
    jsr .add_weight
    sta !competitor_weight_day,X
    inx #2
    cpx #$0014
    bne .32AD

    rts

.add_weight:
    sta $00
    jsr rng : and #$001F : sta $02
.32C8:
    sed
    lda $00
    clc : adc #$0001 ;add a random amount of weight, 0.01..0.32 lbs
    sta $00
    cld
    dec $02
    bpl .32C8

    lda $00
    rts
}

{ : org $C04EB1 ;4EB1 - 4F60
_C04EB1: ;calculate lure + bait rating
    lda #$571C : sta $00
    lda #$00C1 : sta $02 ;$00 = address of lure_ratings
    lda !current_lure : and #$00FF
    ldx #$0007
    jsr multiply ;$08 = current_lure * 7
    lda $08
    clc : adc $00
    sta $00 ;add multiplication result to address in $00
    ldy !current_stage
    lda [$00],Y : and #$00FF : sta !lure_rating
    lda #$571C : sta $00
    lda #$00C1 : sta $02 ;$00 = address of lure_ratings
    lda !current_lure : and #$00FF
    cmp #$0026
    bcc .4F4B ;jump if current lure is crank, minnow or topwater

    cmp #$0057
    bcs .4F07 ;jump if current lure is rig

    ;buzz, spinner and rubber
    lda !current_bait : and #$00FF
    beq .4F2B

    lda #$0001
    clc : adc !lure_rating ;add 1 to lure rating if bait is attached
    sta !lure_rating
    bra .4F2B

.4F07:
    lda !current_bait : and #$00FF
    beq .4F2B ;jump if no bait

    ldx #$0006   ;!!bug!! should be 7!
    jsr multiply ;$08 = current_bait * 6
    lda $08
    clc : adc $00
    sta $00
    ldy !current_stage
    lda [$00],Y
    and #$00FF
    clc : adc !lure_rating
    sta !lure_rating

.4F2B:
    lda !current_lure : and #$00FF
    cmp #$0042
    bcc .4F4B ;jump if current lure is buzz or spinner (except 4 last colorado spinners)

    cmp #$0046
    bcc .4F4C ;jump if current lure is one of the 4 last colorado spinners

    cmp #$0057
    bcs .4F4B ;jump if current lure is rig

    ;rubber
    lda !current_bait : and #$00FF
    bne .4F4B

    jsr .4F58
.4F4B:
    rts

.4F4C: ;set rating to 0 if using colorado spinners without bait
    lda !current_bait : and #$00FF
    bne .4F57

    stz !lure_rating
.4F57:
    rts

;-----

.4F58: ;deduct one point from rating if fishing with rubber jig without bait
    dec !lure_rating
    bpl ..not_negative

    stz !lure_rating
..not_negative:
    rts
}


{ : org $C057B3 ;57B3 - 57EB
catch_timer:
    lda $1230
    bne .57E8

    lda !current_stage
    cmp #$0001
    bne .57C5

    ;stage 2 (summer)
    lda !cap
    beq .57E4

.57C5:
    lda !weather
    cmp #$0002 ;rain
    bne .57D2

    lda !rain_gear
    beq .57E4

.57D2:
    lda !current_stage
    cmp #$0003
    bcc .57E8

    cmp #$0005
    bcs .57E8

    lda !glove
    bne .57E8

.57E4:
    lda #$0009
    rts

.57E8:
    lda #$0012
    rts
}


{ : org $C058BE ;58BE - 5A4F
_C058BE: ;got fish on hook
    lda !area_rating
    clc : adc !lure_rating
    sta !fishing_rating
    lda $1052 : cmp #$0001
    bne .58DF ;jump if player isn't holding X (maybe other conditions too, not sure)

    lda !fishing_rating
    sec : sbc #$0002 ;deduce 2 rating for holding the "go fast" button
    bpl .not_negative

    lda #$0000
.not_negative:
    sta !fishing_rating

.58DF:
    lda !fishing_rating
    cmp #$000E
    bcs .594C

    cmp #$000D
    bcs .5903

    cmp #$000C
    bcs .590F

    cmp #$000B
    bcs .591B

    cmp #$000A
    bcs .5927

    cmp #$0009
    bcs .5933

    brl .593F

.5903:
    ldx #$1540 : ldy #$0005 : lda #$0002
    brl .5992

.590F:
    ldx #$1420 : ldy #$0004 : lda #$0002
    brl .5992

.591B:
    ldx #$1280 : ldy #$0003 : lda #$0002
    brl .5992

.5927:
    ldx #$1220 : ldy #$0002 : lda #$0002
    brl .5992

.5933:
    ldx #$1140 : ldy #$0001 : lda #$0002
    brl .5992

.593F: ;smallest fish possible
    ldx #$0900 : ldy #$0000 : lda #$0003
    brl .5992

.594C:
    lda !fishes_caught_current_zone : cmp #$0002
    bcs .593F

    lda !fishes_caught_per_day : cmp #$0003
    bcs .593F

    lda !fishing_rating : cmp #$0010
    bcc .5975

    lda !caught_biggest_fish_today
    bne .5975 ;jump if already caught a fish weighing >= 20.00"

;biggest fish possible
    ldx #$2160 : ldy #$0008 : lda #$0004 ;x = length | y = fish list index | a = divisor, bigger number means more variance
    brl .5992

.5975:
    lda !fishing_rating : cmp #$000F
    bcc .5989

;second fish
    ldx #$1860 : ldy #$0007 : lda #$0003
    brl .5992

.5989:
    ldx #$1660 : ldy #$0006 : lda #$0002

.5992:
    pha
    stx $00 ;length
    sty $02 : jsr fish_weight
    pla
    asl #3 : sta $04 ;$04 = divisor * 8
    stz $08
    stz $0A
    jsr rng : asl
    bcs .59D1 ;50/50

;add
    jsr rng : ldx $04 : jsr division ;rng / $04
    txa : asl : tax                 ;remainder * 2
    sed
    lda $00                         ;fish length
    clc : adc length_variance,X     ;add length variance
    clc : adc $08                   ;$08 is always 0 here? so this does nothing
    sta $00                         ;store updated length
    lda $02                         ;fish weight
    clc : adc weight_variance,X     ;add weight variance
    clc : adc $0A                   ;$0A is always 0 here? so this does nothing
    sta $02                         ;store updated weight
    cld
    bra .59F0

.59D1: ;sub
    jsr rng : ldx $04 : jsr division ;rng / $04
    txa : asl : tax                 ;remainder * 2
    sed
    lda $00                         ;fish length
    sec : sbc length_variance,X     ;subtract length variance
    sta $00                         ;store updated length
    lda $02                         ;fish weight
    sec : sbc weight_variance,X     ;subtract weight variance
    sta $02                         ;store updated weight
    cld

.59F0:
    jsr rng : asl
    bcs .5A0C ;50/50

;add
    jsr rng : and #$001F : asl : tax
    sed
    lda $00
    clc : adc weight_variance,X
    sta $0D20 ;updated length + weight variance, randomly chosen from 16 first values
    cld
    bra .5A20

.5A0C: ;sub
    jsr rng : and #$001F : asl : tax
    sed
    lda $00
    sec : sbc weight_variance,X
    sta $0D20 ;updated length - weight variance, randomly chosen from 16 first values
    cld

.5A20:
    jsr rng : asl
    bcs .5A3B ;50/50

;add
    jsr rng : and #$001F : asl : tax
    sed
    lda $02
    clc : adc weight_variance,X
    sta $0D1E ;updated weight + variance
    cld
    rts

.5A3B: ;sub
    jsr rng : and #$001F : asl : tax
    sed
    lda $02
    sec : sbc weight_variance,X
    sta $0D1E ;updated weight - variance
    cld
    rts
}


{ ;C05A50 - C05A68
fish_weight:
    lda !current_stage : asl : tax
    lda fish_weight_lists,X : sta $04
    lda #$00C1              : sta $06 ;$04 = $C1xxxx, xxxx is offset from _C13030
    lda $02 : asl : tay               ;fish list index
    lda [$04],Y             : sta $02 ;get weight and store in $02
    rts
}


{ ;C05A69 - C05A7F
_C05A69:
    lda $0D20
    cmp #$1600
    bcc .5A7F

    cmp #$2000
    bcc .5A79

    inc !caught_biggest_fish_today
.5A79:
    inc !fishes_caught_current_zone
    inc !fishes_caught_per_day
.5A7F:
    rts
}


{ ;C05A80 - C05AA9
division: ;unsigned divide of A(16 bit) and X(8 bit)
    !AX16
    sta !WRDIVL
    beq .5AA1

    txa
    beq .5AA1

    !A8
    sta !WRDIVB
    nop #8
    !AX16
    lda !RDMPYL : tax ;x = remainder
    lda !RDDIVL       ;a = result
    rts

.5AA1: ;if dividend or divisor is 0
    !AX16
    lda #$0000
    ldx #$0000
    rts
}


{ : org $C06DFF ;6DFF - 6E51
    lda !current_stage : asl : tax ;x = current stage * 2
    lda zone_rating_stage_offset,X : sta $00 ;$00 = --xxxx, xxxx = stage offset
    lda #$00C1 : sta $02                     ;$00 = C1xxxx
    lda $0D48 : asl : tay ;y = current area * 2
    lda [$00],Y : sta $00
    lda $0D4A : asl : tay ;y = current sub area * 2
    lda [$00],Y : sta $00
    lda $0D4C : asl : tay ;y = current fishing spot * 2
    lda [$00],Y : sta $04
    and #$FF00
    sta $05
    lda !areas_visited
    beq .6E49

    lda !areas_visited : cmp $04
    beq .6E45

    lda $06 : cmp !area_rating
    bpl .6E45

    sta !area_rating
.6E45:
    inc !areas_visited
    rts

.6E49:
    lda $06 : sta !area_rating
    inc !areas_visited
    rts
}


;---------- C1


{ : org $C106B0 ;06B0 - 06FF
length_variance:
    dw $000, $002, $004, $006, $008, $010, $012, $016
    dw $020, $022, $024, $026, $028, $030, $032, $036
    dw $040, $042, $044, $046, $048, $050, $052, $056
    dw $060, $064, $068, $072, $076, $080, $088, $096
    dw $100, $108, $116, $124, $132, $140, $148, $156
}


{ ;0700 - 074F
weight_variance:
    dw $00, $00, $00, $03, $03, $03, $03, $06
    dw $06, $06, $06, $09, $09, $09, $09, $12
    dw $12, $12, $15, $15, $15, $15, $15, $18
    dw $18, $21, $21, $21, $24, $24, $27, $30
    dw $30, $33, $36, $39, $42, $42, $45, $48
}


{ : org $C117D2 ;17D2 - 186B
competitor_weights: ;base weights for the competition
    dw .spring, .summer, .fall, .winter1, .winter2, .championship, .1858

.spring:       dw $1650, $1608, $1506, $1482, $1464, $1362, $1200, $1158, $1101, $1029
.summer:       dw $1500, $1464, $1419, $1362, $1284, $1242, $1140, $1098, $1044, $0966
.fall:         dw $1800, $1758, $1656, $1572, $1404, $1332, $1230, $0978, $1014, $0924
.winter1:      dw $1296, $1218, $1056, $0972, $0804, $0732, $0630, $0378, $0324, $0414
.winter2:      dw $1200, $1164, $1068, $0972, $0864, $0792, $0690, $0564, $0522, $0489
.championship: dw $1650, $1608, $1506, $1482, $1464, $1362, $1200, $1158, $1101, $1029
.1858:         dw $0735, $0728, $0711, $0703, $0691, $0687, $0674, $0669, $0652, $0645
}


{ : org $C13030 ;3030 - 30BB
fish_weight_lists:
    dw .spring, .summer, .fall, .winter1, .winter2, .championship, .30AA

.spring:       dw $123, $165, $174, $189, $207, $234, $288, $486, $642
.summer:       dw $114, $153, $165, $174, $186, $210, $255, $462, $615
.fall:         dw $150, $174, $186, $204, $228, $255, $312, $501, $672
.winter1:      dw $096, $135, $144, $159, $177, $204, $246, $453, $492
.winter2:      dw $084, $126, $135, $150, $159, $186, $234, $429, $534
.championship: dw $123, $165, $174, $189, $207, $234, $288, $486, $642
.30AA:         dw $150, $174, $186, $204, $228, $255, $312, $501, $672
}


{ : org $C1571C ;571C - 5C31
lure_ratings:

    ;each bait has 7 ratings, one per stage

    ;crank bait
    db 5, 5, 8, 5, 2, 5, 8 ;00: deep crank 18ft
    db 5, 5, 8, 5, 2, 5, 8 ;01: deep crank 18ft
    db 5, 5, 8, 5, 2, 5, 8 ;02: deep crank 18ft

    db 5, 5, 8, 5, 2, 5, 8 ;03: deep crank 12ft
    db 5, 5, 8, 5, 2, 5, 8 ;04: deep crank 12ft
    db 5, 5, 8, 5, 2, 5, 8 ;05: deep crank 12ft

    db 5, 5, 8, 5, 2, 5, 8 ;06: deep crank 9ft
    db 5, 5, 8, 5, 2, 5, 8 ;07: deep crank 9ft
    db 5, 5, 8, 5, 2, 5, 8 ;08: deep crank 9ft

    db 8, 7, 7, 4, 3, 7, 7 ;09: shallow crank 6ft
    db 8, 7, 7, 4, 3, 7, 7 ;0A: shallow crank 6ft
    db 8, 7, 7, 4, 3, 7, 7 ;0B: shallow crank 6ft

    db 6, 8, 8, 4, 4, 8, 8 ;0C: shallow crank 3ft
    db 6, 8, 8, 4, 4, 8, 8 ;0D: shallow crank 3ft
    db 6, 8, 8, 4, 4, 8, 8 ;0E: shallow crank 3ft

    db 6, 4, 8, 5, 4, 4, 8 ;0F: lipless crank rattle
    db 6, 4, 8, 5, 4, 4, 8 ;10: lipless crank rattle
    db 6, 4, 8, 5, 4, 4, 8 ;11: lipless crank rattle

    db 6, 4, 8, 5, 4, 4, 8 ;12: lipless crank silent
    db 6, 4, 8, 5, 4, 4, 8 ;13: lipless crank silent
    db 6, 4, 8, 5, 4, 4, 8 ;14: lipless crank silent

    ;minnow plug
    db 0, 6, 2, 4, 8, 0, 2 ;15: long bill 5 inch
    db 0, 6, 2, 4, 8, 0, 2 ;16: long bill 5 inch
    db 0, 6, 2, 4, 8, 0, 2 ;17: long bill 5 inch

    db 7, 6, 6, 0, 0, 7, 6 ;18: jerk bait 4 inch
    db 7, 6, 6, 0, 0, 7, 6 ;19: jerk bait 4 inch
    db 7, 6, 6, 0, 0, 7, 6 ;1A: jerk bait 4 inch

    db 6, 6, 6, 0, 4, 3, 6 ;1B: long bill 2.5 inch
    db 6, 6, 6, 0, 4, 3, 6 ;1C: long bill 2.5 inch
    db 6, 6, 6, 0, 4, 3, 6 ;1D: long bill 2.5 inch

    db 6, 6, 6, 0, 4, 3, 6 ;1E: jerk bait 2.5 inch
    db 6, 6, 6, 0, 4, 3, 6 ;1F: jerk bait 2.5 inch
    db 6, 6, 6, 0, 4, 3, 6 ;20: jerk bait 2.5 inch

    ;topwater plug
    db 6, 6, 5, 5, 0, 4, 5 ;21: popper
    db 6, 6, 5, 5, 0, 4, 5 ;22: popper

    db 7, 8, 6, 8, 8, 8, 6 ;23: stick bait
    db 7, 8, 6, 8, 8, 8, 6 ;24: stick bait
    db 7, 8, 6, 8, 8, 8, 6 ;25: stick bait

    ;buzz bait
    db 6, 7, 8, 1, 1, 6, 8 ;26: buzz bait 1/2 oz
    db 6, 7, 8, 1, 1, 6, 8 ;27: buzz bait 1/2 oz
    db 6, 7, 8, 1, 1, 6, 8 ;28: buzz bait 1/2 oz
    db 6, 7, 8, 1, 1, 6, 8 ;29: buzz bait 1/2 oz
    db 6, 7, 8, 1, 1, 6, 8 ;2A: buzz bait 1/4 oz
    db 6, 7, 8, 1, 1, 6, 8 ;2B: buzz bait 1/4 oz
    db 6, 7, 8, 1, 1, 6, 8 ;2C: buzz bait 1/4 oz
    db 6, 7, 8, 1, 1, 6, 8 ;2D: buzz bait 1/4 oz

    ;spinner bait
    db 7, 4, 6, 2, 4, 7, 6 ;2E: single willow leaf 1/2 oz
    db 7, 3, 5, 1, 3, 7, 5 ;2F: single willow leaf 1/2 oz
    db 7, 5, 6, 1, 1, 6, 6 ;30: single willow leaf 1/4 oz
    db 6, 4, 5, 1, 1, 5, 5 ;31: single willow leaf 1/4 oz
    db 7, 3, 5, 1, 3, 7, 5 ;32: single willow leaf 1/2 oz
    db 7, 3, 5, 1, 3, 7, 5 ;33: single willow leaf 1/2 oz
    db 6, 4, 5, 1, 1, 5, 5 ;34: single willow leaf 1/4 oz
    db 6, 4, 5, 1, 1, 5, 5 ;35: single willow leaf 1/4 oz
    db 6, 6, 6, 1, 2, 6, 6 ;36: colorado 1/2 oz
    db 5, 5, 5, 0, 1, 5, 5 ;37: colorado 1/2 oz
    db 4, 7, 5, 6, 2, 4, 5 ;38: colorado 1/4 oz
    db 3, 7, 4, 5, 1, 3, 4 ;39: colorado 1/4 oz
    db 5, 5, 5, 0, 1, 5, 5 ;3A: colorado 1/2 oz
    db 5, 5, 5, 0, 1, 5, 5 ;3B: colorado 1/2 oz
    db 3, 7, 4, 5, 1, 3, 4 ;3C: colorado 1/4 oz
    db 3, 7, 4, 5, 1, 3, 4 ;3D: colorado 1/4 oz
    db 6, 4, 7, 5, 5, 7, 7 ;3E: double willow leaf 1/2 oz
    db 6, 4, 7, 5, 5, 7, 7 ;3F: double willow leaf 1/2 oz
    db 6, 4, 7, 5, 5, 7, 7 ;40: double willow leaf 1/2 oz
    db 6, 4, 7, 5, 5, 7, 7 ;41: double willow leaf 1/2 oz
    db 7, 4, 6, 4, 0, 6, 6 ;42: colorado 1/2 oz
    db 7, 4, 6, 4, 0, 6, 6 ;43: colorado 1/2 oz
    db 5, 8, 7, 0, 0, 4, 7 ;44: colorado 1/4 oz
    db 5, 8, 7, 0, 0, 4, 7 ;45: colorado 1/4 oz

    ;rubber jig
    db 2, 2, 6, 4, 2, 2, 6 ;46: rubber jig 1/4 oz
    db 2, 2, 6, 4, 2, 2, 6 ;47: rubber jig 1/4 oz
    db 2, 2, 4, 5, 2, 2, 4 ;48: rubber jig 3/8 oz
    db 2, 2, 4, 5, 2, 2, 4 ;49: rubber jig 3/8 oz
    db 3, 1, 5, 5, 4, 3, 5 ;4A: rubber jig 1/2 oz
    db 3, 1, 5, 5, 4, 3, 5 ;4B: rubber jig 1/2 oz
    db 2, 2, 6, 4, 2, 2, 6 ;4C: rubber jig 1/4 oz
    db 2, 2, 6, 4, 2, 2, 6 ;4D: rubber jig 1/4 oz
    db 2, 2, 4, 6, 2, 2, 4 ;4E: rubber jig 3/8 oz
    db 2, 2, 4, 6, 2, 2, 4 ;4F: rubber jig 3/8 oz
    db 2, 1, 5, 5, 4, 3, 5 ;50: rubber jig 1/2 oz
    db 3, 1, 5, 5, 4, 3, 5 ;51: rubber jig 1/2 oz
    db 2, 2, 4, 5, 5, 2, 4 ;52: rubber jig 1 oz
    db 2, 2, 4, 5, 5, 2, 4 ;53: rubber jig 1 oz
    db 3, 4, 5, 1, 0, 5, 5 ;54: flipping jig 3/8 oz
    db 3, 4, 5, 1, 0, 5, 5 ;55: flipping jig 5/8 oz
    db 3, 4, 5, 1, 0, 5, 5 ;56: flipping jig 1 oz

    ;rig
    db 4, 4, 2, 2, 2, 4, 2 ;57: jig head 1/32 oz
    db 3, 4, 3, 3, 1, 3, 3 ;58: jig head 1/16 oz
    db 2, 3, 4, 3, 1, 1, 4 ;59: jig head 1/8 oz
    db 1, 2, 3, 2, 1, 1, 3 ;5A: jig head 3/16 oz
    db 1, 1, 4, 3, 2, 0, 4 ;5B: jig head 1/4 oz
    db 3, 3, 3, 2, 2, 3, 3 ;5C: texas rig 1/8 oz
    db 3, 3, 3, 2, 2, 3, 3 ;5D: texas rig 3/16 oz
    db 3, 3, 3, 2, 2, 3, 3 ;5E: texas rig 1/4 oz
    db 3, 2, 3, 3, 3, 2, 3 ;5F: florida rig 1/16 oz
    db 3, 2, 3, 3, 3, 2, 3 ;60: florida rig 1/8 oz     !!bug!! bait ratings gets ratings starting from the last rating here!
    db 3, 2, 3, 3, 3, 2, 3 ;61: florida rig 3/16 oz
    db 3, 2, 3, 3, 3, 2, 3 ;62: florida rig 1/4 oz
    db 3, 2, 3, 3, 3, 2, 3 ;63: florida rig 1/2 oz
    db 2, 1, 3, 4, 4, 1, 3 ;64: carolina rig 1 oz, 2 ft
    db 3, 2, 1, 1, 1, 2, 1 ;65: carolina rig 1 oz, 2.5 ft
    db 4, 4, 2, 1, 1, 4, 2 ;66: carolina rig 1 oz, 3 ft
    db 2, 1, 3, 4, 4, 1, 3 ;67: carolina rig 1/2 oz, 2 ft
    db 3, 2, 1, 1, 1, 2, 1 ;68: carolina rig 1/2 oz, 2.5 ft
    db 4, 4, 2, 1, 1, 4, 2 ;69: carolina rig 1/2 oz, 3 ft
    db 3, 2, 2, 3, 1, 2, 2 ;6A: carolina rig 1/4 oz, 2 ft
    db 3, 3, 3, 2, 1, 2, 3 ;6B: carolina rig 1/4 oz, 2.5 ft
    db 2, 4, 4, 3, 1, 1, 4 ;6C: carolina rig 1/4 oz, 3 ft
    db 4, 3, 2, 1, 1, 4, 2 ;6D: split shot rig 1 ft
    db 3, 3, 3, 3, 3, 4, 3 ;6E: split shot rig 1.5 ft
    db 1, 4, 3, 4, 1, 0, 3 ;6F: split shot rig 2 ft
    db 4, 3, 4, 0, 0, 4, 4 ;70: weightless

    ;bait
    db 2, 2, 4, 3, 1, 1, 4 ;71: straight worm 6 inch
    db 1, 1, 4, 4, 2, 0, 4 ;72: straight worm 6 inch
    db 3, 2, 2, 2, 1, 4, 2 ;73: straight worm 6 inch
    db 3, 2, 4, 3, 1, 2, 4 ;74: straight worm 4 inch
    db 2, 1, 4, 4, 2, 1, 4 ;75: straight worm 4 inch
    db 4, 2, 2, 2, 1, 4, 2 ;76: straight worm 4 inch
    db 1, 4, 4, 1, 0, 1, 4 ;77: straight worm 4 inch
    db 4, 2, 3, 3, 2, 4, 3 ;78: straight worm 4 inch
    db 2, 3, 3, 2, 0, 1, 3 ;79: straight worm 4 inch
    db 4, 2, 2, 3, 2, 3, 2 ;7A: worm 3.5 inch
    db 4, 2, 3, 2, 2, 4, 3 ;7B: worm 3.5 inch
    db 2, 4, 4, 1, 0, 1, 4 ;7C: worm 3.5 inch
    db 2, 3, 4, 3, 1, 3, 4 ;7D: worm 3.5 inch
    db 2, 2, 2, 3, 3, 1, 2 ;7E: straight worm 3.5 inch
    db 3, 2, 3, 2, 1, 3, 3 ;7F: straight worm 3.5 inch
    db 3, 2, 2, 3, 2, 2, 2 ;80: straight worm 3.5 inch
    db 2, 2, 2, 2, 2, 2, 2 ;81: ring worm 4 inch
    db 2, 2, 2, 2, 2, 2, 2 ;82: ring worm 4 inch
    db 2, 2, 2, 2, 2, 2, 2 ;83: ring worm 4 inch
    db 3, 2, 2, 3, 1, 2, 2 ;84: straight worm 4 inch
    db 1, 4, 4, 1, 1, 0, 4 ;85: straight worm 4 inch
    db 3, 1, 1, 2, 2, 2, 1 ;86: straight worm 4 inch

    db 4, 3, 2, 1, 1, 4, 2 ;87: stick bait 5 inch
    db 3, 2, 2, 0, 0, 2, 2 ;88: stick bait 5 inch
    db 2, 3, 4, 2, 1, 3, 4 ;89: paddle tail 4.5 inch
    db 3, 3, 3, 3, 1, 4, 3 ;8A: paddle tail 3 inch
    db 2, 3, 4, 1, 0, 2, 4 ;8B: paddle tail 5 inch
    db 2, 3, 4, 1, 0, 2, 4 ;8C: paddle tail 5 inch
    db 2, 2, 3, 2, 1, 1, 3 ;8D: paddle tail 3 inch
    db 2, 2, 3, 2, 1, 1, 3 ;8E: paddle tail 3 inch
    db 4, 2, 3, 1, 1, 3, 3 ;8F: tube bait 5 inch
    db 4, 2, 3, 1, 1, 3, 3 ;90: tube bait 5 inch
    db 4, 2, 3, 1, 1, 3, 3 ;91: tube bait 5 inch
    db 4, 3, 3, 3, 3, 3, 3 ;92: tube bait 4 inch
    db 4, 3, 3, 3, 3, 3, 3 ;93: tube bait 4 inch
    db 4, 3, 3, 3, 3, 3, 3 ;94: tube bait 4 inch
    db 2, 4, 4, 3, 3, 4, 4 ;95: tube bait 3 inch
    db 2, 4, 4, 3, 3, 4, 4 ;96: tube bait 3 inch
    db 2, 4, 4, 3, 3, 4, 4 ;97: tube bait 3 inch

    db 3, 3, 3, 2, 1, 3, 3 ;98: grub 6 inch
    db 3, 3, 3, 2, 1, 3, 3 ;99: grub 6 inch
    db 3, 3, 3, 2, 1, 3, 3 ;9A: grub 6 inch
    db 4, 2, 3, 2, 1, 4, 3 ;9B: grub 6 inch            !!bug!! last grub bait gets values starting from the second rating here!
    db 4, 2, 3, 2, 1, 4, 3 ;9C: grub 8 inch            !!bug!! any ratings after the first rating here goes unused
    db 4, 2, 3, 2, 1, 4, 3 ;9D: grub 8 inch
    db 4, 2, 3, 2, 1, 4, 3 ;9E: grub 8 inch
    db 4, 2, 4, 1, 1, 3, 4 ;9F: grub 5 inch
    db 4, 2, 4, 1, 1, 3, 4 ;A0: grub 5 inch
    db 4, 2, 4, 1, 1, 3, 4 ;A1: grub 5 inch
    db 3, 3, 3, 2, 1, 3, 3 ;A2: grub 5 inch
    db 3, 3, 3, 2, 1, 3, 3 ;A3: grub 5 inch
    db 3, 3, 3, 2, 1, 3, 3 ;A4: grub 5 inch
    db 3, 3, 3, 2, 1, 3, 3 ;A5: grub 5 inch
    db 3, 3, 3, 2, 1, 3, 3 ;A6: grub 5 inch
    db 3, 4, 4, 2, 1, 4, 4 ;A7: grub 4 inch
    db 3, 4, 4, 2, 1, 4, 4 ;A8: grub 4 inch
    db 3, 4, 4, 2, 1, 4, 4 ;A9: grub 4 inch
    db 3, 4, 4, 2, 1, 4, 4 ;AA: grub 4 inch
    db 3, 3, 3, 2, 1, 3, 3 ;AB: grub 5 inch
    db 3, 3, 3, 2, 1, 3, 3 ;AC: grub 5 inch
    db 3, 3, 3, 2, 1, 3, 3 ;AD: grub 5 inch
    db 3, 3, 3, 2, 1, 3, 3 ;AE: grub 5 inch
    db 3, 3, 3, 2, 1, 3, 3 ;AF: grub 5 inch
    db 3, 4, 4, 2, 1, 4, 4 ;B0: grub 4 inch
    db 3, 4, 4, 2, 1, 4, 4 ;B1: grub 4 inch
    db 3, 4, 4, 2, 1, 4, 4 ;B2: grub 4 inch
    db 3, 4, 4, 2, 1, 4, 4 ;B3: grub 4 inch
    db 3, 4, 4, 2, 1, 4, 4 ;B4: grub 4 inch
    db 3, 4, 4, 2, 1, 4, 4 ;B5: grub 4 inch

    db 0, 0, 0, 0, 0, 0, 0 ;B6: pork
    db 0, 0, 0, 0, 0, 0, 0 ;B7: pork
    db 0, 0, 0, 0, 0, 0, 0 ;B8: pork
    db 0, 0, 0, 0, 0, 0, 0 ;B9: pork
}


{ : org $C1D90B ;D90B -
zone_rating:

.stage_offset: dw .spring, $DE51, $E389, $E8C1, $EDF9, .championship, $E389

;-----

.spring: .championship:
    dw ..a0, ..a1, ..a2, $D9A3, $D9C9, $D9EF, $DA0F, $DA39
    dw $DA51, $DA6D, $DAA3, $DAE1, $DB0F, $DB31, $DB55, $DB91
    dw $DBB1, $DBCB, $DC3D, $DC83, $DCB5, $DCB9, $DCD1, $DCF5
    dw $DD25, $DD45, $DD67, $DD87, $DDCD, $DE25, $DE3B

..a0: dw ...s0, ...s1, ...s2, ...s3
    ...s0: dw $0100
    ...s1: dw $0100
    ...s2: dw $0200
    ...s3: dw $0200

..a1: dw ...s0, ...s1, ...s2, ...s3
    ...s0: dw $0500, $0200, $0300
    ...s1: dw $0600
    ...s2: dw $0400, $0600, $0500
    ...s3: dw $0400, $0500, $0400, $0300, $0300

..a2: dw ...s0, ...s1, ...s2, ...s3
    ...s0: dw $0600, $0500, $0600, $0500
    ...s1: dw $0400, $0400
    ...s2: dw $0300
    ...s3: dw $0300, $0400, $0700

    ;todo
}
