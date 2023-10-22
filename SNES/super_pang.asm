; 1AB4F: unicorn

lorom

{ ;toggle register widths
    !A8   = "sep #$20"
    !A16  = "rep #$20"

    !X8   = "sep #$10"
    !X16  = "rep #$10"

    !AX8  = "sep #$30"
    !AX16 = "rep #$30"
}

{ ;engine defines
    !difficulty = $B1
    !stage = $C3
    !lives = $00C7
    !credits = $C8
    !score = $0161
    !food = $0167
    !timer = $0186
    !timer_frames = $0188
    !stage_layout = $1720

    ;breakable block byte
    ;1bxx xxll
    ;b = 0:breakable, 1:solid
    ;x = item ID
    ;l = block width - 1
}

;---------- 00

{ : org $0089AA ;89AA - 89CA
_0089AA: ;rng
    !A16
    lda $1A5B
    asl
    clc
    adc $1A5B
    sta $0020
    !A8
    xba
    clc
    adc $1A5B
    sta $1A5B
    sta $0020
    lda $0021
    sta $1A5C
    rtl
}

{ : org $008D0D ;8D0D -
_008D0D:
    ;create stage walls / ceiling / floor
}

{ : org $0098B5 ;98B5 -
_0098B5:
    ;todo
org $0098D6
    jsr _008D0D ;create walls / ceiling / floor
    jsl _02C270 ;solid blocks
    jsl _02C3B1 ;breakable blocks
    jsl _02C4F2 ;hidden blocks
    ;todo
}

{ : org $00CB18 ;CB18 -
_00CB18:
	dw $0008, $0058, $00A8, $00A8

.easy:
	dw .CC10, .CC12, .CC19, $CC1B, .CC5D, $CC8D, $CCD2, $CCEA
	dw $CD08, $CD33, $CD81, $CDB1, $CDEE, $CE2A, $CE48, $CE9F
	dw $CEE1, $CF0E, $CF13, $CF5E, $CFCD, $D015, $D017, $D02F
	dw $D03C, $D09F, $D0DF, $D113, $D134, $D164, $D185, $D1EE
	dw $D218, $D251, $D25D, $D27B, $D38C, $D3F5, $D476, $D489

.normal:
	dw .CC10, .CC12, .CC19, .CC35, $CC71, $CCA4, $CCD7, $CCF8
	dw $CD0D, $CD3E, $CD8F, $CDB1, $CE02, $CE2F, $CE65, $CEA4
	dw $CEEC, $CF0E, $CF2A, $CF66, $CFFC, $D015, $D01F, $D03A
	dw $D047, $D0BF, $D0DF, $D11B, $D139, $D16C, $D199, $D1F6
	dw $D223, $D253, $D26B, $D286, $D3B5, $D427, $D47B, $D4B5

.hard:
.expert:
	dw .CC10, .CC14, .CC19, $CC43, $CC85, $CCBB, $CCE8, $CD00
	dw .CC12, $CD5B, $CD9A, $CDC8, $CE16, $CE3A, $CE82, $CEC4
	dw $CEFD, $CF0E, $CF4A, $CFB3, $D010, $D015, $D027, $D03A
	dw $D05B, $D0BF, $D0F9, $D129, $D15F, $D174, $D1C8, $D20D
	dw $D23A, $D258, $D270, $D372, $D3D5, $D450, $D47B, $D4D2


.CC10:
	db $00, $00

.CC12:
    db $00, $00

.CC14:
    db $01
    dw $019E : db $02
    db $00

.CC19:
    db $00

.CC35:
    db $04
    dw $0494 : db $01
    dw $04AA : db $01
    dw $0514 : db $01
    dw $052A : db $01
    db $00

.CC5D:
    db $04
    dw $00C4 : db $0D
    dw $00E2 : db $0D
    dw $05C2 : db $02
    dw $05FA : db $02
}

;---------- 01

{ : org $01A85F ;A85F -
_01A85F:
    lda $00F4
    tax
    jmp (+,X) : +: dw .A876, .A876, .A880, $A88A, $A894, $A89E, $A8A8, $A8B2

;---

.A876:
    lda !timer
    cmp #$63
    beq .A87E

    rts

.A87E:
    bra .A8BC

;---

.A880:
    lda !timer
    cmp #$72
    beq .A888
    rts

.A888:
    bra .A8BC

;---

    ;todo

;---

.A8BC:
    lda $1A
    bne .A8E8

    jsl _0089AA : and #$0F : tax ;rng
    lda !lives
    dec
    beq .A8E9

    cmp #$04
    bcs .A8DF

    cmp #$02
    bcs .A8DA

    lda $9511,X ;14/16 chance
    bra .A8E2

.A8DA:
    lda $9521,X ;12/16 chance
    bra .A8E2

.A8DF:
    lda $9531,X ; 8/16 chance
.A8E2:
    bne .A8E9

    lda #$01 : sta $1A
.A8E8:
    rts

.A8E9:
    jsr $A674 ;get obj slot?
    bcc .A8F1

    !A8
    rts

.A8F1:
    ply
    lda #$02 : sta $00F5 : sta $0000,X
    lda #$06 : sta $0011,X
    !X8
    lda $0AC7
    bne .A90C

    ;todo
.A90C:
}

;---------- 02

{ : org $02C270 ;C270 - C314
_02C270: ;place solid blocks
    pea $0300
    plb
    lda !difficulty : asl : tax
    lda !stage : asl
    rep #$31 ;A, X, C=0
    and #$00FF
    adc.w _00CB18,X
    tay
    ldx.w _00CB18,Y
    lda $0000,X
    and #$00FF
    beq .C2C7

    sta $2C
.C291:
    lda $0001,X
    lsr
    clc
    adc #$1700
    tay
    lda $0001,X
    clc
    adc #$E800
    sta $00
    lda #$007F : sta $02
    !A8
    lda $0003,X : and #$FF : sta $2E
    lda #$FF
.C2B3:
	sta $0000,Y
    iny
    dec $2E
    bne .C2B3

    jsr $C315
    !A16
    inx #3
    dec $2C
    bne .C291

.C2C7:
    inx
    lda $0000,X
    and #$00FF
    beq .C311

    sta $2C
.C2D2:
    lda $0001,X
    lsr
    clc
    adc #$1700
    tay
    lda $0001,X
    clc
    adc #$E800
    sta $00
    lda #$007F : sta $02
    !A8
    lda $0003,X : and #$FF : sta $2E
.C2F2:
    lda #$FF : sta $0000,Y
    !A16
    tya
    clc
    adc #$0020
    tay
    !A8
    dec $2E
    bne .C2F2

    jsr $C350
    !A16
    inx #3
    dec $2C
    bne .C2D2

.C311:
    !AX8
    plb
    rtl
}

{ : org $02C3B1 ;C3B1 -
_02C3B1: ;place breakable blocks
    lda !difficulty : asl : tax
    lda !stage : asl
    rep #$31 ;A, X, C=0
    and #$00FF
    adc.w _03BDF0,X
    tay
    ldx.w _03BDF0,Y
    stz $2E
.C3C6:
    lda $0000,X
    and #$00FF
    beq .C414

    sta $2A
.C3D0:
    lda $0001,X
    lsr
    clc
    adc #$1700
    tay
    lda $0001,X
    clc
    adc #$E800
    sta $00
    lda #$007F : sta $02
    !A8
    lda $0003,X : ora #$80 : sta $0000,Y
                  and #$03 : sta $2C
    stz $2D
    beq .C404

    lda #$00
.C3FB:
    iny
    inc
    sta $0000,Y
    dec $2C
    bne .C3FB

.C404:
    lda $2E
    bne .C40B

    jsr .C470
.C40B:
    !A16
    inx #3
    dec $2A
    bne .C3D0

.C414:
    inx
    lda $0000,X
    and #$00FF
    beq .C46D

    sta $2A
.C41F:
    lda $0001,X
    lsr
    clc
    adc #$1700
    tay
    lda $0001,X
    clc
    adc #$E800
    sta $00
    lda #$007F : sta $02
    !A8
    lda $0003,X : ora #$C0 : sta $0000,Y
                  and #$03 : sta $2C
    lda #$40 : sta $20
.C448:
    !A16
    tya
    clc
    adc #$0020
    tay
    !A8
    inc $20
    lda $20 : sta $0000,Y
    dec $2C
    bne .C448

    lda $2E
    bne .C464

    jsr .C4B2
.C464:
    !A16
    inx #3
    dec $2A
    bne .C41F

.C46D:
    !AX8
    rtl

.C470:
    ;todo
.C4B2:
    ;todo
}

{
_02C4F2: ;place hidden blocks?
    lda #$01 : sta $2E
    lda !difficulty : asl : tax
    lda !stage : asl
    rep #$31 ;A, X, C=0
    and #$00FF
    adc $C526,X
    tay
    ldx $C526,Y
    jmp _02C3B1_C3C6
}

;---------- 03

{ : org $0394E9 ;94E9 - 9510
_0394E9:
    db $00, $00, $00, $02, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $04, $00, $00, $06, $00, $00
    db $00, $00, $00, $08, $00, $0A, $00, $00, $00, $00
    db $00, $00, $00, $00, $0C, $0E, $00, $00, $00, $00
}

{ ;9511 - 9540
_039511:
    db 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1
.9521:
    db 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1
.9531:
    db 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0
}

{ : org $03BDF0 ;BDF0 -
_03BDF0: ;breakable blocks
    dw $0008, $0058, $00A8, $00A8

.easy:
    dw .BEE8, .BEF8, $BF0D, $BF1D, $BF1F, $BFDE, $BFE6, $BF1D
    dw $C053, $C08F, $C0A4, $C0A6, $C119, $C121, $C130, $C130
    dw $C130, $C130, $C144, $C156, $C195, $C1A7, $C1AC, $C1B8
    dw $C1DA, $C1EC, $C216, $C253, $C271, $C319, $C346, $C348
    dw $C34A, $C36B, $C441, $C453, $C47D, $C4A1, $C4CB, $C50B

.normal:
    dw .BEE8, .BEFD, $BF15, .BF1D, $BF2A, $BFD6, $BFE8, $BFF5
    dw $C05B, $C094, $C0A4, $C0A6, $C121, $C123, $C130, $C132
    dw $C140, $C142, $C149, $C167, $C197, $C1A7, $C1AE, $C1BA
    dw $C1DC, $C1FA, $C216, $C25E, $C2EB, $C32A, $C346, $C348
    dw $C34F, $C36B, $C443, $C45B, $C488, $C4A6, $C509, $C510

.hard:
.expert:
    dw .BEED, $BF05, $BF15, $BF1D, $BF7A, $BF1D, $BFF0, $C024
    dw $C08A, $C09C, $C0A4, $C0E1, $C121, $C128, $C130, $BF1D
    dw $C140, $C142, $C14E, $C18A, $C1A5, $C1A7, $C1B0, $C1BA
    dw $C1DE, $C208, $C218, $C266, $C305, $C338, $C346, $C348
    dw $C366, $C3D9, $C44B, $C472, $C496, $C4C3, $C509, $C518

.BEE8:
    db $01
    dw $021C : db $07
    db $00

.BEED:
    db $03
    dw $021C : db $07
    dw $048C : db $2F
    dw $04AC : db $03
    db $00

.BEF8:
    db $01
    dw $029C : db $17
    db $00

.BEFD:
    ;todo

.BF1D:
    db $00, $00
}

{ : org $03C526
_03C526: ;hidden blocks
    dw $0008, $0058, $00A8, $00A8

.easy:
    dw $C62D, .C620, .C628, $C62F, $C63C, $C63E, $C659, $C65B
    dw $C65D, $C66A, $C66C, $C66E, $C678, $C684, $C686, $C686
    dw $C68D, $C69D, $C6A7, $C69D, $C6BC, $C6D1, $C6DE, $C6E8
    dw $C6FE, $C713, $C723, $C738, $C73D, $C74C, $C756, $C768
    dw $C777, $C792, $C797, $C7A9, $C7BE, $C7CD, $C7E2, $C7EF

.normal:
    dw .C61E, .C620, $C62D, $C634, $C63C, $C646, $C659, $C65B
    dw $C662, $C66A, $C66C, $C66E, $C678, $C682, $C686, $C688
    dw $C695, $C69D, $C69F, $C6B1, $C6C4, $C6D1, $C6DE, $C6F3
    dw $C703, $C718, $C72B, $C738, $C742, $C751, $C75E, $C76D
    dw $C77C, $C792, $C79C, $C7AE, $C7C3, $C7D5, $C7E7, $C7F4

.hard:
.expert:
    dw .C61E, .C620, $C62D, $C634, $C63C, $C64E, $C659, $C65B
    dw $C62D, $C66A, $C66C, $C673, $C67A, $C684, $C686, $C686
    dw $C686, $C686, $C6AC, $C686, $C6CC, $C6D1, $C6E3, $C6F3
    dw $C70B, $C718, $C733, $C738, $C747, $C751, $C763, $C772
    dw $C78D, $C792, $C7A1, $C7B3, $C7C8, $C7DD, $C7E7, $C7F4

.C61E:
    db $00, $00

.C620:
    db $02
    dw $0096 : db $04
    dw $0084 : db $2C
    db $00

.C628:
}

{ : org $03C7FE ;C7FE -
_03C7FE:
    db $04, $2C, $54, $54

.easy:
    db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF

.normal:
    db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    db $00, $FF, $FF, $FF, $FF, $FF, $FF, $00, $00, $00
    db $FF, $FF, $00, $FF, $FF, $FF, $FF, $FF, $FF, $FF

.hard:
.expert:
    db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
    db $FF, $FF, $FF, $FF, $FF, $02, $FF, $00, $FF, $00
    db $FF, $FF, $00, $FF, $FF, $FF, $FF, $FF, $FF, $FF
}
