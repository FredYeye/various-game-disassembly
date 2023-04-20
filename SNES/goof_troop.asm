;wip

;!state1 $02
;!state2 $03
;!state3 $04
;!type $0A
;!hp_new 1C ?
;!hp_old 1D ?

;----- 80

{ ;8859 - 8879
rng:
    rep #$20
    lda $1A58
    asl
    clc
    adc $1A58
    sta $0000
    sep #$20
    xba
    clc
    adc $1A58
    sta $1A58
    sta $0000
    lda $0001
    sta $1A59
    rtl
}

;----- 81

{
_818397: ;run object
    tcd
    ldx $0A ;obj type?
    jmp ($839D,X)
}

{
_81C549: ;pete
    ldx $02
    jmp (+,X) : +: dw .C554, .C5E0, .D119

;---

.C554: ;create?
    ;todo

.C5E0: ;run?
    lda $1C
    cmp $1D
    bne .C5E9

    jmp .C675

.C5E9: ;take damage?
    sta $1D
    lda $00C8
    beq .C5F7

    stz $00C8
    jsl $809A29
.C5F7:
    ;todo

.C675:
    ldx $03
    jsr (.C69E,X)
    jsl $808A25
    jsl $8088CE
    lda $3E
    beq .C69D

    lda #$01 : sta $01
    dec $3E
    bne .C694

    stz $1F
    stz $2F
    bra .C69D

.C694:
    lda $009F
    and #$03
    bne .C69D

    sta $01
.C69D:
    rts

    .C69E: dw .C6AC, .C7D6, .C926, .CA36, .CD59, .CE8D, .CF80

;---

.C6AC:

;---

.C7D6: ;jump around
    ldx $04
    jmp (+,X) : +: dw .C7E7, .C84E, .C85E, .C8D9, .C90F, .C91F

;---

.C7E7:
.C84E:
.C85E:
.C8D9:
.C90F:
.C91F:

;---

.C926: ;spin in place, go to middle

;---

.CA36: ;jump to middle? and top? lots of things
    ldx $04
    jmp (+,X) : +: dw .CA59, .CA91, .CAFB, .CB2D, .CB41, .CB56, .CC00, .CC11, .CC26, .CC77, .CCA2, .CCDA, .CCFE, .CD06, .CD43

;---

.CA59:
.CA91: ;02: start jump
.CAFB: ;04: jumping up / jumping in general?
.CB2D: ;06: landing
.CB41: ;08: waiting
.CB56: ;0A: whistling
.CC00: ;0C: done whistling
.CC11: ;0E: pointing

;---

.CC26: ;10: pick action (spinning can also be selected from elsewhere, from landing maybe?)
    jsl rng
    and #$0F
    tax
    lda $A837,X
    beq .CC50

    dec
    beq .CC40

    sta $0047
    stz $0048
    lda #$1A : sta $04
    rts

.CC40:
    lda $00FB ;enemies killed on this screen? basically check if spawned pirates are still there
    cmp #$02
    beq .CC57

    lda #$08
    sta $03
    sta $46
    jmp $CDAF

.CC50:
    lda $00FB
    cmp #$02
    bne .CC5E

.CC57:
    lda #$08
    sta $03
    sta $04
    rts

.CC5E:
    lda #$12 : sta $04
    lda #$A6
    ldy #$BF
    jsl $80BF9F
    lda #$18 : sta $30
    lda #$A5
    ldy #$C9
    jsl $8089D7
    rts

;---

.CC77: ;12: spin wind up
.CCA2: ;14: spin
.CCDA: ;16: spin wind down
.CCFE: ;18: wait after spin
.CD06:
.CD43:

;---

.CD59:

;---

.CE8D: ;hook

;---

.CF80: ;spin
    ldx $04
    cpx #$08
    bne .CF8A

    lda $4E
    sta $11
.CF8A:
    jsr ($CFB1,X)
    ldx $04
    cpx #$08
    bne .CFB0

    lda $11
    sta $4E
    lda $009F
    and #$03
    bne .CFB0

    ldx #$FE
    lda $39
    and #$01
    beq .CFA8

    ldx #$02
.CFA8:
    txa
    clc
    adc $11
    sta $11
    inc $39
.CFB0:
    rts

.CFB1: dw .CFBF, .CFEC, .D00A, .D02B, .D087, .D0EA, .D10E

;---

.CFBF:
.CFEC:
.D00A:

;---

.D02B: ;wind up in place
    jsl $8089DE
    jsr $D392
    dec $30
    bne .D086

    lda #$08
    sta $04
    jsl rng
    and #$0F
    asl
    tax
.D049:
    rep #$10
    ldy $A847,X
    sty $4B
    rep #$10
    ldx $4B
    lda $0000,X
    sta $0D
    inc
    bne .D060

    sep #$10
    lda #$0A
    sta $04
    lda #$24
    sta $30
    rts

.D060:
    lda $0001,X : sta $30
    lda $0002,X : sta $47
    lda $0003,X : sta $48
    inx #4
    stx $4B
    sep #$10
    lda $0D
    tax
    lda $48
    ldy $47
    jsl $809252
    lda #$01 : sta $31
.D086:
    rts

;---

.D087: ;spin around
    jsr $D253
    lda $31
    bne .D094

    jsl $80C007
    bra .D096

.D094:
    dec $31
.D096:
    jsl $8089DE
    jsr $D392
    dec $30
    beq .D049

    lda $45
    bne .D0CA

    lda $14
    cmp #$80
    beq .D0B0

    inc
    cmp #$80
    bne .D0E9

.D0B0:
    inc $45
    jsl rng
    and #$0F
    tax
    lda $A92F,X
    sta $44
    jsl rng
    and #$1F
    sta $32
    lda #$01
    sta $33
.D0CA:
    dec $33
    bne .D0E9

    dec $44
    bne .D0D5

    stz $45
    rts

.D0D5:
    lda #$10
    sta $33
    ldx $32
    lda $A7F7,X
    sta $43
    txa
    inc
    and #$1F
    sta $32
    jsr $D410
.D0E9:
    rts

;---

.D0EA:
.D10E:

;---

.D119: ;destroy?
}

;----- 83

{
_83A837:
    db $00, $00, $00, $00, $00, $00 ;bomb
    db $01, $01, $01, $01, $01, $01 ;shoot
    db $C8, $C8, $C8, $C8           ;jump
}