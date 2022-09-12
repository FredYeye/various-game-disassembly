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
    ;7E2040 = temp events? like cleared rooms etc
}


;event list
{
    ;00: Storehouse | piercia defeated
    ;08: Storehouse | dynamite picked up
    ;10: Hujia      | talked to randy about how to clear the pass
    ;11: Hujia      | talked to the formidable woman before talking to randy
    ;12: Hujia      | received map from the formidable woman
    ;2C: Hujia      | talked to tylon and received the key
    ;41: Map        | warp A
    ;42: Map        | warp B
    ;4D: Hujia      | gave dynamite to tylon
    ;4F: Hujia      | said "Clear the Pass!" to the formidable woman
    ;51: Hujia      | tylon talked to you after returning from the store
    ;56: Hujia      | said "Not your concern!" to the formidable woman
    ;5D:            | sword technique
    ;77: Hujia      | entered store after giving dynamite to tylon
    ;8B: Wet Cavern | started the "100 demons killed" quest
    ;8D: North Cave | Bow chest
    ;A4: Storehouse | door 2 unlocked
    ;A5: Wet Cavern | 1000 jade chest
    ;AA: Fall       | Lightning ring chest
    ;B8: Storehouse | armor chest
    ;DA: Galys pass | hp up
    ;E3: Storehouse | door unlocked
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

    lda !event_flags+8
    ora $0390
    sta !event_flags+8 ;store "warp activated" bit
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
