;---------- F3 defines

!ram = 0x400000
!line_ram = 0x620000

;---------- engine defines

;relative to A5(0x408000)
!power_out = 0x3790 ;breaker box destroyed
!lights_out = 0x3792 ;lamps destroyed
;!line_ram_copy_offset =  0x4A68 ;offset into values to be copied over to line ram

;-----

_0BD5D8:
    ;A5: $408000

    move.w  D2, -(A7)
    sub.w   (0x0998, A5), D0 ;8998
    asr.w   #2, D0
    cmp.w   (0x099C, A5), D0 ;899C
    bcc.b   .D612

    move.w  D1, D2
    sub.w   (0x099A, A5), D2
    asr.w   #1, D2
    cmp.w   (0x099E, A5), D2 ;899E
    bcc.b   .D612

    movea.l (0x0984, A5), A0 ;8984
    move.w  (0, A0, D0.w * 2), D0
    neg.w   D0
    adda.w  (-2, A0, D0.w * 2), A0
    subq.w  #4, A0
.D604:
    addq.w  #4, A0
    cmp.w   (A0), D1
    blt.b   .D604

    move.w  (A0)+, D0
    adda.w  (A0), A0
    move.w  (A7)+, D2
    rts

.D612:
    move.w  #0x8000, D0
    movea.l #0x0BD5AE, A0
    move.w  (A7)+, D2
    rts

;-----

_0BD642:
    ;A5: $408000

    move.w  D2, -(A7)
    sub.w   (0x0998, A5), D0
    asr.w   #2, D0
    cmp.w   (0x099C,A5), D0
    bcc.b   .D67C

    move.w  D1, D2
    sub.w   (0x099A, A5), D2
    asr.w   #1, D2
    cmp.w   (0x099E, A5), D2
    bcc.b   .D67C

    movea.l (0x0988, A5), A0
    move.w  (0, A0, D0.w * 2), D0
    neg.w   D0
    adda.w  (-2, A0, D0.w * 2), A0
    subq.w  #4, A0
.D66E:
    addq.w  #4, A0
    cmp.w   (A0), D1
    bgt.b   .D66E

    move.w  (A0)+, D0
    adda.w  (A0), A0
    move.w  (A7)+, D2
    rts

.D67C:
    move.w  #0x7FFF, D0
    movea.l #0x0BD5AE, A0
    move.w  (A7)+, D2
    rts

;-----

_1503C6:
    link.w  A6, #0
    movem.l D4-D7, -(A7)
    movea.l (0x08, A6), A0
    move.w  (0x0C, A6), D7 ;start line to darken
    move.w  (0x0E, A6), D6 ;end line to darken
    move.w  (0x10, A6), D4 ;new opacity/blending(?)
    cmp.w   D6, D7
    ble.w   .03E6

    exg     D6, D7
.03E6:
    move.w  D4, (0, A0, D7.w * 2) ;set opacity/blending(?) for line
    addq.w  #1, D7
    cmp.w   D6, D7
    ble.b   .03E6

    movem.l (A7)+, D4-D7
    unlk    A6
    rts

;-----

_155472: ;ceiling lamp code, when crashed on the floor
	;A4: obj offset
	;A5: $408000

    tst.w   (!power_out, A5)
    beq.w   .54A6

	;not sure how to get here in-game
    bsr.w   0x1556F0
    move.l  #0x1553A2, (0x1C, A4)
    lea     (0x34, A4), A0
    move.l  A0, (0x20, A4)
    clr.w   (0x44, A4)
    move.l  #0x3B96, (0x0C, A4)
    move.w  #0x01, (0x44, A4)
    jmp     0x3B96.l

.54A6:
    move.w  (0xDC, A4), D0
    sub.w   (0x1BC6, A5), D0 ;$9BC6
    tst.w   D0
    blt.w   .5536

    move.w  (0x4A, A4), D0
    subq.w  #4, D0
    move.w  (0xDA, A4), D0
    sub.w   (0x1BC6, A5), D0 ;$9BC6
    cmpi.w  #0xE8, D0
    bge.w   .5536

    tst.w   (0x56, A4) ;if timer not zero
    bgt.w   .550E  ;branch to "dec lights out timer"

    lea     (0x4A68, A5), A0 ;CA68
    move.w  (0x4A, A4), D0
    sub.w   (0x1BC6, A5), D0 ;$9BC6
    subq.w  #8, D0
    cmpi.w  #0xBBBB, (0, A0, D0.w * 2)
    beq.w   .5518

    move.l  #_1558BA.58EC, (0xD6, A4)
    move.w  (_1558BA.58EC, PC), (0xD4, A4)
    nop
    move.l  #0x155316, (0x1C, A4)
    lea     (0x34, A4), A0
    move.l  A0, (0x20, A4)
    clr.w   (0x44, A4)
.550E:
    subq.w  #1, (0x56, A4) ;decrease lights out timer
    jmp     0x3AAC.l

.5518:
    subq.w  #1, (!lights_out, A5)
    move.l  #0x15533E, (0x1C, A4)
    lea     (0x34, A4), A0
    move.l  A0, (0x20, A4)
    clr.w   (0x44, A4)
    jmp     0x3AAC.l

.5536:
    bsr.w   0x155630
    jmp     0x3B96.l

;-----

_155540: ;don't know what this is
	bsr.w   0x1556F0
	jmp     0x3B96.l

;-----

_15554A: ;ceiling lamp code, when crashing
	;A4: obj offset
    ;A5: $408000

    move.w  #0x01A4, (0x56, A4) ;set "lights out" timer the first time. related to the flashing that happens when the lamp hits the floor?
    addi.w  #0x01, (!lights_out, A5)
    move.w  #0x00, (0x4DBC, A5) ;$CDBC
    move.w  (0x46, A4), D3
    move.w  (0x4A, A4), D4
    subq.w  #8, D4
    move.w  D4, D1
    move.w  D3, D0
    jsr     _0BD5D8.l
    cmpi.w  #0x8000, D0
    beq.w   .5594

    move.w  D0, (0xDA, A4)
    move.w  D4, D1
    move.w  D3, D0
    jsr     _0BD642.l
    cmpi.w  #0x7FFF, D0
    beq.w   .5594

    move.w  D0, (0xDC, A4)
    rts

.5594:
    move.l  #0x15533E, (0x1C, A4)
    lea     (0x34, A4), A0
    move.l  A0, (0x20, A4)
    clr.w   (0x44, A4)
    rts

;-----

_1555AA:
    move.w  (0x46, A4), D3
    move.w  (0x4A, A4), D4
    move.w  (0xDA, A4), D0
    move.w  (0xDC, A4), D2
    moveq   #0x00, D3
    move.w  (0x376A, A5), D1
    btst.l  #0x01, D1
    beq.w   .55CC

    move.w  (0x376C, A5), D3
.55CC:
    btst.l  #0x02, D1
    beq.w   .55D8

    add.w   (0x376E, A5), D3
.55D8:
    btst.l  #0x03, D1
    beq.w   .55E4

    add.w   (0x3770, A5), D3
.55E4:
    add.w   D3, D0
    add.w   D3, D2
    sub.w   (0x1BC6, A5), D0
    sub.w   (0x1BC6, A5), D2
    subq.w  #2, D0
    addq.w  #4, D2
    lea     (0x4A68, A5), A0 ;CA68
    movea.l (0xD6, A4), A1
    move.w  (0x02, A1), D1
    move.w  D1, -(A7) ;new opacity/blending(?)
    move.w  D2, -(A7) ;end line to darken
    move.w  D0, -(A7) ;start line to darken
    move.l  A0, -(A7)
    jsr     _1503C6.l
    lea     (0x0A, A7), A7
    move.w  #0x00, (0x4DBC, A5)
    rts

;-----

_1557AA:
    tst.w   (!power_out, A5)
    bne.w   .583A

    tst.w   (!lights_out, A5)
    beq.w   .583A

    tst.w   (0x4DBA, A5)
    beq.w   .583A

    tst.w   (0x4DBC, A5)
    beq.w   .57D6

    move.w  (0x376A, A5), D2
    btst.l  #0x03, D2
    beq.w   .583A

.57D6:
    move.w  (0x3770, A5), D2
    bpl.w   .5800

    move.w  #0x01E7, D1
    add.w   D2, D1
    asl.w   #1, D2
    lea     0x40CD38, A0
    lea     0x40CD38, A1
    adda.w  D2, A1
.57F4:
    move.w  (A1), (A0)
    subq.w  #2, A0
    subq.w  #2, A1
    dbf     D1, .57F4

    bra.b   .581C

.5800:
    move.w  #0x01E7, D1
    sub.w   D2, D1
    asl.w   #1, D2
    lea     0x40C968, A0
    lea     0x40C968, A1
    adda.w  D2, A1
.5816:
    move.w  (A1)+, (A0)+
    dbf     D1, .5816

.581C:
    move.w  #0x0073, D0
    lea     0x626200, A0 ;line ram, alpha blending control
    adda.w  (0x8140, A5), A0 ;0140
    lea     (0x4A68, A5), A1 ;CA68
.582E:
    move.l  (A1)+, (A0)+ ;set alpha blending control
    dbf     D0, .582E

    move.w  #0x00, (0x4DBA, A5)
.583A:
    rts

;-----

_15583C:
	;A4: obj offset
	;A5: $408000

    tst.w   (0x4DC8, A5) ;$CDC8
    bne.w   .5860

    subq.w  #1, (0xD4, A4)
    bge.w   .5860

    bsr.w   _1555AA
    addq.w  #4, A1 ;go forward in _1558BA array
    tst.w   (A1)
    bmi.w   .5866

    move.l  A1, (0xD6, A4)
    move.w  (A1), (0xD4, A4)
.5860:
    jmp     0x3AA6.l

.5866:
    move.l  #0x155230, (0x1C, A4)
    lea     (0x34 ,A4), A0
    move.l  A0, (0x20, A4)
    clr.w   (0x44, A4)
    move.w  #0xD2, (0x56, A4) ;set "lights out" timer the second time
    jmp     0x3AA6.l

;-----

_1558BA: ;values to send to line ram
    ;lights turning off
    d16 0x0001, 0xBBFB ;dark flashing
    d16 0x0001, 0x7B7B ;bright flashing
    d16 0x0001, 0xBBFB ;dark flashing
    d16 0x0001, 0x7B7B ;bright flashing
    d16 0x0001, 0xBBFB ;dark flashing
    d16 0x0000, 0x7B8B ;fade bright
    d16 0x0000, 0x7BAB ;fade
    d16 0x0000, 0x7BCB ;fade
    d16 0x0001, 0x7BEB ;fade
    d16 0x0001, 0x8BFB ;fade
    d16 0x0002, 0xABFB ;fade dark
    d16 0x0003, 0xCBFB ;lights off
    d16 0xFFFF

.58EC: ;lights coming back on again?
    d16 0x0001, 0x7BFB
    d16 0x0001, 0xBBFB
    d16 0x0001, 0x7BFB
    d16 0x0001, 0xBBFB
    d16 0x0004, 0xABFB
    d16 0x0003, 0x9BFB
    d16 0x0003, 0x8BFB
    d16 0xFFFF
