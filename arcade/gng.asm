;---------- CPS-1 defines

!gfxram = 0x900000

;---------- engine defines

!rank = 0x892A

!weapon_lance_active_count  = 0x8992
!weapon_knife_active_count  = 0x8993
!weapon_torch_active_count  = 0x8994
!weapon_sword_active_count  = 0x8995
!weapon_axe_active_count    = 0x8996
!weapon_discus_active_count = 0x8997

!rank_timer_state = 0x503A
!rank_timer1 = 0x503C
!rank_timer2 = 0x503E
!weapon_cooldown = 0x50E2 ;only axe or other weapons too?

;---------- arthur defines

;absolute
!arthur_p1 = 0xFF079A
!arthur_p2 = 0xFF07FA

;relative to A5(0x8000)
!transform_old_man_timer      = 0x50B4
!current_player               = 0x86D0
!current_player_arthur_offset = 0x8868 ;0xFF079A (P1) or 0xFF07FA (P2)
!arthur_position_x2           = 0x886C
!arthur_position_y2           = 0x886E
!invincibility                = 0x8931 ;i-frames bool
!arthur_action                = 0x8952 ;name? function pointer
!magic_enabled                = 0x895E ;magic bool
!arthur_action2               = 0x8966 ;name? function pointer

;relative to current player/arthur
!arthur_position_x = 0x00
!arthur_position_y = 0x04
!arthur_state      = 0x08 ;bitfield for arthur's current actions (standing, jumping etc...)
!arthur_state2     = 0x09 ;^
!arthur_hp         = 0x10
!arthur_speed_x    = 0x14
!arthur_speed_y    = 0x16
!arthur_gravity    = 0x18
!arthur_weapon     = 0x2C
!stage             = 0x2E
!checkpoint        = 0x2F
;                  = 0x30 ;rank related, "made progress" bool of sorts, 0 = beaten a checkpoint or stage
!arthur_rank_stage_clear = 0x31
!arthur_rank       = 0x32

;arthur_state flags
!state_jump = 0
!state_shot = 1

;----------

;A5: 0x00FF8000 (pointer to middle of RAM)

;----------

_0025BA: ;weapon firing handler?
    move.l  A2, -(A7)
    move.w  #0x0000, D1
    move.w  D1, D2
    move.b  (0x11, A1), D1
    lsl.w   #5, D1
    move.b  (!arthur_weapon, A1), D2
    lsl.w   #2, D2
    add.w   D1, D2
    movea.l (.2604, PC, D2.w), A0
    jsr     (A0)
    bra.w   .25F2

;maybe alternate entry?
    movea.l (A7)+, A2
    btst.b  #0x01, (0x08, A1)
    beq.b   .25E6
    rts

.25E6:
    movea.l (0x34, A1), A0
    move.l  A0, (0x28, A1)
    jmp     0x2880.w

.25F2:
    bset.b  #0x01, (0x08, A1)
    movea.l (A7)+, A2
    move.b  #0x00, (0x0E, A1)
    jmp     0x2880.w

.2604:
    ;not sure how these offsets should be grouped yet
    d32 0x016470, 0x0166EE, 0x016D84, 0x0174F8, 0x01782C, 0x017C82, 0x018412
    d32 0x01634C
    d32 0x01634C ;lance
    d32 _0166AE  ;knife
    d32 0x016D50
    d32 0x0174BE
    d32 _0177EA  ;axe
    d32 0x017C4E ;discus
    d32 0x0183B6, 0x01634C
    d32 0x01634C ;todo

;----------

_002664: ;set new weapon
    movea.l (!current_player_arthur_offset, A5), A0
.2668:
    cmp.b   (!arthur_weapon, A0), D0
    beq.b   .26A0

    moveq   #0x00, D1
    move.b  D0, D1
    move.b  (!arthur_weapon, A0), (0x2D, A0) ;store old weapon at 0x2D
    move.b  D0, (!arthur_weapon, A0)         ;set new weapon
    lea     (0x8992, A5), A0 ;0x0992
    move.b  #0x00, (0, A0, D1.w)
    bsr.w   .26B0
    tst.b   (!magic_enabled, A5) ;0x095E
    beq.b   .269A

    move.b  #0x00, (0x4052, A5) ;0xC052
    jsr     _00614E.61DE.w
.269A:
    jmp     _00614E.l

.26A0:
    rts

;probably alternate entry here
    movea.l (!current_player_arthur_offset, A5), A0 ;0x0868
    move.w  #0x0000, D0
    move.b  (0x2D, A0), D0
    bra.b   .2668

.26B0:
    move.b  #0xFF, (0x885A, A5) ;0x085A
    moveq   #0x00, D0
    move.b  D0, (0x885B, A5) ;0x085B
    move.w  D0, (0x885C, A5) ;0x085C
    move.b  D0, (!weapon_cooldown, A5) ;0xD0E2
    move.b  D0, (0x50DF, A5) ;0xD0DF
    move.w  D0, (0x50E0, A5) ;0xD0E0
    rts

;----------

_0028BA:
    btst.b  #0x01, (0x877A, A5)
    beq.w   .28E0

    move.w  (0x877E,A5), D1
    beq.b   .28D2

    ext.l   D1
    lsl.l   #8, D1
    add.l   D1, (0x04, A1)
.28D2:
    move.w  (0x877C, A5), D1
    beq.b   .28E0

    ext.l   D1
    lsl.l   #8, D1
    add.l   D1, (0x00, A1)
.28E0:
    move.w  (0x16, A1), D1
    add.w   (0x8950, A5), D1
    move.w  D1, (0x16, A1)
    beq.b   .292E

    bpl.b   .2918

    move.w  (0x86A8, A5), D0
    add.w   (0x8944, A5), D0
    cmp.w   (0x04, A1), D0
    blt.b   .2926

    move.w  D0, (0x04, A1)
    move.l  #0xD440, (!arthur_action, A5)
    bra.b   .2910

.290C:
    move.w  D0, (0x04,A1)
.2910:
    moveq   #0x00, D0
    move.w  D0, (0x16, A1)
    bra.b   .292E

.2918:
    move.w  (0x86A8, A5), D0
    add.w   (0x8942, A5), D0
    cmp.w   (0x04, A1), D0
    blt.b   .290C

.2926:
    ext.l   D1
    lsl.l   #8, D1
    add.l   D1, (0x04, A1)
.292E:
    move.w  (!arthur_speed_x, A1), D1
    add.w   (0x894E, A5), D1
    move.w  D1, (!arthur_speed_x, A1)
    beq.b   .2974

    bmi.w   .295E

    move.w  (0x869E, A5), D0
    add.w   (0x8946, A5), D0
    cmp.w   (0x00, A1), D0
    bgt.b   .296C

    move.w  D0, (0x00, A1)
    moveq   #0x00, D0
    ;todo

.295E: ;todo
.296C: ;todo
.2974: ;todo

;----------

_002982: ;probably part of above code
    move.w  (0x894A, A5), (0x894E, A5)
    tst.b   (0x3FD8, A5)
    beq.b   .29D2

    btst.b  #!state_jump, (!arthur_state, A1)
    bne.b   .29CA

    btst.b  #!state_shot, (!arthur_state, A1)
    bne.b   .29BC

    btst.b  #0x01, (!arthur_state2, A1)
    bne.b   .29CA

    cmpi.b  #0x02, (0x11, A1)
    bne.b   .29BC

    btst.b  #0x00, (!arthur_state2, A1)
    beq.b   .29BC

    move.w  #0x1BDB, (0x0A, A1)
.29BC:
    move.w  #0x0000, D0
    move.w  D0, (0x14, A1)
    move.w  D0, (0x894E, A5)
    rts

.29CA:
    ;todo

.29D2:
    cmpi.b  #0x05, (!stage, A1)
    bne.b   .29E8

    btst.b  #!state_jump, (!arthur_state, A1)
    beq.b   0x29E8

    move.w  #0x0000, (0x894E, A5)
.29E8:
    move.w  (0x894C, A5), (0x8950, A5)
    rts

;----------

;hud update code?

_00614E:
    movea.l #!arthur_p1, A4
    tst.b   (!current_player, A5)
    beq.b   .6160

    movea.l #!arthur_p2, A4
.6160:
    tst.b   (0x8768, A5)
    beq.w   .6178

    moveq   #0x00, D0
    move.b  (!arthur_weapon, A4), D0
    bsr.w   .64E8
    moveq   #0x0E, D0
    bra.w   .64E8

.6178:
    moveq   #0x00, D0
    move.b  (!arthur_weapon, A4), D0
    bra.w   .674A

;---

.6194:
    ;todo

;---

.61C0:
    movea.l #!arthur_p1, A4
    tst.b   (!current_player, A5)
    beq.b   .61D2

    movea.l #!arthur_p2, A4
.61D2:
    moveq   #0x00, D1
    move.b  (0x2C, A4), D1
    add.w   D1, D0
    bra.w   .674A

;---

.61DE:
    moveq   #0x00, D0
    move.b  (0x4052, A5), D0
    move.w  (.61EC, PC, D0.w), D1
    jmp     (.61EC, PC, D1.w)

.61EC:
    d16 0x0004, 0x006A

.61F0: ;(0004)
    ;gold armor stuff
    addq.b  #2, (0x4052, A5)
    moveq   #0x00, D0
    move.b  D0, (0x4053, A5)
    move.b  D0, (0x4057, A5)
    move.b  D0, (0x4058, A5)
    move.b  D0, (0x4054, A5)
    move.b  #0x02, (0x4055, A5)
    move.b  D0, (0x4056, A5)
    move.b  D0, (0x8960, A5)
    move.b  D0, (0x8962, A5)
    move.b  D0, (0x8961, A5)
    move.b  D0, (0x895F, A5)
    move.b  #0x01, (!magic_enabled, A5)
    tst.b   (0x8768, A5)
    beq.w   .6246

    move.w  #0x000F, D0
    bsr.w   .64E8
    move.w  #0x0000, D0
    bsr.w   .6194
    bsr.w   .644C
    bra.w   .638A

.6246:
    move.w  #0x0007, D0
    bsr.w   .61C0 ;add closest red dot and redraw weapon
    bsr.w   .644C
    bra.w   .63D8 ;draw the other dots

.6256: ;(006A)
    ;todo

;---

.638A:
    ;todo

;---

.63D8: ;draws the other dots
    movea.l #0x90036C, A0
    move.w  #0x0001, D2
    moveq   #0x00, D0
    move.b  (0x4057, A5), D0
    add.b   D0, D0
    lea     (0x0B4C, PC), A4 ;A4 = 0x6F38
    move.w  (0, A4, D0.w), D1
    lea     (0, A4, D1.w), A4
    move.w  #0x00F, D5
.63FA:
    move.w  (A4)+, D3
    addi.w  #0x2000, D3
    move.w  D3, (0x00, A0)
    move.w  D2, (0x02, A0)
    addi.w  #0x0010, D3
    move.w  D3, (0x04, A0)
    move.w  D2, (0x06, A0)
    lea     (0x80, A0), A0
    dbf     D5, .63FA
    rts

;---

.644C:
    moveq   #0x00, D0
    move.b  (0x4057, A5), D0
    move.b  (0x0E, PC, D0.w), D0
    move.b  D0, (0x4054, A5)
    moveq   #0x00, D1
    rts

;---

.64E8:
    ;todo

;---

.674A: ;draw red dot closest to the weapon icon and/or redraw weapon icon
    lsl.b   #1, D0
    lea     (0x80, PC), A0 ;A0 = 0x67CE
    move.w  (0, A0, D0.w), D0
    lea     (0, A0, D0.w), A0
.6758:
    moveq   #0x00, D0
    moveq   #0x00, D2
    move.l  D2, D1
    lea     !gfxram, A2
    move.b  (A0)+, D2
    lsl.w   #7, D2
    move.b  (A0)+, D1
    add.w   D1, D2
    lea     (0, A2, D2.w), A2
    movea.l A2, A3
    move.w  (A0)+, D1
.6774:
    movea.l A3, A2
    lea     (0x04, A3), A3
.677A:
    move.w  (A0)+, D2
    beq.b   .67A2

    cmpi.w  #0xFFFD, D2
    beq.w   .67A4

    cmpi.w  #0xFFFF, D2
    beq.b   .6758

    cmpi.w  #0xFFFE, D2
    beq.b   .6774

    addi.w  #0x2000, D2
    move.w  D2, (A2)
    move.w  D1, (0x02,A2)
    lea     (0x80, A2), A2
    bra.b   .677A
.67A2:
    rts

.67A4:
    move.w  (A0)+, D2
    addi.w  #0x2000, D2
    move.w  #0x0001, D6
.67AE:
    move.w  D2, (A2)
    move.w  D1, (0x02,A2)
    addi.w  #0x0001, D2
    move.w  D2, (0x80, A2)
    move.w  D1, (0x82, A2)
    lea     (0x04, A2), A2
    addi.w  #0x000F, D2
    dbf     D6, .67AE
    rts

;----------

_009BC2: ;adjust rank (on death, level complete)
    movea.l (!current_player_arthur_offset, A5), A2
    tst.b   (!arthur_rank_stage_clear, A2)
    bne.w   .9C38

    clr.w   (!rank_timer_state, A5)
    move.w  (0x5032, A5), (!rank_timer1, A5) ;5032: base timer1 (set by dips)?
    move.w  (0x5034, A5), (!rank_timer2, A5) ;5034: base timer2 (set by dips)?
    tst.b   (0x86CE, A5)
    beq.b   .9C24

    tst.b   (0x5040, A5)
    bne.b   .9C24

    tst.b   (0x30, A2)
    bne.b   .9C0E

    move.b  #0x01, (0x30, A2)
    move.w  (0x5036, A5), D1
    tst.b   (0x3B, A2)
    beq.b   .9C04

    move.w  (0x5038, A5), D1 ;5038: base rank (set by dips)?
.9C04:
    move.w  D1, (!rank, A5)
    move.w  D1, (!arthur_rank, A2)
    rts

.9C0E: ;no checkpoint reached / stage cleared since last death (?)
    move.w  (!arthur_rank, A2), D1
    subi.w  #0x0008, D1
    bcc.b   .9C1A

    moveq   #0x00, D1
.9C1A:
    move.w  D1, (!arthur_rank, A2)
    move.w  D1, (!rank, A5)
    rts

.9C24:
    move.w  #0x0028, (!rank, A5)
    move.w  #0x1518, (!rank_timer1, A5)
    move.w  #0x0384, (!rank_timer2, A5)
    rts

.9C38: ;adjust rank on clearing stage
    clr.b   (!arthur_rank_stage_clear, A2)
    move.w  (!rank, A5), D1
    subi.w  #0x0008, D1
    bcc.b   .9C48

    moveq   #0x00, D1
.9C48:
    move.w  D1, (!rank, A5)
    rts

;----------

_009C4E: ;rank increase
    move.w  (!rank_timer_state, A5), D0
    move.w  (.9C5A, PC, D0.w), D1
    jmp     (.9C5A, PC, D1.w)

.9C5A:
    d16 0x0006, 0x0016, 0x0038

;---

.9C60: ;(0006)
    subq.w  #1, (!rank_timer1, A5)
    beq.b   .9C68

    rts

.9C68:
    addq.w  #2, (!rank_timer_state, A5)
    bra.w   .9C7C

.9C70: ;(0016)
    subq.w  #1, (!rank_timer2, A5)
    bne.b   .9C92

    move.w  (0x5034, A5), (!rank_timer2, A5)
.9C7C:
    addq.w  #8, (!rank, A5)
    cmpi.w  #0x0078, (!rank, A5)
    bls.b   .9C92

    move.w  #0x0078, (!rank, A5)
    addq.w  #2, (!rank_timer_state, A5)

.9C92: ;(0038)
    rts

;----------

arthur: ;unknown start; placeholder label to have a label to attach sub labels to
    ;A1: arthur (most of time, anyway)

;B5BC: jump based on arthur's state
    movea.l (!arthur_action, A5), A0
    jmp     (A0)

.B5C2:
    ;todo

;---

.BAF2: ;jumping? falling?
    ;todo
;BBA2
    move.w  (!arthur_speed_x, A1), D0
    beq.b   .BBB8

    bmi.b   .BBB2

    move.w  #0x0100, (!arthur_speed_x, A1) ;cap arthur's x speed after falling long enough (right)
    bra.b   .BBB8

.BBB2:
    move.w  #0xFF00, (!arthur_speed_x, A1) ;cap arthur's x speed after falling long enough (left)
.BBB8:
    jsr     0x2A86.w
    ;todo


;---

.C04A:
    move.b  (0x8876, A5), D0
    andi.w  #0x0F, D0
    add.w   D0, D0
    move.w  (.C05C, PC, D0.w), D0
    jmp     (.C05C, PC, D0.w)

.C05C:
    d16 0x0022, 0x0090, 0x00FA, 0x0020, 0x0022, 0x0022, 0x0022, 0x0020
    d16 0x0022, 0x0022, 0x0022, 0x0020, 0x0020, 0x0020, 0x0020, 0x0020

;---

.C07C: ;0020
    rts

;---

.C07E: ;0022
    andi.b  #0b11000000, (!arthur_state2, A1)
    ori.b   #0b00001000, (!arthur_state2, A1)
    move.l  #0xE47C, (0x24, A1)
    move.b  (0x11, A1), D0
    ext.w   D0
    lsl.w   #3, D0
    lea     (.C1CA + 2, PC), A0
    adda.w  D0, A0
    clr.w   (!arthur_speed_x, A1)
    move.w  (A0)+, (!arthur_speed_y, A1) ;jump height
    move.w  (A0)+, (!arthur_gravity, A1)
    clr.b   (0x0E, A1)
    lea     (0x90, A2), A0
    move.l  A0, (0x28, A1)
    bset.b  #0x00, (!arthur_state, A1)
    jsr     0x2A86.w
    ;todo

;---

.C0EC: ;0090
    clr.l   D2
    move.b  #0x84, (!arthur_state2, A1)
    move.l  #0xE382, (0x24, A1)
    move.b  (0x11, A1), D0
    ext.w   D0
    lsl.w   #3, D0
    lea     (.C1CA, PC), A0
    adda.w  D0, A0
    move.w  (A0)+, (!arthur_speed_x ,A1)
    move.w  (A0)+, (!arthur_speed_y ,A1)
    move.w  (A0)+, (!arthur_gravity ,A1)
    clr.b   (0x0E, A1)
    ;todo

;---

.C156: ;00FA
    move.b  #0x44, (!arthur_state2, A1)
    move.l  #0xE402, (0x24, A1)
    move.b  (0x11, A1), D0
    ext.w   D0
    lsl.w   #3, D0
    lea     (.C1CA, PC), A0
    adda.w  D0, A0
    move.w  (A0)+, (!arthur_speed_x, A1)
    move.w  (A0)+, (!arthur_speed_y, A1)
    move.w  (A0)+, (!arthur_gravity, A1)
    move.w  (A0)+, (0x1A, A1)
    neg.w   (!arthur_speed_x, A1)
    neg.w   (0x1A, A1)
    clr.b   (0x0E, A1)
    lea     (0x80, A2), A0
    move.l  A0, (0x28, A1)
    bset.b  #0x00, (!arthur_state, A1)
    ;todo

;---

.C1CA: ;x speed, y speed, gravity
    d16 0x0100, 0x03C0, 0xFFC8, 0x0000
    d16 0x01E6, 0x0420, 0xFFC8, 0x0000
    d16 0x01E6, 0x0420, 0xFFC8, 0x0000
    d16 0x01E6, 0x0420, 0xFFC8, 0x0000

;---

.C380:
    move.w  #0x0000, D0
    move.b  (0x8876, A5), D0
    btst.l  #0x03, D0
    beq.w   .C392

    clr.w   D0
.C392:
    andi.w  #0x0007, D0
    add.w   D0, D0
    move.w  (.C3A0, PC, D0.w), D0
    jmp     (.C3A0, PC, D0.w)

.C3A0:
    d16 0x0012, 0x00A6, 0x014C, 0x0010, 0x0200, 0x0200, 0x0200, 0x0010

;---

.C43E:
    d16 0x00E6, 0x01B3, 0x01B3, 0x01B3 ;walk speed, right

.C446: ;00A6 - walking right
    cmpi.b  #0x82, (!arthur_state2, A1)
    beq.w   .C478

    bclr.b  #0x01, (0x08, A1)
    move.b  #0x82, (!arthur_state2, A1)
    jsr     0x2A86.w
    beq.b   .C468

    jmp     0xB89C.l

.C468:
    move.b  #0x00, (0x0E, A1)
    lea     (0x10, A2), A0
    move.l  A0, (0x28, A1)
    bra.b   .C4AA

.C478:
    jsr     0x2A86.w
    beq.b   .C484

    jmp     0xB89C.l

.C484:
    btst.b  #0x01, (0x08, A1)
    bne.w   .C4C8

    tst.b   (0x0F, A1)
    beq.b   .C49A

    subq.b  #1, (0x0F, A1)
    bra.b   .C4AE

.C49A:
    addq.b  #1, (0x0E, A1)
    cmpi.b  #0x06, (0x0E, A1)
    bne.b   .C4AA

    clr.b   (0x0E, A1)
.C4AA:
    jsr     0x2880.w
.C4AE:
    move.b  (0x11, A1), D0
    ext.w   D0
    add.w   D0, D0
    move.w  (.C43E, PC, D0.w), (!arthur_speed_x, A1)
    move.b  #0x01, (0x8956, A5)
    ;todo

.C4C8:
    ;todo

.C4EC: ;(014C) - walking left
    cmpi.b  #0x42, (!arthur_state2, A1)
    beq.w   .C52A

    clr.b   (0x0E, A1)
    bclr.b  #0x01, (!arthur_state, A1)
    move.b  #0x42, (!arthur_state2, A1)
    jsr     0x2A86.w
    beq.b   .C51A

    jmp     0xB89C.l

.C512:
    d16 0xFF1A, 0xFE4D, 0xFE4D, 0xFE4D ;walk speed, left

.C51A:
    ;todo
.C52A:
    ;todo

;---

.C920: ;adds cape, plays gold armor anim
    move.b  #0xFF, (0x895D, A5)
    bclr.b  #!state_shot, (!arthur_state, A1)
    move.b  #0x11, (0x8957, A5)
    jsr     0x01B742.l
    btst.b  #!state_jump, (!arthur_state, A1)
    beq.b   .C95E

    move.l  #.C948, (!arthur_action2, A5)
.C948: ;waiting for arthur to land to play gold armor anim
    move.w  #0x0000, (0x8876, A5)
    jsr     0xBAF2.l
    btst.b  #!state_jump, (!arthur_state, A1)
    beq.b   .C95E

    rts

.C95E:
    move.b  #0x00, (0x8956, A5)
    andi.b  #0b11000000, (!arthur_state2, A1)
    bset.b  #0x00, (!arthur_state2, A1)
    move.b  #0x00, (0x0E, A1)
    move.l  #0x0148D8, (0x28, A1)
    jsr     0x2880.w
    move.l  #0xE240, (0x24, A1)
    move.l  #0xC998, (!arthur_action2, A5)
    bsr.w   .C9EC
    rts

.C9EC:
    ;todo

;---

.old_man_init: ;D09E
    moveq   #0x00, D0
    move.b  D0, (0x50B0, A5)
    move.b  D0, (0x50B1, A5)
    move.l  #.old_man_run, (!arthur_action, A5)
.old_man_run: ;D0B0
    btst.b  #0x03, (!arthur_state, A1)
    beq.b   .D0CC

    move.b  #0x00, (0x8963, A5)
    move.l  #0xD2B6, (!arthur_action, A5)
    jmp     0xD2B6.l

.D0CC:
    tst.b   (0x885C, A5)
    beq.b   .D0D6

    addq.b  #1, (0x885D, A5)
.D0D6:
    tst.b   (!weapon_cooldown, A5)
    beq.b   .D0E0

    subq.b #1, (!weapon_cooldown, A5)
.D0E0:
    moveq   #0x00, D0
    move.b  (0x50B0, A5), D0
    move.w  (.D0F4, PC, D0.w), D0
    jsr     (.D0F4, PC, D0.w)
    movea.l (!arthur_action2, A5), A0
    jmp     (A0)

.D0F4:
    d16 0x0006, 0x003E, 0x0050

;---

.D0FA: ;0006
    movea.l #0x0141A8, A2
    move.b  #0x00, (0x11, A1)
    move.b  #0x00, (0x12, A1)
    movea.l (0x28, A1), A0
    suba.w  #0x0180, A0
    move.b  (0x0F, A1), D2
    move.l  A0, (0x28, A1)
    jsr     0x2880.w
    move.b  D2, (0x0F, A1)
    move.w  #0x017D, (!transform_old_man_timer, A5)
    addq.b  #2, (0x50B0, A5)
    jmp 0x46DA.w

;---

.D132: ;003E
    tst.w   (!transform_old_man_timer, A5)
    beq.b   .D13E

    subq.w  #1, (!transform_old_man_timer, A5)
    rts

.D13E:
    addq.b  #2, (0x50B0, A5)
    rts

;---

.D144: ;0050
    ;todo

;---

.steel_armor_pickup: ;D260
    move.b  #0x01, (!arthur_hp, A1)
    move.b  #0x01, (0x11, A1)
    move.b  #0x02, (0x12, A1)
    movea.l #0x0144A8, A2
    movea.l (0x34, A1), A0
    adda.w  #0x0180, A0
    move.l  A0, (0x34, A1)
    movea.l (0x28, A1), A0
    adda.l  #0x0180, A0
    move.l  A0, (0x28, A1)
    move.b  (0x0F, A1), D2
    jsr     0x2880.w
    move.b  D2, (0x0F, A1)
    move.l  #arthur.B5C2, (!arthur_action, A5)
    move.b  #0x00, (!invincibility, A5)
    jsr     0x466A.w
    movea.l (!arthur_action2, A5), A0
    jmp     (A0)

;---

.duck_init: ;D526: init duck transform
    move.l  #.duck_run, (!arthur_action, A5)
    move.l  #0xD6EE, (!arthur_action2, A5)
    bclr.b  #!state_shot, (!arthur_state, A1)
    move.b  #0x00, (0x50B6, A5)
    move.b  #0x00, (0x50B7, A5)
.duck_run: ;D548: run duck transform
    btst.b  #0x02, (!arthur_state, A1)
    beq.b   .D572

    btst.b  #0x02, (0x11, A1)
    beq.b   .D564

    addi.w  #0x08, (0x04, A1)
    bclr.b  #0x02, (0x11, A1)
.D564:
    move.l  #0xB658, (!arthur_action2, A5)
    jmp     0xBC14.l

.D572:
    moveq   #0x00, D0
    move.b  (0x50B6, A5), D0
    move.w  (0x0C, PC, D0.w), D0
    jsr     (0x08, PC, D0.w)
    movea.l (!arthur_action2, A5), A0
    jmp     (A0)

    ;todo

;D6EE transform (duck) handling
    ori.b   #0x10, (0x8877, A5) ;0x0877: arthur + 0xDD
    move.w  #0x0000, D7
    move.b  (0x8876, A5), D7 ;0x0876: arthur + 0xDC
    btst.b  #0x00, (!arthur_state, A1)
    beq.b   .D708

    bra.w   .D840

.D708:
    jsr     0x2A96.w
    bne.w   .D88E

    move.w  #0x0000, D0
    move.b  (0x8876, A5), D0 ;0x0876: arthur + 0xDC
    andi.w  #0b11, D0
    add.w   D0, D0
    move.w  (.D726, PC, D0.w), D0
    jmp     (.D726, PC, D0.w)

.D726:
    d16 0x0008, 0x0062, 0x00AA, 0x0008

;D72E (0008) - standing duck?
    move.b  #0x00, (0x8956, A5)
    moveq   #0x00, D0
    move.l  D0, (0x14, A1)
    move.b  D0, (0x0E, A1)
    btst.b  #0x00, (!arthur_state2, A1) ;check flag
    bne.b   .D75E

    andi.b  #0b11000000, (!arthur_state2, A1)
    ori.b   #0b00000001, (!arthur_state2, A1)
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
    cmpi.b  #0x82, (!arthur_state2, A1)
    beq.w   .D818

    clr.b   (0x0E, A1)
    ;todo

;D7D0 (00AA)

.D818: ;todo
.D840: ;todo
.D88E: ;todo

;----------

_00E322: ;maybe part of arthur's code. walking left?
    or.w    D1, D1
    beq.w   .E4E0

    bmi.b   .E34A

    cmp.w   (0x8862, A5), D1
    bgt.b   .E33C

    add.w   D1, (!arthur_position_y, A1)
    lsl.w   #8, D1
    move.w  D1, (!arthur_speed_y, A1)
    rts

.E33C:
    ;todo
.E34A:
    ;todo
.E4E0:
    ;todo

;----------

_0166AE: ;create knife?
    cmpi.b  #0x03, (!weapon_knife_active_count, A5)
    beq.w   .66E2

    move.w  D0, D5
    jsr     0x217A.w
    beq.w   .66E2

    addq.b  #1, (!weapon_knife_active_count, A5)
    jsr     0x26CE.w
    move.b  #0x02, (0x0A, A0)
    bsr.w   .6774
    add.w   D5, D5
    move.w  (.66E6, PC, D5.w), D5
    jsr     (.66E6, PC, D5.w)
    jmp     0x462A.w
.66E2:
    jmp     0x462A.w

.66E6:
    d16 0x00D8, 0x020E, 0x0368 ;todo

;---

.6774:
    ;todo

;---

.68F4: ;(020E)
    ;todo

;----------

_0177EA: ;create axe?
    cmpi.b  #0x02, (!weapon_axe_active_count, A5)
    beq.b   .7820

    tst.b   (!weapon_cooldown, A5)
    bne.b   .7820

    move.w  D0, D5
    jsr     0x217A.w
    beq.b   .7820

    move.b  #0x1E, (!weapon_cooldown, A5) ;weapon cooldown timer
    addq.b  #1, (!weapon_axe_active_count, A5)
    jsr     0x26CE.w
    bsr.w   .786E
    add.w   D5, D5
    move.w  (.7824, PC, D5.w), D5
    jsr     (.7824, PC, D5.w)
    jmp     0x4632.w

.7820:
    jmp     0x4632.w

.7824:
    ;todo

;---

.786E:
    move.b  #0x01, (0x08, A0)
    move.b  #0x05, (0x0A, A0)
    move.b  #0x41, (0x0D, A0)
    move.b  #0x01, (0x11, A0)
    move.b  #0x29, (0x12, A0)
    move.b  #0x02, (0x13, A0)
    move.l  #0x0711BA, (0x30, A0)
    move.l  #0x0179F8, (0x34, A0)
    move.w  #0x0018, (0x38, A0)
    rts

;----------

_01B714: ;gold armor stuff
    movea.l (!current_player_arthur_offset, A5), A0
    move.b  #0x02, (0x11, A0)
    move.b  #0x03, (0x12, A0)
    move.b  #0x00, (0x4052, A5)
    jsr     _00614E.61DE ;creates magic bar
    move.l  #arthur.C920, (!arthur_action2, A5) ;gold armor pickup anim, create cape
    move.b  #0xFF, (!invincibility, A5)
    jmp     0x466A.w

;----------

_03AEC8: ;stage 2 quicksand handler, entry further down
    moveq   #0x00, D2
    move.w  (!arthur_position_x2, A5), D1
    subi.w  #0x05FA, D1
    cmpi.w  #0x0290, D1
    bls.b   .AEF6

    move.w  #0x0A7A, D1
    sub.w   (!arthur_position_x2, A5), D1
    cmpi.w  #0x01E0, D1
    bls.b   .AF4E

.AEE6:
    move.w  #0x0000, (0x894A, A5)
    move.w  #0x0000, (0x894C, A5)
.AEF2:
    moveq   #0x01, D2
    rts

.AEF6:
    tst.b   (0x0B, A1)
    bne.b   .AEF2

    move.b  (0x3627, A5), D0
    andi.b  #0x1F, D0
    bne.b   .AF0A

    jsr     0x474A.w
.AF0A:
    move.w  (!arthur_position_y2, A5), D0
    subi.w  #0x1C, D0
    move.w  (!arthur_position_x2, A5), D1
    cmpi.w  #0x07EF, D1
    bcc.b   .AF3C

    cmpi.w  #0x00F0, D0
    bhi.b   .AEE6

    clr.b   (0x45, A1)
    move.w  #0x0080, D3 ;speed modifier, first slope
    sub.w   (0x4C, A1), D1
    bmi.b   .AF3A

    move.b  #0x01, (0x45, A1)
    move.w  #0xFF20, D3 ;speed modifier, second slope (first half)
.AF3A:
    rts

.AF3C:
    cmpi.w  #0x0130, D0
    bhi.b   .AEE6

    move.b  #0x01, (0x45, A1)
    cmpi.w  #0x0130, D0
    bhi.b   .AEE6

    move.b  #0x01, (0x45, A1)
    move.w  #0xFF20, D3 ;speed modifier, second slope (second half)
    rts

.AF4E:
    cmpi.b  #0x02, (0x0B, A1)
    bne.b   .AEF2

    move.b  (0x3627, A5), D0
    andi.b  #0x1F, D0
    bne.b   .AF64

    jsr     0x474A.w
.AF64:
    move.w  (!arthur_position_y2, A5), D0
    subi.w  #0x001C, D0
    move.w  (!arthur_position_x2, A5), D1
    cmpi.w  #0x0A0E, D1
    bhi.b   .AF98

    cmpi.w  #0x0120, D0
    bhi.w   .AEE6

    move.w  #0x00E0, D3 ;speed modifier, third slope
    clr.b   (0x45, A1)
    sub.w   (0x4C, A1), D1
    bmi.b   .AF96

    move.w  #0xFF20, D3 ;speed modifier, fourth slope (first half)
    move.b  #0x01, (0x45, A1)
.AF96:
    rts

.AF98:
    cmpi.w  #0x0140, D0
    bhi.w   .AEE6

    move.b  #0x01, (0x45, A1)
    move.w  #0xFF20, D3 ;speed modifier, fourth slope (second half)
.AFAA:
    rts

;---

.AFAC: ;stage 2 quicksand handler entry (for x speed, in any case)
    bsr.w   _03AEC8
    dbf     D2, .AFAA

    move.b  (0x8939, A5), D0
    bne.b   .AFC4

    move.w  D3, (0x894A, A5) ;set quicksand X speed
    clr.w   (0x894C, A5)
.AFC2:
    rts

.AFC4:
    move.b  (0x48, A1), D1
    eori.b  #0x01, D1
    and.b   D1, D0
    cmpi.b  #0x01, D0
    bne.b   .AFC2

    movea.l (!current_player_arthur_offset, A5), A2
    move.w  #0x0300, (!arthur_speed_y, A2) ;cap quicksand jump height
    tst.b   (0x45, A1)
    beq.b   .B00A

    tst.b   (0x8938, A5)
    beq.b   .B002

    cmpi.b  #0x01, (0x8938, A5)
    beq.b   .AFFA

    move.w  #0x0120, (!arthur_speed_x, A2)
    rts

.AFFA:
    move.w  #0xFE00, (!arthur_speed_x, A2)
    rts

.B002:
    move.w  #0xFF00, (!arthur_speed_x, A2)
    rts

.B00A:
    tst.b   (0x8938, A5)
    beq.b   .B028

    cmpi.b  #0x01, (0x8938, A5)
    beq.b   .B020

    move.w  #0x0200, (!arthur_speed_x, A2)
    rts

.B020:
    move.w  #0xFEE0, (!arthur_speed_x, A2)
    rts

.B028:
    move.w  #0x0100, (!arthur_speed_x, A2)
    rts

;----------

_0489B0: ;armor upgrade
    andi.b  #0xDF, (0x13, A1)
    movea.l (!current_player_arthur_offset, A5), A2
    cmpi.b  #0x03, (0x12, A2)
    beq.w   .8A14

    move.b  (0x11, A2), D0
    beq.w   .8A20

    btst.b  #0x02, (0x11, A2)
    bne.w   .8A20

    btst.b  #0x02, (!arthur_state, A2) ;check if arthur is standing?
    bne.w   .8A20

    tst.b   (!arthur_hp, A2)
    beq.w   .89F0

    tst.b   (0x40, A1)
    bne.w   .8A06

.89F0:
    cmpi.b  #0x02, (0x12, A2)
    beq.w   .8A14

    move.l  #arthur.steel_armor_pickup, (!arthur_action, A5)
    bra.w   .8A14

.8A06:
    cmpi.b  #0x03, (0x12, A2)
    beq.b   .8A14

    jsr     _01B714
.8A14:
    andi.b  #0xFD, (0x13, A1)
    bset.b  #0x03, (!arthur_state, A1)
.8A20:
    jmp     0xDC34.l

;----------

; A0, A1: magician projectile object slot
; A2: magician object slot

_0496B2: ;create magician projectile
    moveq   #0x00, D0
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
    moveq   #0x00, D0
    move.b  (0x41, A1), D0 ;use direction as offset
    lsl.w   #2, D0
    lea     (0x10, PC, D0.w), A0
    move.w  (0x00, A0), (0x14, A1) ;x speed
    move.w  (0x02, A0), (0x16, A1) ;y speed
    rts

;---

_049818: ;magician projectile hitting arthur
    andi.b  #0xDF, (0x13, A1)
    tst.b   (!invincibility, A5)
    bne.w   .9884

    clr.b   (0x13, A1)
    movea.l (!current_player_arthur_offset, A5), A2
    tst.b   (!arthur_hp, A2)
    beq.w   .983E

    bsr.w   .988A
    bra.w   .9842

.983E: ;0 hp (underwear)
    bsr.w   .98A2
.9842:
    move.b  #0x29, (0x12, A1)
    move.l  #0x049936, (0x2C, A1)
    clr.l   (0x14, A1)
    move.w  (!arthur_position_y2, A5), D0
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
    move.l  #arthur.duck_init, (!arthur_action, A5)
.98A0:
    rts

.98A2:
    tst.b   (0x11, A2)
    bne.w   .98AE

    bra.w   .98B6

.98AE:
    move.l  #arthur.old_man_init, (!arthur_action, A5)
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

;----------
