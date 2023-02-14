{
    !frame_counter = $02
    !stage = $EA
}

{
    ;lists for... player projectiles & dust clouds, at least
    !proj_x_speed = $0C70
    !proj_y_speed = $0C80
    !proj_x_pos   = $0C90
    !proj_y_pos   = $0CA0

    ;obj struct
    !obj_x_pos   = $1014
    !obj_y_pos   = $1016
    !obj_type    = $101A
    !obj_x_speed = $101C
    !obj_y_speed = $101E
}

{
_00CAE5:
    ldy #$0018 : jsr $CE10
    ldx #$E000 : jsr $8C94
    ldy #$0B03 : ldx #$6000 : jsr $8C94
    ldy #$1811 : ldx #$7000 : jsr $8C94
    lda !stage
    cmp #$0001 ;is this stage 2?
    bne .CB19  ;if not, branch

    lda !frame_counter
    and #$0007
    cmp #$0004
    bcc .CB26

    lda #$0006
    bra .CB26

.CB19:
    lda !frame_counter
    and #$0007
    cmp #$0007 ;is this sage ID 7 (cat)?
    bne .CB26  ;if not, branch

    lda #$0002 ;replace cat with sage ID 2 (lady)
.CB26:
    sta $0150 ;store sage ID
    ;todo
}

{
_05DF15: ;lady, drop items
    lda #$0501 : sta $12 ;threadspool
    lda #$0610 : sta $14 ;crystal
    lda #$0730 : sta $16 ;dog
    lda #$0140 : sta $18
    lda $7EE018,X
    beq .DF64

    ;todo

.DF64:
    lda $0F82
    and #$00FE
    bne .DFA8

    lda $7FF000,X
    tay
    lda $DFA9,Y
    and #$00FF
    tsb $0F82
    tya
    asl #2
    tay
    lda $12 : sta $123C   ;store threadspool in slot
    lda $DFB1,Y : sta $10 ;get next slot
    lda $14 : sta ($10)   ;store crystal
    lda $DFB3,Y : sta $10 ;next slot
    lda $16 : sta ($10)   ;store dog
    ;todo
.DFA8:
    rts
}

{
_05F05E: ;sage code entry?
}