;note: this isn't written for any specific assembler

;-----

; ram variables

!frame_counter = $1D
!rng = $2E
!exp = $46 ;decimal
!hearts = $48 ;decimal
!player_hp = $80
!seconds = $84 ;"seconds" (15 frames per minute)
!minutes = $85
!hours = $86

; lists
; idx 0 = player
; idx 1-5 = weapons
; idx 6-? = enemies

; 0300 current sprite
!list_y_pos              = $0324
!list_y_pos_fractional   = $0336
!list_x_pos              = $0348
!list_x_pos_fractional   = $035A
!list_y_speed            = $036C
!list_y_speed_fractional = $037E
!list_x_speed            = $0390
!list x_speed_fractional = $03A2
; 03B4 state?
; 03C6 ?
; 03D8 ?
!list_facing             = $0420
; 0444 ?
; 0456 gravity, also used for other things
!list_hp = $04C2
; 04D4 ?
; 04F8 ?

;-----

_497F:
    ldx #$03 ;1-2 might be whip slots? so 3-5 are sub weapon slots
.8981:
    lda $03B4,X
    beq .898B

    lda $03C6,X
    beq .898E

.898B:
    jmp .8A89

.898E:
    lda $03B4,X
    cmp #$02
    beq .89AA

    cmp #$03
    beq .89AA

    cmp #$05
    beq .89AA

    cmp #$06
    beq .89AA

    tay
    lda $8BE7,Y
    sta $0B ;damage to deal
    jmp .89BE

.89AA:
    ;todo

.89BE:
    ldy #$06 ;first enemy slot
.89C0:
    lda $03B4,Y
    bne .89C8

.89C5:
    jmp .8A81

.89C8:
    cmp #$36
    beq .89C5

    cmp #$37
    beq .89C5

    cmp #$25
    beq .89E0

    lda $03C6,Y
    bne .89C5

    lda $03D8,Y
    and #$C2
    bne .89C5

.89E0:
    lda $04F8,Y
    beq .89E8

    jmp .8A81

.89E8:
    sty $97
    stx $93
    tya
    tax
    jsr $8C45
    ldx $93
    ldy $97
    lda $0348,X
    sec
    sbc $0348,Y
    bpl .8A03

    ;todo
.8A03:
    sbc $0A
    sec
    sbc #$04
    bmi .8A0E
 
    jmp .8A81

.8A0E:
    lda $0324,Y
    ;todo

.8A81:
    iny
    cpy #$12 ;end of enemy list
    beq .8A89

    jmp .89C0

.8A89:
    inx
    cpx #$06 ;weapon list ends at 5, enemy list starts at 6
    beq .8A9B

    jmp .8981

.8A9B:
    rts

;-----

update_rng: ;$C03C
	lda !rng
	clc
	adc !frame_counter
	sta !rng
	jmp update_rng ;loop indefinitely until next NMI

;-----

_7119: ;blob start
    lda $03D8,X
    bne .B125

    lda #$01
    ldy #$C3
    jmp $DED0

.B125:
    lda $0444,X
    jsr $C5BB

dw $B131, $B13F, $B189 ;used by C5BB to jump to code below

;---

_7131:
    inc $0444,X
    lda !rng
    and #$1F
    clc
    adc #$03
    sta $0468,X ;set wait timer to rand[0, 15] + 3
    rts

;---

_713F: ;blob wait on ground
    lda $0456,X ;$0456 used as a timer here
    cmp $0468,X
    beq .blob_jump

    inc $0456,X
    lda $0456,X
    and #$03
    bne .B15B

    lda $0300,X
    cmp #$C4
    beq $B15C

    inc $0300,X
.B15B:
    rts

.B15C:
	dec $0300,X
	rts

.blob_jump:
	lda #$00
	sta $0456,X
	sta $0468,X
	inc $0444,X
	lda #$C5
	sta $0300,X
	lda #$FD
	sta $036C,X ;y speed
	lda $2E ;rng
	and #$3F
	clc
	adc #$10
	sta $0456,X ;gravity = rand[0, 63] + 16
	jsr $E010
	lda #$01 ;x speed
	ldy #$40 ;x speed fractional
	jmp $E04F ;set x speed

;---

_7189: ;blob, mid jump
    lda $0456,X
    sta $08 ;gravity amount to apply
    jsr apply_gravity
    jsr $DE8B
    lda $036C,X
    bmi .B1A2 ;if speed is negative (going upwards), do nothing

    lda #$00
    ldy #$06
    jsr $E2A2 ;probably check if close to ground
    bcc .blob_land

.B1A2:
    jmp $E0F4

.blob_land
    lda #$C3
    sta $0300,X
    jsr $DE62
    lda #$0B
    jsr $C118
    lda #$00
    sta $0444,X
    sta $0456,X
    jmp $DF8A

;-----

apply_gravity: ;1DFE4
    lda #$00
    sta $09
    lda !list_y_speed_fractional,X
    clc
    adc $08
    sta !list_y_speed_fractional,X
    lda !list_y_speed,X
    adc $09
    sta !list_y_speed,X
    rts

;-----
