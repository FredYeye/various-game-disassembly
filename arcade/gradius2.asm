_00DC08:
    clr.b   0x6041C.l
    tst.b   0x60048.l
    bne.b   .DC18

    rts

.DC18:
    move.b  0x6041F.l, D1
    lsl.b   #1, D1
    add.b   0x60419.l, D1
    subq.b  #1, D1
    tst.b   0x6041B.l
    beq.b   .DC3A

    cmpi.b  #0x10, D1
    bcc.b   .DC3A

    move.b  #0x10, D1
.DC3A:
    move.b  0x60428.l, D0
    lsr.b   #3, D0
    beq.b   .DC48

    addi.b  #0x01, D1
.DC48:
    move.b  0x60429.l, D0
    beq.b   .DC76

    move.b  D0, D2
    lea.l   0xDC90.l, A6
    andi.w  #0x07, D2
    add.b   (0, A6, D2.w), D1
    move.b  D0, D2
    lsr.b   #3, D2
    andi.b  #0x03, D2
    beq.b   .DC6E

    addi.b  #0x04, D1
.DC6E:
    move.b  D0, D2
    lsr.b   #5, D0
    beq.b   .DC76

    add.b   D0, D1
.DC76:
    tst.b   0x6041B.l
    bne.b   .DC88

    cmpi.b  #0x10, D1
    bcs.b   .DC88

    move.b  #0x10, D1
.DC88:
    move.b  D1, 0x6041C.l
    rts

.DC90:
    d08 0, 2, 2, 2, 2, 0, 0, 0
