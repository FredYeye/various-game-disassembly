lorom


;toggle register widths
{
    !A8   = "sep #$20"
    !A16  = "rep #$20"

    !X8   = "sep #$10"
    !X16  = "rep #$10"

    !AX8  = "sep #$30"
    !AX16 = "rep #$30"
}


;dragon view defines
{
    !event_flags = $7E2000
    ;$7E2040 = temp events, like cleared rooms etc

    !items = $7E2100 ;item count / level etc
    !fire_ring_level = $7E210A ;210B is also related to the fire ring, not sure what it is
    !sword_level = $7E211A
    !hauza_level = $7E211C
    !armor_level = $7E2120
    !equipped_item = $7E212E

    !level = $7E7094
    !xp = $7E7095

    !attack_power = $98E9
    !weapon_technique_active = $98EB
    !hauza_technique_timer = $A32D

    !golden_sandworm_encounter_count = $7EE7AE
}


;object defines
{
    ;obj size = $100
    !obj_id         = $7E6F9A
    !obj_pos_x      = $7E6F9D
    !obj_attack     = $7E6FC6
    !obj_defense    = $7E6FC8
    !obj_hp_current = $7E6FCA
    !obj_hp_max     = $7E6FCB

    ;00 = lizard knight (green)
    ;02 = beetle (blue)
    ;05 = scorpion (orange)
    ;10 = slime (blue)
    ;33 = frozen horror (pillar thing?)
}


;equipment
{
    !bomb = $01
    !fire_ring = $05
    !ice_ring = $06
    !lightning_ring = $07
}


;event list
{
    ; 00: Storehouse      | piercia defeated
    ; 01: Fire Cave       | fire ring chest
    ; 02: Fortress        | frozen horror defeated
    ; 03: Keire Temple    | meeting giza
    ; 04: Ortah Temple    | joker defeated
    ; 05: Sektra Temple   | water dragon defeated
    ; 08: Storehouse      | dynamite picked up
    ; 0B:                 | played horn with score outside Quicksand
    ; 0D: Forest          | talked to woodland guardian
    ; 0E: Underworld Cave | entered cave
    ; 10: Hujia           | talked to randy about how to clear the pass
    ; 11: Hujia           | talked to the formidable woman before talking to randy
    ; 12: Hujia           | received map from the formidable woman
    ; 14: Keire Temple    | received map from prof. Methraton
    ; 16: Fire Cave       | entered cave
    ; 18: Miraj           | talked to lord yuna
    ; 1A: Sektra Temple   | soldrak
    ; 1E: Miraj           | received map from yuna
    ; 23: Ortah Temple    | map chest
    ; 24: Casdra          | received map from monk
    ; 29: Fortress        | received map from monk
    ; 2C: Hujia           | talked to tylon and received the key
    ; 38:                 | fire ring upgrade (s/w from casdra)
    ; 3B:                 | lightning ring up (right)
    ; 3C:                 | lightning ring up (left)
    ; 3F: Keire Temple    | 2nd room: talked to 2nd wizard
    ; 40: Keire Temple    | 2nd room: wizard rushes to you and talks
    ; 41: Map             | warp A (rysis)
    ; 42: Map             | warp A (north cave)
    ; 44: Map             | warp D (jade mine)
    ; 4B: Casdra          | talked to monk (before or after getting the fire ring)
    ; 4D: Hujia           | gave dynamite to tylon
    ; 4F: Hujia           | said "Clear the Pass!" to the formidable woman
    ; 51: Hujia           | tylon talked to you after returning from the store
    ; 54: Miraj           | received key from ruth
    ; 56: Hujia           | said "Not your concern!" to the formidable woman
    ; 59: Ortah Temple    | talked to dragon lords
    ; 5D:                 | sword technique
    ; 5E:                 | hauza technique
    ; 61: Keire Temple    | talked to prof. Methraton
    ; 68: Hujia           | breeze map
    ; 6A: Hujia           | ? opened right chest first
    ; 6B: Miraj           | used key
    ; 6D: Miraj           | woman saw your pendant
    ; 77: Hujia           | entered store after giving dynamite to tylon
    ; 7A: Orusort         | talked to setia
    ; 87: Ortah Temple    | talked to dragon lords a second time, teleport
    ; 88:                 | hauza up (near chest game)
    ; 8B: Wet Cavern      | started the "100 demons killed" quest
    ; 8D: North Cave      | Bow chest
    ; 91: Fire Cave       | mp up
    ; 92: Fortress        | hauza energy
    ; 93: Fortress        | mp up chest
    ; 95: Fortress        | mp crystal chest
    ; 96: Fortress        | mp up
    ; 9A: Snowfield       | mp up
    ; 9B: To Landslide    | hp up
    ; A4: Storehouse      | door 2 unlocked
    ; A5: Wet Cavern      | 1000 jade chest
    ; AA: Fall            | lightning ring chest
    ; AB: Mt. Badsel 2    | mp up
    ; AF: Old Well        | talked to old man
    ; B0: Underworld Cave | argos cutscene
    ; B1: Hujia           | fairy statue
    ; B2: Neil Ruins      | blessing
    ; B7: Jade Mine       | the machine is on
    ; B8: Storehouse      | armor chest
    ; BB: Jade Mine       | talked to fess
    ; C0:                 | mirror chest
    ; C4: Jade Mine       | turned Fess back to normal
    ; C5: Jade Mine       | jade demon defeated
    ; C6: Ortah Temple    | talked to dragon lords (2)
    ; CD:                 | fire boots
    ; D2: Mt. Badsel 2    | defeated efreet
    ; D3: Mt. Badsel 2    | defeated piercia
    ; D4: Mt. Badsel 2    | defeated piercia 2
    ; D5: Miraj           | score
    ; D6:                 | mp up (chest game near Snowfield)
    ; D7: Fire Cave       | efreet defeated
    ; DA: Galys pass      | hp up
    ; DF: Fire Cave       | sword upgrade chest
    ; E1: Ice Cavern      | armor up
    ; E3: Storehouse      | door unlocked
    ; FC: Fortress        | taken the teleporter
    ; FF: Ortah Temple    | entering
    ;100: Quicksand       | talking to strange woman
    ;101:                 | found horn at golden sandworm encounter
    ;102: Quicksand       | told the strange woman you found the horn
    ;103: Quicksand       | finished talking to strange woman
    ;104: Quicksand       | played the horn for the strange woman
    ;105: Old Well        | read tablet

    ;0xx
    !event_hujia_randy_clear_pass = $10
    !event_hujia_formidable_woman_talk_before_randy = $11
    !event_hujia_formidable_woman_map = $12
    !event_hujia_formidable_woman_clear_pass = $4F

    ;1xx
    !event_found_horn = $01
    !event_quicksand_strange_woman_show_horn = $02
    !event_quicksand_strange_woman_play_horn = $04
}


;script macros
{
    macro set_flag(id)
        db $03, <id>
    endmacro

    macro dialogue(id)
        db $05, <id>
    endmacro

    macro check_flag(id)
        db $0D, <id>
    endmacro

    macro goto_eq(offset) ;goto if previous check is true
        db $0E : dw <offset>
    endmacro

    macro set_flag2(id)
        db $10, <id>
    endmacro

    macro check_flag2(id)
        db $12, <id>
    endmacro

    macro _21()
        db $21
    endmacro

    macro _23(x)
        db $23 : dw <x>
    endmacro

    macro goto(offset)
        db $2A : dw <offset>
    endmacro

    macro CA()
        db $CA
    endmacro
}


;---------- 00


{ : org $80B174 ;B174 - B1AA
_80B174:
    !A16
    lda $02
    sec
    sbc #$0060
    cmp #$002A
    bcc .B1A3

    and #$00FF
    !A8
    lda $038E
    cmp #$02
    beq .B199

    lda !event_flags+$08
    ora $0390
    sta !event_flags+$08 ;store "warp activated" bit
    rts

.B199:
    lda $038B
    bne .B1A3
    lda #$03
    sta $038B
.B1A3:
    !A16
    and #$00FF
    !A8
    rts
}


{ : org $80ECE9 ;ECE9 - ED36
add_xp:
    lda !level
    cmp #$2E ;max level is 2D... hmm
    bcc .ECF2

    rtl

.ECF2:
    phy
    lda #$FF
    sta $7EE7B3
    lda !obj_id,X
    !A16
    asl
    tax
    lda $44
    and #$00FF
    cmp #$0001
    bne .ED18

    lda enemy_xp,X
    lsr #2
    clc
    adc enemy_xp,X ;increase xp by 25% if $44 = 01 (overworld enemy)
    bra .ED1C

.ED18:
    lda enemy_xp,X
.ED1C:
    clc
    adc !xp
    sta !xp
    lda #$0000
    adc !xp+2
    sta !xp+2
    and #$00FF
    !A8
    ply
    rtl
}


{ ;ED37 - EDD5
_80ED37: ;xp requirement
    phx
    ldy #$0001
    lda !level
    cmp #$22
    bcc .ED50

    ;level 35 and above
    pha
    sec
    sbc #$20
    tay
    pla
    cmp #$2C
    bcc .ED50

    ;level 45
    ldy #$000D
.ED50:
    !A16
    asl
    tax
    stz $02
    lda $80ED7C,X
    asl
    rol $02
    dey
    beq .ED73

.ED60:
    clc
    adc $80ED7C,X
    sta $00
    lda $02
    adc #$0000
    sta $02
    lda $00
    dey
    bne .ED60

.ED73:
    sta $00
    and #$00FF
    !A8
    plx
    rtl

.ED7C:
    dw $0004, $000D, $0020, $003E, $006C, $00AB, $0100, $016C, $01F4, $0299, $0360, $044A
    dw $055C, $0697, $0800, $0998, $0B64, $0D65, $0FA0, $1216, $14CC, $17C3, $1B00, $1E84
    dw $2254, $2671, $2AE0, $2FA2, $34BC, $3A2F, $4000, $4630, $4CC4, $53BD, $5B20, $62EE
    dw $6B2C, $73DB, $7D00, $869C, $90B4, $9B49, $A660, $B1FA, $BE1C
}


{ ;EDD6 - ?
enemy_xp:
    dw $0006
    dw $0017
    dw $0002 ;beetle (blue)
    dw $0007
    dw $0003
    dw $0005 ;scorpion (orange)

}
;---------- 01


{ : org $8189F3 ;89F3 - 8A83
_8189F3: ;dealing damage to enemy
    ldy $DB
    lda $7088,Y
    bne .8A2C

    lda #$80 : jsl $898559
    ldx $7041,Y
    clc
    lda $6FC6,X ;weapon damage
    adc !attack_power
    bcc .8A0E

    lda #$FF
.8A0E:
    sec
    sbc $6FC8,Y ;enemy defense
    beq .8A16

    bcs .8A18

.8A16:
    lda #$01 ;set damage to 1 if <= 0
.8A18:
    sta $00
    lda !weapon_technique_active
    beq .8A76

    clc
    lda $00
    adc #$0A ;add 10 for weapon techniques
    bcc .8A28

    lda #$FF
.8A28:
    sta $00
    bra .8A76

.8A2C:
    lda #$00
    sta $7088,Y
    lda !equipped_item
    cmp #!fire_ring
    beq .8A42

    cmp #!ice_ring
    beq .8A42

    cmp #!lightning_ring
    beq .8A42

    rts

.8A42:
    sta $0C
    asl #2
    tax
    lda $81BEA0,X : sta $00
    lda $81BEA1,X : sta $01
    lda $81BEA2,X : sta $02
    lda.w !obj_id,Y
    tay
    lda [$00],Y
    sta $08
    lda $7E9B29
    tax
    lda $81BE97,X : sta $06
    jsr multiply
    ldy $DB
    lda $0A
    inc
    sta $00
.8A76:
    sec
    lda $6FCA,Y ;enemy hp
    sbc $00
    bcs .8A80

    lda #$00
.8A80:
    sta $6FCA,Y ;enemy hp
    rts
}


{ : org $81A3AA ;A3AA - A3D2
multiply: ;$0A = $06 * $08
    stz $0A
    stz $0B
    lda $06
    beq .A3D2

    lda $08
    beq .A3D2

    stz $07
    !A16
    ldy #$0008
.A3BD:
    lsr $08
    bcc .A3C8

    lda $0A
    clc
    adc $06
    sta $0A
.A3C8:
    asl $06
    dey
    bne .A3BD

    lda #$0000
    !A8
.A3D2:
    rts
}


{ ;? - ?
org $81BE97 ;ring damage multiplier
db 1, 2, 4 ;ice ring
db 2, 3, 4 ;fire ring
db 1, 2, 4 ;lightning ring

;damage?
org $81BEC0 : fire_ring_table:
    ;    0    1    2    3    4    5    6    7    8    9    A    B    C    D    E    F
    db $0A, $14, $0A, $0A, $14, $0A, $05, $01, $14, $12, $0A, $0F, $01, $05, $01, $0A
    db $0C, $05, $0C, $03, $0F, $05, $07, $0A, $02, $0F, $0A, $07, $01, $0A, $0F, $0A
    db $14, $0A, $0A, $05, $0A, $0C, $05, $0A, $0A, $08, $01, $02, $01, $0A, $0A, $00
    db $0A, $00, $0A, $0A, $02, $08, $0A, $0A, $00, $0A, $0A, $0A, $0A, $0A, $0A, $0A
    db $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A
    db $00, $0A, $0A

org $81BF13 : ice_ring_table:
    db $0A, $0A, $0A, $08, $0A, $0A, $0F, $14, $01, $02, $0A, $0A, $01, $11, $01, $14
    db $0A, $05, $0A, $03, $0C, $05, $07, $06, $14, $05, $0A, $0F, $01, $0A, $08, $08
    db $0A, $0A, $0A, $05, $08, $0A, $05, $0A, $0A, $06, $01, $02, $14, $0A, $0A, $0A
    db $0A, $0A, $00, $00, $02, $00, $0A, $0A, $00, $0A, $0A, $0A, $0A, $0A, $0A, $0A
    db $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A
    db $0A, $0A, $05

org $81BF66 : lightning_ring_table:
    db $0A, $0A, $0A, $0F, $0A, $0A, $0A, $0A, $0A, $0C, $0A, $0E, $01, $0A, $01, $0A
    db $0A, $05, $0A, $0C, $0F, $0F, $0A, $08, $0A, $0A, $0A, $0A, $01, $0A, $0A, $0A
    db $0A, $0A, $0A, $05, $0A, $0B, $08, $0A, $0A, $08, $0A, $0A, $02, $0A, $0A, $05
    db $0A, $05, $05, $05, $02, $05, $0A, $0A, $00, $0A, $0A, $0A, $0A, $0A, $0A, $0A
    db $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A
    db $05, $0A, $05
}


;---------- 12


{ : org $92D7E0 ;D7E0 - D7EF
bit_flags: dw $01, $02, $04, $08, $10, $20, $40, $80
}


{ : org $92DA18 ;DA18 - DA2C
_92DA18: ;get flag byte & bit offset
    iny
    sta $04
    and #$0007
    asl
    tax
    lda.l bit_flags,X
    sta $06
    lda $04
    lsr #3
    tax
    rts
}


{ : org $92DA55 ;DA55 - DA66
_92DA55: ;set event flag
    !A16
    lda [$A8],Y
    and #$00FF
    jsr _92DA67
    !A16
    and #$00FF
    !A8
    rts
}


{ ;DA67 - DA7D
_92DA67:
    jsr _92DA18
    !A16
    and #$00FF
    !A8
    lda !event_flags,X
    ora $06
    sta !event_flags,X ;store flag bit
    !A16
    rts
}


;---------- 17


{ : org $97809F ;809F - 80C0
hauza_set_damage:
    phx
    !A16
    lda !hauza_damage
    and #$00FF
    tax
    !A16
    and #$00FF
    !A8
    lda $9780BB,X
    plx
    sta $7E6FC6,X
    rtl

hauza_damage: db 00, 20, 30, 40, 50, 60
}


{ ;? - ?
org $9780DD : sword_damage: db 00, 15, 25, 35, 45, 55
}


;---------- 19


{ : org $99CACF ;CACF - ?
_99CACF:
    ;...
org $99CB2C
    lda $801900
    sta $0E
    cmp #$03 ;check: current area?
    bne .CB49

    lda !event_flags+$20
    and #$03
    cmp #$01 ;check: talked to strange woman & doesn't have horn
    bne .CB49

    lda !golden_sandworm_encounter_count
    inc
    sta !golden_sandworm_encounter_count
    jsl $80E3BC ;rng
    and #$07
    clc
    adc !golden_sandworm_encounter_count
    cmp #$0E ;check: if counter + 0..=7 >= 14, get golden sandworm
    bcc .CB49

    ;...
.CB49:
    ;...
}


;---------- 1C


{ : org $9C8A14 ;8A14 - ?
_9C8A14:
    ;...
    org $9C8A78
    ldx $7041
    lda $6FFC,X ;loads $73FC when stepping into spikes
    sta $BB92   ;decides spike damage direction
    jsr $9668
}


{ : org $9C8B67 ;8B67 - 8B98
_9C8B67:
    lda $7012
    bne .8B98

    lda $BB8A
    dec
    bpl .8B74

    lda #$00
.8B74:
    sta $BB8A
    lda $BB8A
    beq .8B89

    lda $BB92 ;80 = right, 00 = left
    beq .8B86

    jsr $90CB
    bra .8B89

.8B86:
    jsr $92BF
.8B89:
    lda $6FD4
    bne .8B98

    lda $6FD3
    and #$C0
    bne .8B98

    stz $6FD5
.8B98:
    rts
}

;---------- 1E


{ ;? - ?
    org $9EDAD6 : %check_flag2(!event_found_horn)
    org $9EDB00 : %set_flag2(!event_quicksand_strange_woman_show_horn)
    org $9EDB52 : %set_flag2(!event_quicksand_strange_woman_play_horn)
}


;---------- 20


{ ;? - ?
_A08D89:
    org $A08D89 : %check_flag(!event_hujia_formidable_woman_map)
    %goto_eq($8DEA)
    %check_flag(!event_hujia_formidable_woman_clear_pass)
    %goto_eq($8DE5)
    %check_flag(!event_hujia_randy_clear_pass)
    %goto_eq($8DB0)
    %check_flag($11)
    %goto_eq(.8DAB)
    %_21()
    %dialogue($07)
    %dialogue($0A)
    %set_flag(!event_hujia_formidable_woman_talk_before_randy)
.8DA4:
    %CA()
    %_23($0004)
    %goto($8D5A)

.8DAB:
    %dialogue($0A)
    %goto(.8DA4)

    ;-----

    org $A0ABD4 : %set_flag($83)
    %set_flag($3E)
}


;---------- 23


{ : org $A3815C ;815C - 8189
_A3815C: ;hauza weapon technique
    inc !hauza_technique_timer
    lda !hauza_technique_timer
    cmp #$10 ;turn off tech bonus damage after 16 frames
    beq .8168

    plb
    rtl

.8168:
    lda #$00   : sta $80003E : sta $80003F
    ldx #$0000 : stx $A329 : stx $A331
    lda #$00   : sta $6F47
    lda #$03   : sta $A339
    stz !hauza_technique_timer
    plb
    rtl
}
