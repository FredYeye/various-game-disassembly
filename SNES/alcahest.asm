lorom

;snes registers
{
    !WRMPYA   = $4202 ;Set unsigned 8bit Multiplicand
    !WRMPYB   = $4203 ;Set unsigned 8bit Multiplier and Start Multiplication
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

{ : org $808A0D
_rng: ;a16 x16
    pha
    phx
    ldx #$000B
.8A12:
    asl $000A
    !A8
    rol #2
    eor $000A
    rol
    eor $000A
    lsr #2
    eor #$FF
    and #$01
    ora $000A
    sta $000A
    !A16
    dex
    bne .8A12

    plx
    pla
    beq .8A4C

    !A8
    sta !WRMPYA
    lda $000A
    sta !WRMPYB
    nop
    !A16
    lda !RDMPYL
    and #$FF00
    xba
    rtl

.8A4C:
    lda $000A
    and #$00FF
    rtl
}

{ : org $8C9322
_8C9322:
    dw .936C, .937B, .9388, $9395, $93A4, $93AB, $93B4, $93BD
    dw $93C6, $93CF, $93D8, $93E1, $93EA, $93F3, $93FA, $9403
    dw $940C, $9415, $941E, $9427, $9432, $943B, $9446, $9451
    dw $9458, $9463, $946A, $9475, $947C, $9485, $948E, $9497
    dw $949C, $949F, $94A6, $94AD, $94B4

.936C: dw $8580, $0480, $A080, $7C80, $7B80, $C980, $7880 : db $00
.937B: dw $4080, $6E80, $3D80, $4080, $7980, $7880 : db $00
.9388: dw $3880, $7680, $3680, $4080, $5280, $6B80 : db $00
;...
.94B4: dw $6480, $7680, $5C80 : db $00 ;HO RO BI

;---

.94BB: ;password extensions
    dw .94D3, $94D6, $94D9, $94E0, $94E7, $94EC, $94F3, $94FC, $9501, $950A, $9511, .951A

.94D3:
;...
.951A: dw $5780, $3380, $2F80 : db $00 ;NO O U
}

{ : org $8CE916
_8CE916: dw $4080, $7080, $2F80, $7380, $5780, $4D80, $7480, $3780 : db $00 ;SHI yo U RI NO TSU RU GI
}

{ : org $8DF032
_8DF032: ;password
    lda $0BD5 ;first password char
    and #$00FF
    bne .F047

    ;only blank chars
    ldy #$0001 : sty $103C
    ldy #$FFFF : sty $1C1E
    rtl

.F047:
    !A8
    ldx #$0000
.F04C: ;credits password check
    lda _8CE916,X ;load credits password
    beq .F05A     ;branch if at terminator byte ($00)

    cmp $0BD5,X   ;compare with entered password
    bne .F072

    inx
    bra .F04C

.F05A:
    lda $0BD5,X
    bne .F072     ;branch if entered password keeps going

    !A16
    lda #$0007 : sta $103C
    lda #$FFFF : sta $1C1E : sta $1997
    inc
    rtl

.F072: ;normal password check
    !A16
    stz $1D8B
    lda #$008C : STA $1A
    ldx #$004A
.F07F:
    !A16
    dex #2
    bpl .F08C

    jsr $EEFE
    lda #$0001
    rtl

.F08C:
    lda #$0BD5 : sta $1C
    lda $8C9322,X : sta $18
    ldy #$0000
    !A8
.F09C:
    lda [$18],Y ;load password char
    beq .F0A7   ;terminator byte check

    cmp ($1C),Y ;compare against entered password
    bne .F07F   ;branch if not a match

    iny
    bne .F09C

.F0A7: ;first part of password matches. try next part, if any
    !A16
    stx $00
    tya
    clc
    adc $1C
    sta $1C
    sta $04
    lda $8DF19C,X : sta $1855
    lda $8DF152,X : sta $1C1E
    cmp #$0003
    bcc .F103

    ldx #$0018
.F0C9:
    !A6
    dex #2
    bpl .F0D3

    ldx $00
    bra .F07F

.F0D3:
    lda .F1E6,X
    cmp $1C1E
    bne .F0C9

    lda _8C9322_94BB,X : sta $18
    ldy #$0000
    !A8
    lda [$18],Y
    beq .F0F2

    cmp ($1C),Y
    bne .F0C9

.F0F2: ;third section
    !A16
    stx $02
    lda .F1FE,X : sta $1D8B
    tya
    clc
    adc $1C
    sta $1C
.F103:
    ldx #$0048
    lda .F216,X
    cmp $1C1E
    beq .F12A ;branch if matching level id(?)

.F12A:
    lda $8C9521,X : sta $18
    ldy #$0000
    !A8
    lda [$18],Y
    beq .F140

    cmp ($1C),Y
    bne .F10F
    iny
    bra .F135

.F1E6: dw $0003, $0003, $0004, $0004, $0005, $0005, $0006, $0006, $0006, $0007, $0007, $0007

.F1FE: dw $0000, $0001, $0000, $0001, $0000, $0001, $0000, $0001, $0002, $0000, $0001, $0002

.F216:
    dw $0000, $0000, $0001, $0001, $0002, $0002, $0002, $0003,
    dw $0003, $0003, $0003, $0004, $0004, $0004, $0004, $0004,
    dw $0005, $0005, $0005, $0005, $0005, $0005, $0006, $0006,
    dw $0006, $0006, $0006, $0006, $0006, $0007, $0007, $0007,
    dw $0007, $0007, $0007, $0007, $0007,
}
