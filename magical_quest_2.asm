hirom


;toggle register widths
{
    !A8   = "sep #$20"
    !A16  = "rep #$20"

    !X8   = "sep #$10"
    !X16  = "rep #$10"

    !AX8  = "sep #$30"
    !AX16 = "rep #$30"
}


;engine defines
{
    !rng = $1BE8
}


;object defines
{
    !state1 = $02 ;main state
    !state2 = $03 ;sub state
    !state3 = $04 ;sub sub state
    !state4 = $05 ;sub sub sub state (lol)

    !pos_x = $0A
    !pos_y = $0D

;----- defines for modifying another object

    !pos_x2 = $000A
    !pos_y2 = $000D

;----- specific object defines

    ;turtle boss
    !shoot_counter = $3F
    !land_counter = $40
}


;----- 80


{ : org $80ADF5 ;ADF5 - AE04
_ADF5: ;pick action
    db 6, 6, 6, 6, 6, 6, 6, 6, 6, 6 ;land
    db 4, 4, 4, 4, 4, 4             ;shoot
}


;----- C0


{ : org $C02161 ;2161 - 2181
rng: ;a- x-
    !A16
    lda !rng
    asl
    clc
    adc !rng
    sta $0000
    !A8
    xba
    clc
    adc !rng
    sta !rng
    sta $0000
    lda $0001
    sta !rng+1
    rtl
}


;----- C2


{ : org $C2932D ;932D - 93A5
turtle_rise: ;a8 x8
    ldx !state3
    jmp (+,X) : +: dw .init, .run

.init: ;set some initial values and similar
    lda #$02 : sta !state3
    !A16
    lda #$0A80 : sta !pos_x+1
    lda #$0200 : sta !pos_y+1
    !A8
    lda #$02 : jsl $C02320
    ldx #$06 : jsl $C02508
    jsl $C0241B
    jsl $C0243A
    jsl $C0371C
    jsl $C03777 : sta $1C : sta $1D
.run:
    jsl $C02527               ;update Y pos
    !A16
    lda !pos_y+1 : cmp #$01C0 ;check Y position
    !A8
    bcs .ret                  ;exit if not high up enough

    jsl rng : and #$0F : tax
    lda.w _ADF5,X : cmp #$06 ;pick action at random; 5/8 chance for landing, 3/8 for shooting
    beq .check_land

;.check_shoot:
    lda !shoot_counter : cmp #$01
    bcc .set_shoot ;branch if shoot_counter is 0

    bra .set_land  ;otherwise, land instead

.check_land:
    lda !land_counter : cmp #$02 ;check if turtle has landed twice already
    bcc .set_land                ;branch if not

.set_shoot:
    inc !shoot_counter
    stz !land_counter
    lda #$04 ;shoot state
    bra .store_state

.set_land:
    inc !land_counter
    stz !shoot_counter
    lda #$06 ;land state
.store_state:
    sta !state2
    stz !state3
.ret:
    rts
}


{ : org $C29BD6 ;9BD6 - 9C02
create_bubble: ;a8 x8
    sta $0000   ;bubble type
    jsl $C0266C ;get slot, x = offset to slot
    bcs .ret

    lda #$08 : sta $0000,X ;8 means mark this object for creation the next frame
    lda #$2E : sta $0006,X ;type id?
    lda $0000 : sta $0007,X ;set bubble type
    lda $1D : sta $001D,X
    !A8
    lda !pos_x+1 : sta !pos_x2+1,X
    lda !pos_y+1 : sta !pos_y2+1,X
.ret:
    !AX8
    rts
}
