;A5: 0x00FF8000 (pointer to middle of RAM)

;-----

_002664: ;set new weapon
    movea.l (0x8868, A5), A0 ;0x0868: has offset to arthur
.2668:
    cmp.b   (0x2C, A0), D0
    beq.b   .26A0

    moveq   #0, D1
    move.b  D0, D1
    move.b  (0x2C, A0), (0x2D, A0) ;store old weapon at 0x2D
    move.b  D0, (0x2C, A0)         ;set new weapon
    lea     (0x8992, A5), A0 ;0x0992
    move.b  #0x00, (0, A0, D1.w)
    bsr.w   .26B0
    tst.b   (0x895E, A5) ;0x095E
    beq.b   .269A

    move.b  #0x00, (0x4052, A5) ;0xC052
    jsr     0x61DE.w
.269A:
    jmp     0x614E.l

.26A0:
    rts

;probably alternate entry here
    movea.l (0x8868, A5), A0 ;0x0868
    move.w  #0x0000, D0
    move.b  (0x2D, A0), D0
    bra.b   .2668

.26B0:
    move.b  #0xFF, (0x885A, A5) ;0x085A
    moveq   #0, D0
    move.b  D0, (0x885B, A5) ;0x085B
    move.w  D0, (0x885C, A5) ;0x085C
    move.b  D0, (0x50E2, A5) ;0xD0E2
    move.b  D0, (0x50DF, A5) ;0xD0DF
    move.w  D0, (0x50E0, A5) ;0xD0E0
    rts

;-----

arthur: ;placeholder label to have a main label to attach sublabels to
    ;A1: arthur (most of time, anyway)

    ;todo
;B5BC: jump based on arthur's state
    movea.l (0x8952, A5), A0 ;0x0952: arthur + 0x01B8
    jmp     (A0)

.old_man_init: ;D09E
    moveq   #0, D0
    move.b  D0, (0x50B0, A5)
    move.b  D0, (0x50B1, A5)
    move.l  #.old_man_run, (0x8952, A5) ;0x0952: arthur + 0x01B8
.old_man_run: ;D0B0: run old man transform
    btst.b  #0x03, (0x08, A1)
    beq.b   .D0CC
    ;todo
.D0CC:
    ;todo

.duck_init: ;D526: init duck transform
    move.l  #.duck_run, (0x8952, A5) ;0x0952: arthur + 0x01B8
    move.l  #0xD6EE, (0x8966, A5)
    bclr.b  #0x01, (0x08, A1)
    move.b  #0x00, (0x50B6, A5)
    move.b  #0x00, (0x50B7, A5)
.duck_run: ;D548: run duck transform
    btst.b  #0x02, (0x08, A1)
    beq.b   .D572

    btst.b  #0x02, (0x11, A1)
    beq.b   .D564

    addi.w  #0x08, (0x04, A1)
    bclr.b  #0x02, (0x11, A1)
.D564:
    move.l  #0xB658, (0x8966, A5)
    jmp     0xBC14.l

.D572:
    moveq   #0, D0
    move.b  (0x50B6, A5), D0
    move.w  (0x0C, PC, D0.w), D0
    jsr     (0x08, PC, D0.w)
    movea.l (0x8966, A5), A0
    jmp     (A0)

    ;todo

;D6EE transform (duck) handling
    ori.b   #0x10, (0x8877, A5) ;0x0877: arthur + 0xDD
    move.w  #0x0000, D7
    move.b  (0x8876, A5), D7 ;0x0876: arthur + 0xDC
    btst.b  #0x00, (0x08, A1)
    beq.b   .D708

    bra.w   .D840

.D708:
    jsr     0x2A96.w
    bne.w   .D88E

    move.w  #0x0000, D0
    move.b  (0x8876, A5), D0 ;0x0876: arthur + 0xDC
    andi.w  #0b11, D0
    add.w   D0, D0
    move.w  (0x06, PC, D0.w), D0
    jmp     (0x02, PC, D0.w) ;jump to offset

    d16 0x0008, 0x0062, 0x00AA, 0x0008

;D72E (0008) - standing duck?
    move.b  #0x00, (0x8956, A5)
    moveq   #0, D0
    move.l  D0, (0x14, A1)
    move.b  D0, (0x0E, A1)
    btst.b  #0x00, (0x09, A1) ;check flags
    bne.b   .D75E

    andi.b  #0b11000000, (0x09, A1) ;clear some flags
    ori.b   #0b00000001, (0x09, A1) ;set some flag (crouch/stand?)
    move.l  #0x0147A8, (0x28, A1)
    jsr     0x2880.w
.D75E:
    jsr     0x2982.w
    jsr     0x28BA.w
    tst.w   (0x14, A1)
    bmi.w   .D77A

    move.l  #0xE240, (0x24, A1)
    bra.w   .D782

.D77A:
    move.l  #0xE312, (0x24, A1)
.D782:
    jmp     0xE1E0.l

;D788 (0062)
    move.b  #0x01, (0x8956, A5)
    move.w  #0x01CC, (0x14, A1)
    move.w  #0x00, (0x16, A1)
    cmpi.b  #0x82, (0x09, A1)
    beq.w   .D818

    clr.b   (0x0E, A1)
    ;todo

;D7D0 (00AA)

.D818: ;todo
.D840: ;todo
.D88E: ;todo

;-----

; A0, A1: magician projectile object slot
; A2: magician object slot

_0496B2: ;create magician projectile
    moveq   #0, D0
    lea     (0x40, A0), A0
    move.w  #0x0003, D1
.96BC:
    move.l  D0, (A0)+
    move.l  D0, (A0)+
    move.l  D0, (A0)+
    move.l  D0, (A0)+
    dbf     D1, .96BC
    move.b  #0x01, (0x08, A1)
    move.b  #0x1F, (0x0A, A1)
    move.b  #0x41, (0x0D, A1)
    move.b  #0x01, (0x11, A1)
    move.b  (0x09, A2), (0x09, A1)
    andi.b  #0xFE, (0x09, A1)
    ori.b   #0x04, (0x09, A1)
    move.b  #0x42, (0x13, A1)
    move.b  #0x03, (0x12, A1)
    move.b  #0x0F, (0x1C, A1)
    move.b  #0x63, (0x1D, A1)
    move.b  #0x0B, (0x23, A1)
    move.b  #0x80, (0x25, A1)
    move.l  #0x049978, (0x30, A1)
    move.l  #0x049696, (0x34, A1)
    move.w  #0x015E, (0x3C, A1)
    move.w  #0x0182, (0x38, A1)
    move.w  #0x0250, (0x28, A1)
    move.w  (0x00, A2), (0x00, A1) ;x pos
    move.w  (0x04, A2), (0x04, A1) ;y pos
    move.b  (0x41, A2), (0x41, A1) ;direction
    move.l  A2, (0x44, A1)
    move.b  #0x01, (0x42, A2)
    bsr.w   .975A
    rts

.975A:
    moveq   #0, D0
    move.b  (0x41, A1), D0 ;use direction as offset
    lsl.w   #2, D0
    lea     (0x10, PC, D0.w), A0
    move.w  (0x00, A0), (0x14, A1) ;x speed
    move.w  (0x02, A0), (0x16, A1) ;y speed
    rts

;-----

_049818: ;magician projectile hitting arthur?
    andi.b  #0xDF, (0x13, A1)
    tst.b   (0x8931, A5) ;0x0931: arthur + 0x197 (i frames active?)
    bne.w   .9884

    clr.b   (0x13, A1)
    movea.l (0x8868, A5), A2 ;0x0868: arthur + 0xCE (arthur base offset)
    tst.b   (0x10, A2) ;check arthur hp
    beq.w   .983E

    bsr.w   .988A
    bra.w   .9842

.983E: ;0 hp
    bsr.w   .98A2
.9842:
    move.b  #0x29, (0x12, A1)
    move.l  #0x049936, (0x2C, A1)
    clr.l   (0x14, A1)
    move.w  (0x886C, A5), D0 ;0x086C: arthur + 0xD2 (some kind of x pos)
    move.w  (0x886E, A5), D1
    move.w  D0, (0x00, A1)
    move.w  D1, (0x04, A1)
    bsr.w   .9914
    movea.l (0x44, A1), A2
    tst.b   (0x08, A2)
    beq.w   .9884

    cmpi.b  #0x1D, (0x0A, A2)
    bne.w   .9884

    move.b  #0xFF, (0x42, A2)
.9884:
    jmp     0xDC34.l

.988A: ;>0 hp
    btst.b  #0x02, (0x11, A2)
    beq.w   .9898

    bra.w   .98A0

.9898:
    move.l  #arthur.duck_init, (0x8952, A5) ;0x0952: arthur + 0x01B8 = set arthur function to run
.98A0:
    rts

.98A2:
    tst.b   (0x11, A2)
    bne.w   .98AE

    bra.w   .98B6

.98AE:
    move.l  #arthur.old_man_init, (0x8952, A5) ;0x0952: arthur + 0x01B8
.98B6:
    rts

.9914:
    move.w  #0x05, D6
.9918:
    move.w  D6, D0
    lsl.w   #2, D0
    movea.l (0x4C, A1, D0.w), A0
    cmpi.b  #0x1F, (0x0A, A0)
    bne.w   .9930

    bset.b  #0x03, (0x08, A0)
.9930:
    dbf     D6, .9918

    rts

;-----
