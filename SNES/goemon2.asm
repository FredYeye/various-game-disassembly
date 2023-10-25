lorom

{ ;inputs
	!r      = $0010
    !x      = $0040
    !a      = $0080
	!right  = $0100
	!start  = $1000
	!select = $2000
}

{ ;ram
    !buttons_held    = $36
    !buttons_pressed = $38
    !buttons_pressed_p2 = $3A
    !game_state      = $42
    !frame_counter   = $4A
    !lag_frame       = $4C ;"vblank handler busy" bool. set to 1 early in vblank handler, cleared when done
    !game_paused     = $80
    !stage_state     = $84
    !rng             = $8C
    !stage_id        = $98
    !timer           = $AE

    !current_character = $0418
    !health = $0446
    !ryo = $0474
    !helmet_state = $0478
    !helmet_count = $0479
    !armor_state  = $047A
    !armor_count  = $047B
    !lives = $0498

    !current_character_p2 = $04D8

    !status_bar = $1880

    !impact_health = $1B48

    !maneki_neko_counter = $1BA4
}

{ ;game state defines
	!gs_debug = $0007
	!gs_map   = $0008
	!gs_stage = $0009
}

{ ;save ram
    !current_save = $0200
    !stages_cleared = $0238 ;bitfield, 6 bytes

    !save1 = $0800
}

;---------- 80

{ org $80C374 ;C374 - ?
_80C374:
    jsl $80C5BE
    jsl $83EAEA
    lda !game_paused
    bne .C383

    jmp .C413

.C383:
    jsl $83EC7A
    lda $16EE
    beq .C3A7

    lda $1EB0
    bne $80C3A6

    stz $7E
    jsl $80836F
    jsl $80C62A
    jsl $83B150
    lda #$0008
    jml $80877E

    rtl

.C3A7:
    lda !current_character
    beq .C3C3

    lda $0424 ;player state?
    cmp #$0014
    beq .C3C3

    lda $04B8 ;?
    bit #$0001
    beq .C3C3

    lda !buttons_pressed
    bit #!select
    bne .C3DF

.C3C3:
    lda !current_character_p2
    beq .C412

    lda $04E4
    cmp #$0014
    beq .C412

    lda $0578
    bit #$0001
    beq .C412

    lda !buttons_pressed_p2
    bit #!select
    beq .C412

.C3DF: ;select pressed
    lda $9A
    cmp #$0001
    beq .C3EB

    cmp #$0000
    bne .C412

.C3EB:
    lda !stage_id
    cmp #$0074
    bcs .C412

    jsl $83FD47
    cmp #$0002
    bne .C412

    lda $84
    cmp #$0003
    bne .C412

    lda #$0001 : sta !game_paused
    inc $16EE
    jsl $808ADF
    jml $80BC89

.C412:
    rtl

.C413:
    ;todo
}

;---------- 81

{ : org $81EE30 ;EE30 - EE79
_81EE30: ;stage clear status
    dw $0002, $0002, $0002, $8002, $8002, $8002 ;area 1
    dw $0002, $0002, $0002, $0002, $8002, $0002, $0002, $0002
    dw $0002, $0002, $0002, $8002, $8002, $8002, $0002, $0002
    dw $0002, $0002, $0002, $0002, $8002, $0002, $0002, $0002
    dw $8002, $8002, $0002, $0002, $0002, $0002, $8002
}
