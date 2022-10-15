!rank = 0x1039C1
!difficulty = 0x1039C2

_02198C:
    clr.b   !rank
    tst.b   0x40048.l
    bne.b   .199C

    rts

.199C:
    move.b  !difficulty, D1
    lsl.b   #1, D1
    add.b   0x42E5B.l, D1
    move.b  0x1039C3.l, D0
    beq.b   .19BA

    lsl.b   #3, D0
    add.b   D0, D1
    bcc.b   .19BA

    moveq   #0x20, D1
.19BA:
    tst.b   0x10106D.l
    beq.b   .19C4

    addq.b  #1, D1
.19C4:
    move.b  0x10106C.l, D0
    andi.w  #0x0F, D0
    lea.l   0x21A36.l, A6
    add.b   (0, A6, D0.w), D1
    tst.b   0x101F60.l
    bpl.b   .19E2

    addq.b  #4, D1
.19E2:
    move.w  0x101014.l, D0
    subq.w  #3, D0
    lea.l   0x21A46.l, A6
    add.b   (0, A6,D0.w), D1
    move.b  0x101068.l, D0
    andi.b  #0x07, D0
    add.b   D0, D1
    tst.b   0x1039C3.l
    bne.b   .1A26

    cmpi.b  #0x10, D1
    bls.b   .1A10

    moveq   #0x10, D1
.1A10:
    tst.b   0x101051.l
    bpl.b   .1A1E

    subq.b  #2, D1
    bcc.b   .1A1E

    moveq   #0x00, D1
.1A1E:
    move.b  D1, !rank
    rts

.1A26:
    cmpi.b  #0x1F, D1
    bls.b   .1A2E

    moveq   #0x1F, D1
.1A2E:
    move.b  D1, !rank
    rts

.1A36:
    d08 0, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3

.1A46:
    d08 4, 4, 2, 0 ;don't know how many values are here
