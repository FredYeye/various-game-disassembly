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

    ;$6F9D = x pos (2D)
    ;$6FCA = current hp
    ;$6FCB = max hp

    !attack_power = $98E9
    !weapon_technique_active = $98EB
    !hauza_technique_timer = $A32D

    !golden_sandworm_encounter_count = $7EE7AE
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
    lda $7E212E
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
    lda $6F9A,Y
    tay
    lda [$00],Y
    sta $08
    lda $7E9B29
    tax
    lda $81BE97,X : sta $06
    jsr $A3AA
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
