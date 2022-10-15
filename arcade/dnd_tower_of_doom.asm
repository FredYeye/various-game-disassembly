_02E0E: ;rng
    tst.b   (0x8FAF, A5)
    bne.w   .02E80

    move.w  (0x2A, A5), D0
    bne.b   .02E24

    move.w  #0x2472, D0
    move.w  D0, (0x2A, A5)
.02E24:
    andi.w  #0x0202, D0
    move.w  D0, D1
    lsr.w   #8, D0
    eor.b   D0, D1
    andi.b  #0xEE, CCR
    beq.b   .02E38

    ori.b   #0x11, CCR
.02E38:
    roxr.w  (0x2A, A5)
    lea.l   (0x2A, A5), A0
    move.w  #0x07, D7
    moveq   #0, D0
.02E46:
    add.w   (A0), D0
    add.b   (0x0A, PC, D7.w), D0
    move.w  D0, (A0)+
    dbf.w   D7, .02E46
    rts

.02E54:
	d08 19, 17, 13, 11, 7, 5, 3, 1
    ;...

.02E80:
    rts