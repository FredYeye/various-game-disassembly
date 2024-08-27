; mystwarrj

; memory map
!ram     = 0x200000
!K055555 = 0x480000
!K054338 = 0x48A000

; K055555 defines
!K055555_blend_enables   = !K055555 + 0x42 ; reg 33
!K055555_vinmix_on       = !K055555 + 0x44 ; reg 34
!K055555_osblend_enables = !K055555 + 0x46 ; reg 35
!K055555_osblend_on      = !K055555 + 0x48 ; reg 36
!K055555_shad2_pri       = !K055555 + 0x4C ; reg 38
!K055555_shd_on          = !K055555 + 0x50 ; reg 40

; K054338 defines
!K054338_background_R = 0x01
!K054338_background_G = 0x02
!K054338_background_B = 0x03
!K054338_shadow2_R = 0x0A
!K054338_shadow2_G = 0x0C
!K054338_shadow2_B = 0x0E
!K054338_blend_amount = 0x1B

;----------

_0346E:
    movea.l !ram + 0x10, A6
    move.w  D7, (A6)+
    cmpa.l  #!ram + 0x06FF, A6
    bls     .3456

    movea.l #!ram + 0x540, A6
.3456:
    move.l  A6, !ram + 0x10
    rts

;---

_0CBE8:
    move.b  #0x1F, !K055555_shd_on
    lsl.b   #2, D4
    move.b  D4, !K055555_shad2_pri
    move.w  D5, !ram + 0xB2
    move.w  D5, !K054338_shadow2_R
    move.w  D6, !ram + 0xB4
    move.w  D6, !K054338_shadow2_G
    move.w  D7, !ram + 0xB6
    move.w  D7, !K054338_shadow2_B
    rts

;---

_0CCE6: ; mystic warriors calligraphy -> logo transition, prob more
    move.b  #0x00, !K055555_osblend_enables
    move.b  #0x03, !K055555_osblend_on
    move.b  #0x00, !K055555_blend_enables
    move.b  #0xF3, !K055555_vinmix_on
    rts

;---

_0CD76:
    moveq   #0x00, D5
    moveq   #0x00, D6
    moveq   #0x00, D7
    move.b  D5, !ram + 0xA9
    move.b  D5, !K054338_background_R
    move.b  D6, !ram + 0xAA
    move.b  D6, !K054338_background_G
    move.b  D7, !ram + 0xAB
    move.b  D7, !K054338_background_B
    rts

;----------

_7684C: ; intro cutscene fade start: "But behind the scenes..."
    addq.w  #1, (0x04, A6)
    move.w  #0x2180, D7
    jsr     _0346E.l
    jsr     _0CCE6.l
    move.b  #0x1F, !ram + 0xC3
    move.b  !ram + 0xC3, !K054338_blend_amount
    rts

;---

_768C0: ; fade update
    move.w  (0x0C, A6), D0
    sub.w   (0x0E, A6), D0
    move.w  D0, (0x0C, A6)
    lsr.w   #8, D0
    move.b  D0, !ram + 0xC3
    move.b  !ram + 0xC3, !K054338_blend_amount
    bgt     .68EC

    addq.w  #1, (0x04, A6)
    move.w  #0x50, (0x06, A6)
.68EC:
    rts

;---
