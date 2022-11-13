;todo: code needs some organizing

_2E682:
    jmp     0x000136D6

.E688:                               ;bouncing turtle pattern code start
    tst.b   (0x6E6C, A5)              ;check if already running
    bne.b   _2E682

    move.b  #0x01, (0x6E6C, A5)       ;toggle running
    move.l  #0x0002E69C, (0x000C, A1) ;probably store obj start location for next run
.E69C:
    move.l  A0, -(A7)                 ;store base offset on stack
    clr.b   (0x6F0F, A5)
    cmpi.w  #0x05C0, (0x32D2, A5)
    bcc.w   .E950                     ;branch if arthur X pos > 0x05C0. never branches afaict, maybe this is a safety check

    tst.b   (0x5A62, A5)
    beq.w   .E6DA

    cmpi.b  #0x04, (0x5A62, A5)
    bcc.w   .E94C

    tst.b   (0x6F03, A5)
    beq.w   .E6CE

    subq.b  #1, (0x6F03, A5)
    bra.w   .E94C

.E6CE:
    tst.b   (0x6F0D, A5)
    bne.w   .E6F0
    bra.w   .E94C

.E6DA:
    tst.b   (0x5A59, A5)
    beq.w   .E6E8
    move.b  #0x02, (0x6F06, A5)

.E6E8:
    clr.b   (0x6F0F, A5)
    clr.b   (0x6F0C, A5)

.E6F0:
    clr.b   (0x6F0D, A5)
    bsr.w   .F97C ;get obj slot & init turtle. modifies stack and returns to .E6FC on success, A0 = turtle offset
    bra.w   .E94C

.E6FC:
    nop
    move.b  #0x01, (0x006B, A0)
    addq.b  #1, (0x5A62, A5)
    move.b  #0x10, (0x000A, A0)
    move.w  #0x0E8E, (0x0038, A0)
    bsr.w   .FA04 ;set turtle Y pos
    move.b  (0x6F08, A5), D0
    andi.w  #0x000F, D0
    move.b  (.E744, PC, D0.w), (0x000B, A0)
    addq.b  #1, (0x6F08, A5)
    move.b  (0x6F09, A5), D0
    andi.w  #0x000F, D0
    cmpi.b  #0x10, (0x6F09, A5)
    bcc.w   .E77C ;branch if bouncing_turtle_counter >= 0x10

    move.b  (.E754, PC, D0.w), D0
    bra.w   .E792

.E744: d08 0x41, 0x41, 0x42, 0x41, 0x42, 0x41, 0x42, 0x41, 0x41, 0x42, 0x42, 0x41, 0x41, 0x41, 0x42, 0x42 ;low/high bounce pattern?
.E754: d08 0x69, 0x4B, 0x2D, 0x5F, 0x0F, 0x2D, 0x4B, 0x0F, 0x5F, 0x0F, 0x2D, 0x2D, 0x0F, 0x2D, 0x4B, 0x2D ;timer
.E764: d08 0xA6, 0xF0, 0xCE, 0xF6, 0xEC, 0xCE, 0xB0, 0xF0, 0xA1, 0xF0, 0xC4, 0xF6, 0xE2, 0xC4, 0xA6, 0xF0 ;? unused timer list
.E774: d08 0x78, 0x78, 0x5A, 0x78, 0x1E, 0x78, 0x3C, 0x5A                                                 ;timer 2

.E77C:
    move.b  (.E764, PC, D0.w), D0
    tst.b   D0
    bpl.w   .E792 ;branch if value from .E764 is positive, which it never is...

    move.b  (0x6F09, A5), D0
    andi.b  #0x07, D0
    move.b  (.E774, PC, D0.w), D0
.E792:
    move.b  D0, (0x000F, A0) ;store timer
    move.b  D0, (0x6F03, A5)
    addq.b  #1, (0x6F09, A5)
    tst.b   (0x6F0C, A5)
    bne.w   .E7E6

    addq.b  #1, (0x6F0B, A5)
    cmpi.b  #0x03, (0x6F0B, A5)
    bne.w   .E7EE

    clr.b   (0x6F0B, A5)
    move.b  (0x3CC1, A5), D0 ;note: rng doesn't increment in this section!
    andi.w  #0x000F, D0
    move.b  (.E7D6, PC, D0.w), (0x0051, A0)
    move.b  #0x01, (0x0050, A0)
    move.b  #0x01, (0x6F0C, A5)
    bra.w   .E7F6

.E7D6:
    d08 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01

.E7E6:
    clr.b   (0x6F0B, A5)
    bra.w   .E7F2

.E7EE:
    clr.b   (0x6F0C, A5)
.E7F2:
    clr.b   (0x0050, A0)
.E7F6:
    move.b  (0x3CC1, A5), D0 ;rng
    andi.w  #0x000F, D0
    move.b  (.E84A, PC, D0.w), D0
    andi.w  #0x000F, D0
    cmpi.b  #0x41, (0x000B, A0)
    bne.w   .E81E

    move.w  (.E85A, PC, D0.w), (0x0066, A0)
    move.w  (.E862, PC, D0.w), D0
    bra.w   .E828

.E81E:
    move.w  (.E86A, PC, D0.w), (0x0068, A0)
    move.w  (.E872, PC, D0.w), D0
.E828:
    sub.b   D0, (0x000F, A0) ;shorten timer, can also wrap around and become a long timer?
    bset.b  #0x01, (0x0012, A0)
    move.w  #0x04EA, (0x003C, A0)
    clr.b   (0x0013, A0)
    bset.b  #0x07, (0x0013, A0)
    clr.b   (0x0069, A0)
    bra.w   .E94C

.E84A:
    d08 0x00, 0x00, 0x00, 0x00, 0x02, 0x02, 0x02, 0x02, 0x04, 0x04, 0x04, 0x04, 0x06, 0x06, 0x06, 0x06 ;index
.E85A:
    d16 0x0000, 0x0060, 0x0040, 0x0020
.E862:
    d16 0x0000, 0x0028, 0x001C, 0x000E ;timer
.E86A:
    d16 0x0000, 0x0078, 0x0050, 0x0028
.E872:
    d16 0x0000, 0x0036, 0x0024, 0x0012 ;timer

.E87A:
	bset.b  #0x00, (0x0012, A1)
	bset.b  #0x07, (0x0013, A1)
	bclr.b  #0x06, (0x0013, A1)
	jmp     0x0001516C

.E94C:
	movea.l (A7)+, A0
	rts

.E950: ;never reached?
	move.b  #0x01, (0x6F0F, A5)
	movea.l (A7)+, A0
	rts

;A1 = obj offset

; _2EB72:

; -----

; _2EC0A: ;bouncing turtle when bouncing


.F97C:
    jsr     0x0001342E ;get obj slot (A0)
    beq.w   .FA02 ;branch if no slots available
    bra.w   .F9B0

    jsr     0x0001344E
    beq.w   .FA02
    bra.w   .F9B0

    jsr     0x0001346E
    bra.w   .F9A8

    nop
    bra.w   .F9B0

.F9A8:
    jsr     0x0001348E
    rts

.F9B0:
    bset.b  #0x00, (0x0008, A0)
    ori.b   #0x60, (0x0009, A0)
    move.b  #0x41, (0x000B, A0)
    move.b  #0x42, (0x000D, A0)
    move.b  #0x01, (0x0011, A0)
    move.l  #0x0002E688, (0x0034, A0)
    move.l  #0x0002FCDE, (0x0030, A0)
    clr.b   (0x0026, A0)
    clr.b   (0x0052, A0)
    moveq   #0x00, D0
    move.l  D0, (0x0050, A0)
    move.l  D0, (0x0054, A0)
    move.l  D0, (0x0058, A0)
    move.l  D0, (0x005C, A0)
    move.l  D0, (0x0060, A0)
    move.l  D0, (0x0064, A0)
    addq.l  #4, (A7) ;adjust stack to change return position
.FA02:
    rts

.FA04: ;set turtle Y pos
	move.w  (0x32D4, A5), D1         ;0xB2D4: arthur Y pos
	addi.w  #0x0054, D1
	move.w  D1, (0x0004, A0) ;Y pos
	rts