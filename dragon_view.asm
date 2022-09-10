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
    ;00: piercia defeated
    ;08: dynamite picked up
    ;12: received map from the formidable woman
    ;16: talked to randy about how to clear the pass
    ;17: talked to the formidable woman before talking to randy
    ;2C: talked to tylon and received the key
    ;4D: gave dynamite to tylon
    ;4F: said "Clear the Pass!" to the formidable woman
    ;51: tylon talked to you after returning from the store
    ;56: said "Not your concern!" to the formidable woman
    ;77: entered store after giving dynamite to tylon
    ;A4: Storehouse door 2 unlocked
    ;B8: opened Storehouse armor chest
    ;E3: Storehouse door unlocked
}


;---------- 12


{ : org $92D7E0 ; D7E0 - D7EF
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
