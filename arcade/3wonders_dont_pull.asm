;---------- engine defines

;4CDA, item obj drop list? same as obj list?
;5A9A, obj list, not sure where it starts

;relative to A5(0x8000)
!score_grid_prev = 0x8D26
!score_grid_next = 0x8D28
!score_hi       = 0x8DCE
!score_p1       = 0x8DD2
!score_p2       = 0x8DD6
!is_out_of_bounds = 0x8E43
!stage_variation = 0x8E50
!stage = 0x8E54
!professional_course = 0x8E6C
!heart_line_is_completed = 0x8EBA
!heart_line_is_vertical = 0x8EBB
!stun_potion_dropped = 0x8EC2

!stage_variation_list = 0x8F24

!stage_frame_counter = 0x9036
!blocks_pushed = 0x903A
!enemies_powering_up = 0x9040
!enemies_active = 0x904A
!enemies_max_active = 0x904B
!enemies_inactive = 0x904C
!heart_dance = 0x905B ;enemies are dancing. can be 0-2?

!obj_heart_block = 0x53C2 ;3 objects, 160 bytes per object
!rng_stage = 0x55A2
!enemy_power_up_timer = 0x7AA4
!enemy_powering_up_timer = 0x7AA8

;----------

    ;heart block object
    !obj_heart_touching_boundary = 0x80

;----------

_01478: ;update score
    cmpi.b  #0x02, (0x8DDE, A5)
    beq.w   .15AA

    tst.b   (0x8D84, A5)
    beq.w   .14AA

    andi.w  #0xFF, D1
    bclr.l  #0x07, D1
    sne     D0
    bne.w   .14A2

    tst.b   (0x97BA, A5)
    bne.w   .14AC

    rts

.14A2:
    tst.b   (0x985A, A5)
    bne.w   .14BA

.14AA:
    rts

.14AC:
    lea     (0x8DD6, A5), A0 ;todo: score_p1 + 4, needs math support!
    movea.l #0x90A388, A1
    bra.w   .14C4

.14BA:
    lea     (0x8DDA, A5), A0 ;score_p2 + 4
    movea.l #0x90B308, A1
.14C4:
    movea.l #_F046C, A2
    add.w   D1, D1
    move.w  (0, A2, D1.w), D1
    lea     (0, A2, D1.w), A2
    move.w  #0x03, D5
.14D8:
    abcd    -(A2), -(A0) ;update score (decimal add)
    dbt     D5, .14D8
    bcc.w   .14E8

    move.l  #0x99999999, (A0)
.14E8:
    movem.l A0, -(A7)
    bsr.w   .155E
    movem.l (A7)+, A0
    move.l  (A0), D1
    cmp.l   (!score_hi, A5), D1
    bls.w   .1506

    move.l  D1, (!score_hi, A5)
    bra.w   .152E

.1506:
    rts

.152E:
    ;todo

.155E:
    ;todo

.15AA: ;heart blocks lined up scoring?
    tst.b   (0x8D84, A5)
    beq.w   .14AA

    andi.w  #0xFF, D1
    bclr.l  #0x07, D1
    sne     D0
    bne.w   .15D2

    tst.b   (0x8ED4, A5)
    bne.w   .15E4

    tst.b   (0x97BA, A5)
    bne.w   .15E4

    rts

.15D2:
    tst.b   (0x8ED4, A5)
    bne.w   .15F2

    tst.b   (0x985A, A5)
    bne.w   .15F2

    rts

.15E4:
    lea     (0x8DD6, A5), A0 ;score_p1 + 4
    movea.l #0x90A2F0, A1
    bra.w   .14C4

.15F2:
    lea     (0x8DDA, A5), A0 ;score_p2 + 4
    movea.l #0x90AEF0, A1
    bra.w   .14C4

;----------

_42942: ;store variation to array
    tst.b   (!professional_course, A5)
    bne.b   .295A

    lea     (!stage_variation_list, A5), A2
    moveq   #0x00, D0
    move.b  (!stage, A5), D0
    lea     (0, A2, D0.w), A2
    move.b  (!stage_variation, A5), (A2)
.295A:
    rts ;subtracts one to stage_variation upon exit

;----------

_4295C: ;runs when loading next stage
    tst.b   (!professional_course, A5)
    beq.b   .2990

    movea.l #0x0E7836, A1
.2968:
    moveq   #0x00, D0
    move.b  (0x8E6D, A5), D0
    move.b  (0, A1, D0.w), D0
    lea     (!stage_variation_list, A5), A2
    moveq   #0x0F, D1
.2978:
    cmp.b   (A2)+, D0
    beq.b   .298A
    dbf     D1, .2978

    addq.b  #1, (0x8E6D, A5)
    move.b  D0, (!stage_variation, A5)
    rts

.298A:
    addq.b  #1, (0x8E6D, A5)
    bra.b   .2968

.2990:
    movem.l A0, -(A7)
    jsr     _4520E ;D0 = rng
    movem.l (A7)+, A0
    andi.w  #0x07, D0
    movea.l #_E7776, A1
    moveq   #0x00, D1
    move.b  (!stage, A5), D1
    add.w   D1, D1
    add.w   D1, D1
    movea.l (0, A1, D1.w), A1
    move.b  (0, A1, D0.w), (!stage_variation, A5)
    rts

;----------

_43AF4: d08 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2
.3B04: d16 0x0000, 0x01A0, 0x01C0

.3B0A: ;load stage?
    moveq   #0x00, D0
    move.b  (!stage, A5), D0
    andi.b  #0x0F, D0
    move.b  (_43AF4, PC, D0.w), D0
    move.b  D0, (0x8E58, A5)
    add.w   D0, D0
    move.w  (.3B04, PC, D0.w), D1
    move.w  D1, (0x8E56, A5)
    moveq   #0x00, D0
    move.b  (!stage, A5), D0
    andi.b  #0x0F, D0
    lsl.w   #4, D0
    movea.l #0x0D0136, A0
    tst.b   (0x8ED4, A5)
    beq.b   .3B44

    movea.l #0x0D0236, A0
.3B44:
    lea     (0, A0, D0.w), A0
    movea.l #0x914800, A1 ;gfx ram? maybe update palette
    movea.l #0x914000, A2 ;^
    lea     (0xC0, A2), A2
    move.l  (A0), (A1)+
    move.l  (A0)+, (A2)+
    move.l  (A0), (A1)+
    move.l  (A0)+, (A2)+
    move.l  (A0), (A1)+
    move.l  (A0)+, (A2)+
    move.l  (A0), (A1)+
    move.l  (A0)+, (A2)+
    movea.l #0x0D48C6, A0
    movea.l #0x0D5676, A1
    moveq   #0x00, D0
    move.b  (!stage_variation, A5), D0
    move.b  (.3BD0, PC, D0.w), D0
    lsl.l   #8, D0
    lea     (0, A1, D0.l), A1
    movea.l #0x90F040, A2
    lea     (0x40, A2), A3
    move.w  #0x0F, D5
    moveq   #0x00, D1
    move.w  (0x8E56, A5), D1
    swap    D1
    addi.l  #0x3C000000, D1
.3BA0:
    move.w  #0x07, D4
.3BA4:
    moveq   #0x00, D0
    move.w  (A1)+, D0
    lsl.l   #4, D0
    lea     (0, A0, D0.l), A4
    move.l  (A4)+, (A2)
    add.l   D1, (A2)+
    move.l  (A4)+, (A2)
    add.l   D1, (A2)+
    move.l  (A4)+, (A3)
    add.l   D1, (A3)+
    move.l  (A4)+, (A3)
    add.l   D1, (A3)+
    dbf     D4, .3BA4

    lea     (0x40, A2), A2
    lea     (0x40, A3), A3
    dbf     D5, .3BA0

    rts

.3BD0:
    d08 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F
    d08 0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1A, 0x1B, 0x1C, 0x1D, 0x1E, 0x1F
    d08 0x20, 0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27, 0x28, 0x29, 0x2A, 0x2B, 0x2C, 0x2D, 0x2E, 0x2F
    d08 0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x3A, 0x3B, 0x3C, 0x3D, 0x3E, 0x3F

;----------

_4520E: ;rng for picking stages
    move.w  (!rng_stage, A5), D0
    bne.b   .5218

    move.w  #0x01C3, D0
.5218:
    move.w  D0, D1
    add.w   D0, D0
    add.w   D1, D0
    lsr.w   #8, D0
    add.b   D0, (0x55A3, A5) ;stage + 1, needs math support!
    move.b  D0, (!rng_stage, A5)
    move.b  (0x55A3, A5), D0
    rts

;----------

_465AC: ;heart line-up handler?
    ;A0, A1, A2 = offsets to the 3 heart block objects

    move.w  (0x20, A0), D2
    move.w  (0x24, A0), D3
    add.w   D1, D1
    move.w  (.65C8, PC, D1.w), D1
    jmp     (.65C8, PC, D1.w) ;returns and takes rts eventually
    rts

    move.b #0x00, (0x73B2, A5) ;not sure how this is reached
    rts

.65C8:
    d16 0x0020, 0x0022, 0x0070, 0x0096, 0x009A, 0x00C4, 0x012C, 0x0134
    d16 0x0136, 0x0164, 0x016A, 0x01DA, 0x01DC, 0x01E4, 0x01E4, 0x01E4

.65E8: ;0020
    rts

.668C: ;00C4 vertical line up?
    move.b  #0x00, (0x8E65, A5)
    move.b  #0x00, (0x8EC5, A5)
    move.w  #0x00, (0x8E6A, A5)
    move.b  #0x00, (0x8F09, A5)
    move.b  #0x01, (0x8E59, A5)
    move.b  #0x01, (0x8E42, A5)
    tst.b   (!obj_heart_touching_boundary, A0)
    bne.w   .66DE

    tst.b   (!obj_heart_touching_boundary, A1)
    bne.w   .66DE

    tst.b   (!obj_heart_touching_boundary, A2)
    bne.w   .66DE

    move.b  #0x01, (!heart_line_is_completed, A5)
    move.b  #0x01, (!heart_line_is_vertical, A5)
    move.b  #0x00, (0x73B0, A5)
    bra.w   .6796

.66DE:
    move.b  #0x00, (!heart_line_is_completed, A5)
    move.b  #0x00, (!heart_line_is_vertical, A5)
    move.b  #0x01, (0x73B0, A5)
    bra.w   .6796

.6732: ;016A horizontal line up?
    move.b  #0x00, (0x8E65, A5)
    move.b  #0x00, (0x8EC5, A5)
    move.w  #0x00, (0x8E6A, A5)
    move.b  #0x00, (0x8F09, A5)
    move.b  #0x01, (0x8E59, A5)
    move.b  #0x01, (0x8E42, A5)
    tst.b   (!obj_heart_touching_boundary, A0)
    bne.w   .6784

    tst.b   (!obj_heart_touching_boundary, A1)
    bne.w   .6784

    tst.b   (!obj_heart_touching_boundary, A2)
    bne.w   .6784

    move.b  #0x01, (!heart_line_is_completed, A5)
    move.b  #0x00, (!heart_line_is_vertical, A5)
    move.b  #0x00, (0x73B0, A5)
    bra.w   .6796

 .6784:
    move.b  #0x00, (!heart_line_is_completed, A5)
    move.b  #0x00, (!heart_line_is_vertical, A5)
    move.b  #0x01, (0x73B0, A5)
.6796:
    move.w  (0x20, A0), D0
    move.w  (0x24, A0), D1
    jmp     0x0CC8.w

;----------

_46930: ;heart block combo screen transition to "show time"
    subq.b  #1, (0x8E65, A5) ;timer
    beq.w     .693C

    jmp     0x0C8C.w

.693C:
    moveq   #0x25, D1
    jsr     0x0CAA.w
    moveq   #0x2F, D1
    jsr     0x0CAA.w
    moveq   #0x2C, D1
    tst.b   (0x73B0, A5)
    bne.w     .695E

    subq.w  #1, D1
    tst.b   (!heart_line_is_vertical, A5)
    beq.w     .695E

    subq.w  #1, D1
.695E:
    jsr     0x0CAA.w
    movea.l #0x90944C, A1
    move.l  #0x687B0001, (A1)
    move.w  #0x0100, (0x92DE, A5)
    move.w  #0x0100, (0x8D32, A5)
    move.b  #0x5A, (0x8E65, A5)
    move.b  #0x00, (0x73B3, A5)
    move.w  #0x06, (0x8E6A, A5)
    move.w  #0x18, D0
    moveq   #0x03, D1 ;lower score? (2000)
    tst.b   (0x73B0, A5)
    bne.w   .69A6

    moveq   #0x06, D1 ;horizontal score (5000)
    tst.b   (!heart_line_is_vertical, A5)
    beq.w   .69A6

    moveq   #0x0B, D1 ;vertical score (10000)
.69A6:
    tst.b   (0x97BA, A5)
    beq.w   .69B2

    jsr     0x05C0.w ;update "score grid"
.69B2:
    tst.b   (0x985A, A5)
    beq.w   .69C0

    ori.b   #0x80, D1
    jsr     0x05C0.w

.69C0:
    move.w  #0x8023, D1
    jmp     0x0CB0.w

;----------

_46D90:
    tst.b   (!is_out_of_bounds, A5)
    beq.w   .6DAE

    move.w  #0x02, (0x8EC6, A5)
    move.w  #0x00, (0x73B6, A5)
    moveq   #0x00, D0
    move.b  #0x79, D0
    jmp     0x333A.w

.6DAE:
    rts

;----------

;not the start of this function
    jsr     0x095C.w
    suba.l  #0x3000, A3
    tst.w   (0x02, A3)
    beq.w   .795C

    bset.b  #0x00, (!is_out_of_bounds, A5)
    rts

.795C:
    bclr.b  #0x00, (!is_out_of_bounds, A5)
    rts

;----------

_482F8: ;block pushing?
    subq.b  #1, (0x55, A0)
    beq.w   .8370

    cmpi.b  #0x08, (0x55, A0)
    bne.w   .8366

    jsr     0x3610.w
    move.b  #0x01, (0x5E, A0)
    jsr     0x0992.w
    movea.l (0x72, A0), A3
    move.w  (0x02, A3), D0
    move.w  D0, D1
    andi.w  #0x0C00, D0
    beq.w   .8362

    andi.w  #0x8000, D1
    bne.w   .8362

    ori.w   #0x8000, (0x02, A3)
    jsr     0x0422.w
    bcs.w   .8362

    move.w  #0x0101, (A1)
    move.w  (0x4C, A0), (0x06, A1)
    move.w  (0x20, A0), (0x20, A1)
    move.w  (0x24, A0), (0x24, A1)
    move.l  A3, (0x72, A1)
    addq.w  #1, (!blocks_pushed, A5)
    addq.b  #1, (0x8E49, A5) ;currently sliding block count?
.8362:
    jmp     0x05E4.w
.8366:
    move.b  #0x00, (0x5E, A0)
    jmp     0x05E4.w
.8370:
    move.b  #0x00, (0x5E, A0)
    move.w  #0x00, (0x12, A0)
    move.w  (0x04C, A0), D0
    movea.l #0x0DCD0C, A4
    jmp     0x05D2.w

;----------

_4AB80: ;jelly dies
    move.l  (0x30, A0), D0
    beq.b   .AB96

    movea.l D0, A1
    move.w  #0x06, (0x10, A1)
    move.l  #0x00, (0x30, A0)
 .AB96:
    subq.b  #1, (!enemies_active, A5)
    addq.b  #1, (0x904E, A5)
    movea.l (0x40, A0), A1
    addq.b  #1, (0x46,A1)
    move.w  #0x01, (0x12, A1)
    move.w  #0x06, (0x10, A0)
    movea.l #0xFF0EDC, A1
    move.w  (0x08, A0), D0
    lea     (0, A1, D0.w), A1
    bclr.b  #0x07, (A1)
    rts

;----------

_4A8D0: ;jelly manhole blocked
    movea.l (0x72, A0), A3
    andi.w  #0xFC00, (0x02, A3)
    bne.w   .AB3A

    ;todo
.AB3A:
    move.l  (0x30, A0), D0
    beq.b   .AB50

    movea.l D0, A1
    move.w  #0x06, (0x10, A1)
    move.l  #0x00, (0x30, A0)
.AB50:
    movea.l (0x40, A0), A1
    addq.b  #1, (!enemies_inactive, A5)
    subq.b  #1, (!enemies_active, A5)
    move.w  #0x02, (0x12, A1)
    addq.b  #1, (0x46, A1)
    move.w  #0x06, (0x10, A0)
    movea.l #0xFF0EDC, A1
    move.w  (0x08, A0), D0
    lea     (0, A1, D0.w), A1
    bclr.b  #0x04, (A1)
    rts

;----------

_4F306: ;crocodile manhole blocked
    movea.l (0x72, A0), A3
    andi.w  #0xFC00, (0x02, A3)
    bne.w   .0AB4

    ;todo
.0AB4:
    move.l  (0x30, A0), D0
    beq.b   .0ACA

    movea.l D0, A1
    move.w  #0x06, (0x10, A1)
    move.l  #0x00, (0x30, A0)
.0ACA:
    movea.l (0x40, A0), A1
    addq.b  #1, (!enemies_inactive,A5)
    subq.b  #1, (!enemies_active,A5)
    move.w  #0x02, (0x12, A1)
    addq.b  #1, (0x46, A1)
    move.w  #0x06, (0x10, A0)
    movea.l #0xFF0EDC, A1
    move.w  (0x08, A0), D0
    lea     (0, A1, D0.w), A1
    bclr.b  #0x04, (A1)
    rts

;----------

_50AFA: ;crocodile dies
    move.l  (0x30, A0), D0
    beq.b   .0B10

    movea.l D0, A1
    move.w  #0x06, (0x10, A1)
    move.l  #0x00, (0x30, A0)
.0B10:
    subq.b  #1, (!enemies_active, A5)
    addq.b  #1, (0x904E, A5)
    movea.l (0x40, A0), A1
    addq.b  #1, (0x46, A1)
    move.w  #0x01, (0x12, A1)
    move.w  #0x06, (0x10, A0)
    cmpi.w  #0x04, (0x02, A0)
    beq.b   .0B3C

    subq.b  #1, (0x8ECE, A5)
    subq.b  #1, (0x903F, A5)
.0B3C:
    movea.l #0xFF0EDC, A1
    move.w  (0x08, A0), D0
    lea     (0, A1, D0.w), A1
    bclr.b  #0x07, (A1)
    rts

;----------

_55D70:
    tst.b   (0x76, A0)
    bne.w   .5EEE

    jsr     0x0986.w
    move.l  A3, (0x56, A0)
    lea     (A3), A2
    suba.l  #0x3000, A2
    tst.w   (0x02, A2)
    bne.w   .5E0C
    ;todo

 .5E0C:
    move.b  #0x00, (0x76, A0)
    move.b  #0x01, (!obj_heart_touching_boundary, A0)
    move.w  #0x00, (0x12, A0)
    bra.b   .5E2C

    move.b  #0x00, (!obj_heart_touching_boundary, A0)
    move.w  #0x00, (0x12, A0)
 .5E2C:
    ;todo

.5EEE:
    ;todo
;----------

_571AC: ;manhole gets unblocked
    tst.b   (!enemies_powering_up, A5)
    bne.w   .7222

    tst.b   (!heart_dance, A5)
    bne.w   .7222

    movea.l #0xFF0EDC, A2
    move.w  (0x08, A0), D0
    lea     (0, A2, D0.w), A2
    btst.b  #0x04, (A2)
    beq.w   .7222

    move.b  (!enemies_max_active, A5), D0
    cmp.b   (!enemies_active, A5), D0
    beq.w   .7222

    jsr     0x0410.w
    bcs.w   .7222

    addq.b  #1, (!enemies_active, A5)
    subq.b  #1, (!enemies_inactive, A5)
    move.b  #0x01, (0x44, A0)
    move.w  #0x0101, (A1)
    move.w  (0x04, A0), (0x02, A1)
    move.w  (0x20, A0), (0x20, A1)
    move.w  (0x24, A0), (0x24, A1)
    move.w  (0x08, A0), (0x08, A1)
    move.l  A0, (0x40, A1)
    move.w  #0x04, (0x10, A0)
    move.w  #0x00, (0x12, A0)
    rts

.7222:
    ;todo

;----------

_57E86:
    move.w  #0x02, (0x10, A0)
    jsr     0x044C.w
    bcs.w   .7EAC

    move.w  #0x0101, (A1)
    move.w  (0x20, A0), (0x20, A1)
    move.w  (0x24, A0), (0x24, A1)
    move.l  A0, (0x40, A1)
    move.l  A1, (0x56, A0)
.7EAC:
    move.w  (0x20, A0), (0x86, A0)
    move.w  (0x24, A0), (0x88, A0)
    jsr     0x095C.w
    suba.l  #0x1000, A3
    move.l  A3, (0x72, A0)
    move.w  #0x8000, (0x02, A3)
    tst.b   (0x8ED5, A5)
    bne.b   .7EEC

    tst.b   (!heart_dance, A5)
    bne.b   .7EEC

    tst.b   (!stun_potion_dropped, A5)
    bne.b   .7EEC

    jsr     0x05BA.w
    andi.w  #0x1F, D0
    cmpi.w  #0x0B, D0
    bls.b   .7F12

.7EEC:
    addq.b  #1, (0x8EC3, A5)
    cmpi.b  #0x17, (0x8EC3, A5)
    bls.b   .7EFE

    move.b  #0x00, (0x8EC3, A5)
.7EFE:
    moveq   #0x00, D0
    move.b  (0x8EC3, A5), D0
    move.w  D0, (0x08, A0)
    movea.l #0x0DE96E, A4
    jmp     0x0632.w

.7F12:
    cmpi.w  #0x0200, (!stage_frame_counter, A5)
    bls.b   .7EEC

    move.b  #0x01, (!stun_potion_dropped, A5)
    move.w  #0x18, (0x08, A0)
    move.w  (0x08, A0), D0
    movea.l #0x0DE96E, A4
    jmp     0x0632.w

;----------

_7B4F4:
    tst.w   (0x903C, A5)
    bne.w   .B516

    move.w  #0x00, (!enemy_power_up_timer, A5)
    move.b  #0x00, (!enemies_powering_up, A5)
    move.w  #0x01, (0x903C, A5)
    move.b  #0x00, (0x7AAA, A5)
    rts

.B516:
    tst.b   (!heart_dance, A5)
    bne.w   .B564

    tst.b   (0x9041, A5)
    bne.w   .B564

    tst.b   (!enemies_powering_up, A5)
    bne.w   .B56C

    tst.b   (0x7AAA, A5)
    bne.w   .B554

    moveq   #0x00, D0
    move.b  (0x904D, A5), D0
    beq.w   .B554

    lsr.b   #1, D0
    cmp.b   (0x904E, A5), D0
    bhi.w   .B554

    move.b  #0x01, (0x7AAA, A5)
    bra.w   .B580

.B554:
    addq.w  #1, (!enemy_power_up_timer, A5)
    cmpi.w  #0x0500, (!enemy_power_up_timer, A5)
    beq.w   .B580

    rts

.B564:
    move.b  #0x00, (!enemies_powering_up, A5)
.B56A:
    rts

.B56C:
    addq.b  #1, (!enemy_powering_up_timer, A5)
    cmpi.b  #0x90, (!enemy_powering_up_timer, A5)
    bne.b   .B56A

    move.b  #0x00, (!enemies_powering_up, A5)
    rts

.B580:
    move.b  (!enemies_active, A5), D0
    cmp.b   (0x8ECE, A5), D0
    beq.w   .B598

    move.b  #0x01, (!enemies_powering_up, A5)
    move.b  #0x00, (!enemy_powering_up_timer, A5)
.B598:
    move.w  #0x00, (0x7AA4, A5)
    move.w  #0xC0, (0x8ECC, A5)
    rts

;----------

_E7776:
    d32 .77B6, .77BE, .77C6, .77CE, .77D6, .77DE, .77E6, .77EE
    d32 .77F6, .77FE, .7806, .780E, .7816, .781E, .7826, .782E

;these values are likely +1? so 0x01 = 0x00
.77B6: 0x01, 0x02, 0x03, 0x04, 0x01, 0x02, 0x03, 0x04
.77BE: 0x11, 0x12, 0x13, 0x15, 0x11, 0x12, 0x13, 0x15
.77C6: 0x07, 0x08, 0x09, 0x0A, 0x0C, 0x07, 0x08, 0x09
.77CE: 0x39, 0x3C, 0x3D, 0x3E, 0x39, 0x3C, 0x3D, 0x3E
.77D6: 0x16, 0x18, 0x1B, 0x1C, 0x16, 0x18, 0x1B, 0x1C
.77DE: 0x1D, 0x1E, 0x20, 0x21, 0x1D, 0x1E, 0x20, 0x21
.77E6: 0x24, 0x27, 0x28, 0x29, 0x24, 0x27, 0x28, 0x29
.77EE: 0x32, 0x33, 0x35, 0x36, 0x32, 0x33, 0x35, 0x36
.77F6: 0x0D, 0x0E, 0x10, 0x0D, 0x0E, 0x10, 0x0D, 0x0E
.77FE: 0x2B, 0x2C, 0x2B, 0x2C, 0x2B, 0x2C, 0x2B, 0x2C
.7806: 0x2D, 0x2E, 0x2D, 0x2E, 0x2D, 0x2E, 0x2D, 0x2E
.780E: 0x3F, 0x40, 0x3F, 0x40, 0x3F, 0x40, 0x3F, 0x40
.7816: 0x05, 0x06, 0x05, 0x06, 0x05, 0x06, 0x05, 0x06
.781E: 0x2F, 0x30, 0x2F, 0x30, 0x2F, 0x30, 0x2F, 0x30
.7826: 0x31, 0x31, 0x31, 0x31, 0x31, 0x31, 0x31, 0x31
.782E: 0x37, 0x37, 0x37, 0x37, 0x37, 0x37, 0x37, 0x37

;----------

_F046C: ;score table
    ;offsets to following data. points to value + size(=4) + 1), for loading backwards
    d16 0x0068, 0x006C, 0x0070, 0x0074, 0x0078, 0x007C, 0x0080, 0x0084, 0x0088, 0x008C
    d16 0x0090, 0x0094, 0x0098, 0x009C, 0x00A0, 0x00A4, 0x00A8, 0x00AC, 0x00B0, 0x00B4
    d16 0x00B8, 0x00BC, 0x00C0, 0x00C4, 0x00C8, 0x00CC, 0x00D0, 0x00D4, 0x00D8, 0x00DC
    d16 0x00E0, 0x00E4, 0x00E8, 0x00EC, 0x00F0, 0x00F4, 0x00F8, 0x00FC, 0x0100, 0x0104
    d16 0x0108, 0x010C, 0x0110, 0x0114, 0x0118, 0x011C, 0x0120, 0x0124, 0x0128, 0x012C

    d32 0x00000100 ;68
    d32 0x00000500
    d32 0x00001000
    d32 0x00002000
    d32 0x00003000 ;78
    d32 0x00004000
    d32 0x00005000
    d32 0x00006000
    d32 0x00007000 ;88
    d32 0x00008000
    d32 0x00009000
    d32 0x00010000
    d32 0x00015000 ;98
    d32 0x00020000
    d32 0x00025000
    d32 0x00030000
    d32 0x00035000 ;A8
    d32 0x00040000
    d32 0x00045000
    d32 0x00050000
    d32 0x00060000
    d32 0x00070000
    d32 0x00080000
    d32 0x00090000
    d32 0x00100000
    d32 0x01000000
    d32 0x00016000
    d32 0x00032000
    d32 0x00000001
    d32 0x00000005
    d32 0x00800000
    d32 0x00500000
    d32 0x00300000
    d32 0x00200000
    d32 0x00000300
    d32 0x00000050
    d32 0x00000030
    d32 0x00000010
    d32 0x00000200
    d32 0x00000400
    d32 0x00000800
    d32 0x00001600
    d32 0x00003200
    d32 0x00006400
    d32 0x00012800
    d32 0x00025600
    d32 0x00001200
    d32 0x00002400
    d32 0x00004800
    d32 0x00001500

;----------
